
CREATE     proc [dbo].[vul_ggz_zorgprestatie] AS
--exec DM_ZORG..vul_f_ggz_zorgprestatie
/*## 
 

datum		wie		wat
------------------------------------------------------------------- 
2022-10-04	EgBr	Een OUTER APPLY op ZPMGGZ..HealthcareTrajectoryOrganizationUsers vanwege dup key problemen die door overlappende periodes worden veroorzaakt.
2022-09-23  Howard  rbh verwijderd_datum is null
2022-09-08  Howard  toeslagen op aparte regels.
2022-09-01  Howard  omzet_vz ook voor toeslagen. Kies toch het max-tarief ipv vz-afhankelijk tarief als het vz_tarief niet aanwezig is
2022-08-31  Howard  omzet_vz toegevoegd
2022-08-09	EgBr	Ivm de performance de upper(HealthcareProviderCode) uit de join met zorgverlener gehaald.
					Zit nu al in de query op de tabel 'ZPMGGZ..OrganizationUsers'.
2022-08-09	EgBr	Duplicates uit HealthcareTrajectoryDiagnoses gehaald met NOT EXISTS.
2022-08-03  Howard  ADD huidig_regiebehandelaar + huidig_diagnose_id 
2022-07-18  Howard  left join met diagnoses nu met juiste afvragingen
2022-07-12  Howard  Verzekeraar Tarief toegevoegd, epic verzekeraaar_id nu ook wanneer consult datetime leeg is
2022-06-30  Howard  Toeslag wordt nu toegevoegd vanuit andere tabel.
2022-06-27  Howard  Toeslag eruit, wordt nu geregistreerd als normale activiteit.
2022-06-09  Howard  ISNULL+getdate() toegevoegd aan regiebehandelaar wanneer er alleen een traject is en geen prestatie
2022-06-01  Howard  Start en einddatum toegevoegd aan regiebehandelaar
2022-17-05  Howard  Groepsconsulten met 0 minuten indicator ipv weghalen
2022-05-05  Howard  Task 413: groepsconsulten-tijd nu via ZORGGGZ tabellen
2022-04-20  Howard  Task 1533: cast(c.ConsultDateTime as date) regiebehandelaar ten onrechte onbekend: Enddate staat niet goed in de bron.
2022-04-20  Howard  Task 1530: ADD: HuidigeDiagnoseJn en HuidigeRegiebehandelaarJn  en een veld HuidigeFaseInTraject 
2022-04-20  Howard  Task 413: Update Groepsconsult-tijd voor aantal groepsconsulten in bron:(meerdere ZPM consulten voor één epic afspraak, 1op1 relatie).  
2022-04-12  Howard  Traject wordt onderdeel van zorgprestatie: Trajecten zonder verrichtingingen krijgen -1
2022-03-28  Howard  ADD: bedrag_toeslag, ggz_zorgprestatie_toeslag_id en bedrag_totaal 
2022-03-25  Howard  regiebehandelaar + diagnose met start en einddatum
2022-03-07  Howard  poli/klinisch toegevoegd
2022-02-07  Howard  Epic afspraak_nr toegevoegd
2022-02-07  Howard  Epic opname_nr toegevoegd
2022-01-17  Howard  Polis toegevoegd
                    zorgprestatie codelist/dimensie in ggz_zorgprestatie_dim
                    overlap in polis (geen einddatum en niet uniek)
2022-01-10  Howard  Creatie
-------------------------------------------------------------------
##*/



begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_zorgprestatie'

    
    drop table if exists tempdb..INT_ZORG_ggz_zorgprestatie 
	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_zorgprestatie',
            @pk1 = 'ggz_traject_ok',
            @pk2 = 'ggz_zorgprestatie_ok',
            @pk3 = 'ggz_toeslag_id',
            @ts = 'ggz_zorgprestatie_id'

-- is (5, -1, 0).
    PRINT convert(varchar(20), getdate(), 120) + ' inserting zorgprestaties'

	INSERT INTO tempdb..INT_ZORG_ggz_zorgprestatie (
            [ggz_toeslag_id]
            ,[ggz_traject_ok]
            ,[ggz_zorgprestatie_ok]
            ,[patient_nr]
            ,[ggz_zorgprestatie_dim_id]
            ,[uitvoerder_zorgverlener_id]
            ,[uitvoer_datumtijd]
            ,[duur_minuten]
            ,[duur_dagen]
            ,[aantal]
            ,[omzet]
            ,omzet_vz
            ,vz_tarief_ind
            ,verzekeraar_tarief
            --,ggz_zorgprestatie_dim_id_toeslag
            --,bedrag_toeslag
            --,vz_tarief_toeslag_ind
            --,bedrag_totaal
            ,normtijd_indirect
            ,doorberekende_directe_tijd
            ,directe_tijd_groepsconsulten
            ,[ggz_opname_id]
            ,opname_nr
            ,afspraak_nr
            ,duur_minuten_afspraak
            ,ggz_verzekeraar_id 
            ,verzekeraar_id
            ,klinisch_jn
            ,ggz_regiebehandelaar_id_zorgprestatie 
            ,werknemer_id
            ,ggz_diagnose_zpm_id_zorgprestatie 
            ,ggz_dbc_id_oud
            ,traject_ggz_zorglabel_id --is ok
            ,traject_startdatum
            ,traject_einddatum
            ,traject_registratiedatum
            ,traject_privacy
            ,traject_financieel_type
            ,traject_agb_verwijzer
            ,traject_agb_verwijzer_id
            ,traject_ggz_verwijstype_id
            ,traject_tariefniveau
            
 
        )
    SELECT  
         0                                              as ggz_toeslag_id --0 voor normale consulten
        ,ht.Id                                          as ggz_traject_ok --ok
        ,ISNULL(c.Id,-1)                                as ggz_zorgprestatie_ok
        ,cl.ClientNumber                                as patient_nr
        ,zpd.ggz_zorgprestatie_dim_id                   as zorgprestatie_dim_id --verrichting
         ,zv.zorgverlener_id                            as uitvoerder_zorgverlener_id
        ,cast(c.ConsultDateTime as smalldatetime)       as uitvoer_datumtijd
        ,c.[DurationInMinutes]                          as zorgprestatie_duur_minuten
        ,c.[DurationInDays]                             as zorgprestatie_duur_dagen --alleen van verblijfsdagen?

        ,CASE WHEN zpd.zorgprestatiegroep_code = 'CO' THEN 1
            ELSE c.DurationInUnits
            END as aantal
        ,CASE WHEN zpd.zorgprestatiegroep_code = 'CO' THEN 1 * zpd.tarief + c.DurationInDays * zpd.tarief
            ELSE c.DurationInUnits * zpd.tarief + c.DurationInDays*zpd.tarief
            END as omzet --maxtarief
        
        ,CASE WHEN zpd.zorgprestatiegroep_code = 'CO' THEN 1 * ISNULL(tar.Rate,zpd.tarief) + c.DurationInDays * ISNULL(tar.Rate,zpd.tarief)
            ELSE c.DurationInUnits * ISNULL(tar.Rate,zpd.tarief) + c.DurationInDays * ISNULL(tar.Rate,zpd.tarief)
            END as omzet_vz --verzekeraarsafhankelijk tarief
            --tijdseenheid bij GC zit er nog niet in. checken of het bij andere typen consulten wel allemaal in zit.
        ,CASE WHEN tar.Rate IS NULL THEN 'N'
              ELSE 'J' 
              END as vz_tarief_ind
        ,tar.Rate                        as verzekeraar_tarief

        --,NULL --tsd.ggz_zorgprestatie_dim_id                    as ggz_zorgprestatie_dim_id_toeslag
        --,NULL --ISNULL(tsr.Rate,ts.Price) * ts.Quantity         as bedrag_toeslag
        --,NULL --CASE WHEN tsr.Id IS NOT NULL THEN 'J'               WHEN ts.Id IS NULL THEN 'Geen Toeslag'              ELSE 'N'               END as vz_tarief_toeslag_ind
        --,NULL                                                   as bedrag_totaal --via update
        ,ISNULL(cast(ROUND((c.DurationInMinutes/(nt.[Percentage direct]*100))*(nt.[Percentage indirect]*100),3) as numeric(6,3)),0.00) as normtijd_indirect
        ,CASE   WHEN zpd.zorgprestatiegroep_code = 'CO' 
                THEN 1 * cast(zpd.duur_verrichting_minuten_vanaf as numeric(6,3))
                
                WHEN zpd.zorgprestatiegroep_code = 'GC' 
                THEN cast(zpd.duur_verrichting_minuten_vanaf  as numeric(7,3)) / cast(zpd.groeps_grootte as numeric(7,3))

            ELSE 0
            END as doorberekende_directe_tijd
        
        
        ,CASE  WHEN zpd.zorgprestatiegroep_code = 'GC'
               THEN  ISNULL(cast(gcr.DurationInMinutes  as numeric(7,3)) / cast(zpd.groeps_grootte as numeric(7,3)),0)
               ELSE 0
            END as directe_tijd_groepsconsulten
             
        ,o.ggz_opname_id                 as ggz_opname_id
        ,o.opname_nr                     as opname_nr
        ,af.afspraak_nr_epic             as afspraak_nr
        ,af.duur_minuten_realisatie      as duur_minuten_afspraak
        ,isnull(vzg.ggz_verzekeraar_id,-1)  as ggz_verzekeraar_id
        ,po.verzekeraar_id               as verzekeraar_id --uit polis, epic
        ,'N'                             as klinisch_jn             --via update
        ,rbh.ggz_regiebehandelaar_id     as ggz_regiebehandelaar_id_zorgprestatie
        ,w.werknemer_id                  as werknemer_id
        ,diag.ggz_diagnose_zpm_id        as ggz_diagnose_zpm_id_zorgprestatie
        ,ht.[ExternalTrajectoryId]       as ggz_dbc_id_oud
        ,zli.ggz_zorglabel_id            as ggz_zorglabel_id_traject --is ok
        ,ht.[StartDate]                  as traject_startdatum
        ,ht.[EndDate]                    as traject_einddatum
        ,ht.[RegistrationDate]           as traject_registratiedatum
        ,ht.[Privacy]                    as traject_privacy
        ,ht.[FinanceType]                as traject_financieel_type
        ,CASE WHEN ht.ReferrerAgbCode IS NOT NULL
                THEN right(concat('0000000', ht.[ReferrerAgbCode]),8)
                                     END as traject_agb_verwijzer
        ,agb.agb_verwijzer_id            as traject_agb_verwijzer_id
        ,vt.ggz_verwijstype_id           as traject_ggz_verwijstype_id
        ,ht.[TariffLevel]                as traject_tariefniveau
    --select * 
   from ZPMGGZ.dbo.HealthcareTrajectories ht 
   
    left join ZPMGGZ.dbo.HealthcareConsults c
        on ht.Id = c.HealthcareTrajectoryId
        and c.Removed = 0
    
    left join [ZPMGGZ].[dbo].[ClientgroupRegistrations] gcr
        on c.ClientgroupRegistrationId=gcr.Id
        and gcr.Removed = 0
--select * from ZPMGGZ..HealthInsurances v where HealthInsurerId IN(12,24) order by 3 --208, 1459
    left join ZPMGGZ..HealthInsurances v 
        on v.ClientId = ht.ClientId
        and c.ConsultDateTime between v.StartDate and ISNULL(v.EndDate,'9999-12-31')
        and v.Removed= 0

    left join ZPMGGZ..HealthInsurerHealthInsurerCluster cv 
        on cv.HealthInsurersId = v.HealthInsurerId

    left join  INT_ZORG..ggz_verzekeraar vzg
        on vzg.ggz_verzekeraar_ok = v.HealthInsurerId
 

    left join ZPMGGZ..ContractRates tar 
        on tar.CodelistActivityId = c.CodelistActivityId
        and tar.HealthInsurerClusterId = cv.HealthInsurerClustersId
        and tar.Removed = 0
        and year(c.ConsultDateTime) = tar.[Year]

    left join ZPMGGZ..Clients cl 
        on ht.ClientId = cl.Id

    left join INT_ZORG..ggz_verwijstype vt 
        on vt.ggz_verwijstype_ok = ht.CodelistReferrerTypeId
        and vt.bron = 'ZPM'
 
    left join ZPMGGZ..CodelistCareLabelHealthcareTrajectories zl
        on zl.HealthcareTrajectoriesId=ht.Id
    left join ggz_zorglabel zli 
        on zli.ggz_zorglabel_ok = zl.CodelistCareLabelsId

    left join agb_verwijzer agb 
        on left(right(concat('0000000', ht.[ReferrerAgbCode]),8),2) = agb.agb_code_zorgpartij
  
    left join ggz_zorgprestatie_dim zpd
        on c.CodelistActivityId = zpd.ggz_zorgprestatie_dim_ok
        
    --left join ZPMGGZ.dbo.CodelistSurchargeConsults tc         on zpd.zorgprestatie_code = tc.ActivityCode        and tc.Removed = 0
    --left join ZPMGGZ..ContractRates tsr --vz tarieven voor toeslagen        on tsr.CodelistActivityId = ts.CodelistActivityId        and tsr.HealthInsurerClusterId = cv.HealthInsurerClustersId        and tsr.Removed = 0        and year(c.ConsultDateTime) = tsr.[Year]
    --left join ZPMGGZ..HealthcareConsultSurcharges ts         on ts.HealthcareConsultId = c.Id        and ts.Removed = 0
    --left join ggz_zorgprestatie_dim tsd         on ts.CodelistActivityId = tsd.ggz_zorgprestatie_dim_ok


    left join patient p 
        on p.patient_nr = cl.ClientNumber

    outer apply (
        select top 1
            verzekeraar_id
            ,startdatum
            ,isnull(einddatum,'9999-12-31') as einddatum
        from polis po
        where 1=1
            and p.patient_id = po.patient_id
            and ISNULL(c.ConsultDateTime,GETDATE()) between po.startdatum and ISNULL(po.einddatum,'9999-12-31')
            and po.verwijderd_datum is null
            
        order by --startdatum desc
            datediff(day,po.startdatum,ISNULL(c.ConsultDateTime,getdate())) asc, polis_id desc
        ) po
          
        
    left join (select Id,upper(HealthcareProviderCode) as HealthcareProviderCode from ZPMGGZ..OrganizationUsers where Removed = 0) org 
        on c.OrganizationUserId = org.Id
    left join INT_ZORG..werknemer w 
        on w.werknemer_id = org.HealthcareProviderCode  
    left join INT_ZORG..zorgverlener zv 
        on  zv.werknemer_nummer = org.HealthcareProviderCode 
    left join ggz_opname o 
        on o.ggz_opname_ok = c.AdmissionId
    left join EXTERN..ggz_normtijden nt 
        on nt.Prestatie_code = zpd.zorgprestatie_code
        and zpd.zorgprestatie_code IS NOT NULL
    
    outer apply (
        select top 1
            patient_id
            , afspraak_nr_epic
            , min(start_afspraak_datumtijd) as start_afspraak_datumtijd
            , max(eind_afspraak_datumtijd) as eind_afspraak_datumtijd
            , sum(af.duur_minuten_realisatie) as duur_minuten_realisatie
        from ggz_afspraak af 
        where 1=1
            and af.patient_id = p.patient_nr
            --and c.ConsultDateTime between af.start_afspraak_datumtijd and dateadd(SECOND, -1, eind_afspraak_datumtijd)
            and c.ConsultDateTime = af.start_afspraak_datumtijd
            and af.patient_id <> -1 
        group by 
              patient_id
            , afspraak_nr_epic
        order by afspraak_nr_epic desc 
    ) af 
-- getdate niet goed. regiebehandelaren kunnen gestopt zijn voor gerdate() maar wel actief zijn geweest aan een traject in een eerdere periode dan getdate(). 
-- dergelijke trajecten via een cross apply met iets van laatst actieve behandelaar
    --left join ZPMGGZ..HealthcareTrajectoryOrganizationUsers rb --regiebehandelaar
    --        on rb.HealthcareTrajectoryId = ISNULL(c.HealthcareTrajectoryId, ht.Id)
    --        and ISNULL(c.ConsultDateTime  , getdate()  ) between rb.StartDate  and ISNULL(rb.EndDate,'9999-12-31')  --overbodig, behandelaar valt altijd binnen start einddatum van traject
    --        and rb.Removed = 0
    outer apply --EgBr maar even met een OUTER APPLY vanwege overlappende periodes
	(select top 1 * from
	ZPMGGZ..HealthcareTrajectoryOrganizationUsers rb --regiebehandelaar
            where rb.HealthcareTrajectoryId = ISNULL(c.HealthcareTrajectoryId, ht.Id)
            and ISNULL(c.ConsultDateTime  , getdate()  ) between rb.StartDate  and ISNULL(rb.EndDate,'9999-12-31')  --overbodig, behandelaar valt altijd binnen start einddatum van traject
            and rb.Removed = 0
			order by Created desc 
    )rb        
            
    left join ggz_regiebehandelaar rbh 
        on rbh.ggz_regiebehandelaar_ok = rb.OrganizationUserId
        and ISNULL(c.ConsultDateTime, getdate()) between rbh.startdatum and rbh.einddatum
        and rbh.verwijderd_datum IS NULL

    left join ZPMGGZ..HealthcareTrajectoryDiagnoses dia
        on dia.HealthcareTrajectoryId = c.HealthcareTrajectoryId
        and dia.Removed = 0 
        and (ConsultDateTime >= dia.StartDate   and c.ConsultDateTime < ISNULL(dia.EndDate,'9999-12-31'))
		and not exists(
		    select top 1 1 from ZPMGGZ..HealthcareTrajectoryDiagnoses dia2 
		    where 1=1
		        and dia2.HealthcareTrajectoryId = c.HealthcareTrajectoryId
		        and dia2.Removed = 0
		        and (ConsultDateTime >= dia2.StartDate   and c.ConsultDateTime < ISNULL(dia2.EndDate,'9999-12-31'))
		        and dia2.StartDate > dia.StartDate
            order by dia2.DiagnosisId asc
		)

    left join ggz_diagnose_zpm diag 
        on dia.DiagnosisId = diag.ggz_diagnose_zpm_ok
        
    where 1=1
        and ht.Removed = 0
       
        

    PRINT convert(varchar(20), getdate(), 120) + ' '+ cast(@@ROWCOUNT as varchar) + ' zorgprestaties inserted'
---toeslagen zorgprestatie als losse prestaties
	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie: error inserting new records in temp tab',16,1)
		RETURN -1
	END


    PRINT convert(varchar(20), getdate(), 120) + ' inserting toeslagen'

	INSERT INTO tempdb..INT_ZORG_ggz_zorgprestatie (
            [ggz_toeslag_id]
            ,[ggz_traject_ok]
            ,[ggz_zorgprestatie_ok]
            ,[patient_nr]
            ,[ggz_zorgprestatie_dim_id]
            ,[uitvoerder_zorgverlener_id]
            ,[uitvoer_datumtijd]
            ,[duur_minuten]
            ,[duur_dagen]
            ,[aantal]
            ,[omzet]
            ,omzet_vz
            ,vz_tarief_ind
            ,verzekeraar_tarief
            --,ggz_zorgprestatie_dim_id_toeslag
            --,bedrag_toeslag
            --,vz_tarief_toeslag_ind
            --,bedrag_totaal
            ,normtijd_indirect
            ,doorberekende_directe_tijd
            ,directe_tijd_groepsconsulten
            ,[ggz_opname_id]
            ,opname_nr
            ,afspraak_nr
            ,duur_minuten_afspraak
            ,verzekeraar_id
            ,klinisch_jn
            ,ggz_regiebehandelaar_id_zorgprestatie 
            ,werknemer_id
            ,ggz_diagnose_zpm_id_zorgprestatie 
            ,ggz_dbc_id_oud
            ,traject_ggz_zorglabel_id --is ok
            ,traject_startdatum
            ,traject_einddatum
            ,traject_registratiedatum
            ,traject_privacy
            ,traject_financieel_type
            ,traject_agb_verwijzer
            ,traject_agb_verwijzer_id
            ,traject_ggz_verwijstype_id
            ,traject_tariefniveau

        )    
    select
        ROW_NUMBER() OVER( PARTITION BY z.ggz_zorgprestatie_ok order by z.ggz_zorgprestatie_ok asc) 
                                                    as  ggz_toeslag_id
        ,z.ggz_traject_ok                           AS [ggz_traject_ok]
        ,ts.HealthcareConsultId                     as  ggz_zorgprestatie_ok
        ,z.patient_nr                               AS [patient_nr]
        ,tsd.ggz_zorgprestatie_dim_id               AS [ggz_zorgprestatie_dim_id] 
        ,z.uitvoerder_zorgverlener_id               AS [uitvoerder_zorgverlener_id]
        ,z.uitvoer_datumtijd                        AS [uitvoer_datumtijd]
        ,0                                          AS [duur_minuten]
        ,0                                          AS [duur_dagen]
        ,ts.Quantity                                AS [aantal]
        ,ts.Quantity * tsd.tarief                   AS [omzet] --maxtarief? verzekeraarstarief handhaven?!
        ,ISNULL(tar.Rate,ts.Price) * ts.Quantity --tarief prestatie of toeslag?
                                                    as omzet_vz --verzekeraarsafhankelijk tarief
        ,CASE WHEN tar.Rate IS NOT NULL THEN 'J'
            ELSE 'N'
            END                                     AS vz_tarief_ind
        ,tar.Rate                                   AS verzekeraar_tarief 
        --,NULL                           AS ggz_zorgprestatie_dim_id_toeslag -- kolom weg
        --,ts.Price                       AS bedrag_toeslag --kolom weg
        --,''                             AS vz_tarief_toeslag_ind --kolom weg
        --,0                                           AS bedrag_totaal --kolom weg?
        ,0                                           AS normtijd_indirect
        ,0                                           AS doorberekende_directe_tijd
        ,0                                           AS directe_tijd_groepsconsulten
        ,z.ggz_opname_id                             AS [ggz_opname_id]
        ,z.opname_nr                                 AS opname_nr
        ,null                                        AS afspraak_nr
        ,0                                           AS duur_minuten_afspraak
        ,z.verzekeraar_id                            AS verzekeraar_id
        ,'O'                                         AS klinisch_jn --onbekend of van zorgprestatie overnemen?
        ,z.ggz_regiebehandelaar_id_zorgprestatie    AS ggz_regiebehandelaar_id_zorgprestatie 
        ,z.werknemer_id                             AS werknemer_id
        ,z.ggz_diagnose_zpm_id_zorgprestatie        AS ggz_diagnose_zpm_id_zorgprestatie 
        ,z.ggz_dbc_id_oud                           AS ggz_dbc_id_oud
        ,z.traject_ggz_verwijstype_id               AS traject_ggz_zorglabel_id --is ok
        ,z.traject_startdatum                       AS traject_startdatum
        ,z.traject_einddatum                        AS traject_einddatum
        ,z.traject_registratiedatum                 AS traject_registratiedatum
        ,z.traject_privacy                          AS traject_privacy
        ,z.traject_financieel_type                  AS traject_financieel_type
        ,z.traject_agb_verwijzer                    AS traject_agb_verwijzer
        ,z.traject_agb_verwijzer_id                 AS traject_agb_verwijzer_id
        ,z.traject_ggz_verwijstype_id               AS traject_ggz_verwijstype_id
        ,z.traject_tariefniveau                     AS traject_tariefniveau
        
    from tempdb.dbo.INT_ZORG_ggz_zorgprestatie z
    --from INT_ZORG..ggz_zorgprestatie z
    
    inner join  ZPMGGZ..HealthcareConsultSurcharges ts 
        on ts.HealthcareConsultId = z.ggz_zorgprestatie_ok
        and ts.Removed = 0

    left join ggz_zorgprestatie_dim tsd
        on ts.CodelistActivityId = tsd.ggz_zorgprestatie_dim_ok

    left join ZPMGGZ..HealthcareTrajectories ht 
        on z.ggz_traject_ok = ht.Id
        and ht.Removed = 0

    left join ZPMGGZ..HealthInsurances v 
        on v.ClientId = ht.ClientId
        and z.uitvoer_datumtijd between v.StartDate and ISNULL(v.EndDate,'9999-12-31')

    left join ZPMGGZ..HealthInsurerHealthInsurerCluster cv 
        on cv.HealthInsurersId = v.HealthInsurerId

    left join ZPMGGZ..ContractRates tar 
        on tar.CodelistActivityId = ts.CodelistActivityId
        and tar.HealthInsurerClusterId = cv.HealthInsurerClustersId
        and tar.Removed = 0
        and year(z.uitvoer_datumtijd) = tar.[Year] 
  
    where 1=1
        and ht.Removed = 0
        --AND z.ggz_zorgprestatie_ok = 64244    order by 1--and ts.Removed = 0    

    PRINT convert(varchar(20), getdate(), 120) + ' ' + cast(@@ROWCOUNT as varchar) + ' toeslagen inserted'

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie: error inserting toeslagen in temp tab',16,1)
		RETURN -1
	END
 

PRINT convert(varchar(20), getdate(), 120) + ' start updates'
--ALTER TABLE INT_ZORG..ggz_zorgprestatie ADD gc_geen_tijd_ind bit
--drop table tempdb..INT_ZORG_ggz_zorgprestatie a 
 update a
    set a.gc_geen_tijd_ind = CASE WHEN  b.zorgprestatiegroep_code = 'GC' and a.duur_minuten_afspraak = 0 THEN 1
        ELSE 0
        END
 from   tempdb..INT_ZORG_ggz_zorgprestatie a 
 left join INT_ZORG..ggz_zorgprestatie_dim b 
    on a.ggz_zorgprestatie_dim_id = b.ggz_zorgprestatie_dim_id
 where 1=1
    and b.zorgprestatiegroep_code = 'GC' and a.duur_minuten_afspraak = 0


 update a 
    set a.bedrag_totaal = ISNULL(a.omzet,0.00) -- + ISNULL(a.bedrag_toeslag,0.00) weggehaald 27-06-2022
 from  tempdb..INT_ZORG_ggz_zorgprestatie a

/* 
    Verblijfsdagen: Klinisch J/N
    Als er een verblijfsdag op een dag is geregistreerd zijn de overige verrichtingen van dat traject/patient Klinisch = 'J'

*/
update a 
    set a.klinisch_jn = 'J'
--select * 

from tempdb..INT_ZORG_ggz_zorgprestatie a
join ggz_zorgprestatie_dim b 
    on a.ggz_zorgprestatie_dim_id = b.ggz_zorgprestatie_dim_id
    and b.zorgprestatiegroep_code <> 'VD'
    and b.verwijderd_datum is null
join  tempdb..INT_ZORG_ggz_zorgprestatie c 
    on cast(a.uitvoer_datumtijd as date) = cast(c.uitvoer_datumtijd as date)
    and c.ggz_traject_ok = a.ggz_traject_ok
    
join ggz_zorgprestatie_dim d 
    on c.ggz_zorgprestatie_dim_id = d.ggz_zorgprestatie_dim_id
    and d.zorgprestatiegroep_code = 'VD'
    and d.verwijderd_datum is null
where 1=1


/* ### verblijfsdagen zelf zijn ook klinisch  */
update a 
    set a.klinisch_jn = 'J'
--select * 
from tempdb..INT_ZORG_ggz_zorgprestatie a
join ggz_zorgprestatie_dim b 
    on a.ggz_zorgprestatie_dim_id = b.ggz_zorgprestatie_dim_id
    and b.zorgprestatiegroep_code = 'VD'
    and b.verwijderd_datum is null
where 1=1

     

-- update voor opeenvolgende sessies die geregistreerd staan als één groepsconsult, nu niet meer via Epic
    update a 
    set a.directe_tijd_groepsconsulten = a.directe_tijd_groepsconsulten /  b.aantal_consulten_geboekt_ZPM_voor_een_enkel_epic_afspraak
       --,a.doorberekende_directe_tijd =  a.doorberekende_directe_tijd --/ b.aantal_consulten_geboekt_ZPM_voor_een_enkel_epic_afspraak
    FROM tempdb..INT_ZORG_ggz_zorgprestatie a
        
        join INT_ZORG..ggz_zorgprestatie_dim c 
            on a.ggz_zorgprestatie_dim_id = c.ggz_zorgprestatie_dim_id 
            and c.zorgprestatiegroep_code= 'GC'

        join (
                SELECT  
                    uitvoer_datumtijd
                    ,uitvoerder_zorgverlener_id
                   
                    ,patient_nr
                    ,count(*) as aantal_consulten_geboekt_ZPM_voor_een_enkel_epic_afspraak --count(distinct ggz_zorgprestatie_ok ) as aantal_consulten_geboekt_ZPM_voor_een_enkel_epic_afspraak
                    
                FROM tempdb..INT_ZORG_ggz_zorgprestatie a 
                left join INT_ZORG..ggz_zorgprestatie_dim b 
                    on a.ggz_zorgprestatie_dim_id = b.ggz_zorgprestatie_dim_id
                where 1=1
                    and b.zorgprestatiegroep_code= 'GC'
                    
                group by 
                    uitvoer_datumtijd
                    ,uitvoerder_zorgverlener_id
                 
                    ,patient_nr
                ) b 
            on  a.patient_nr = b.patient_nr
            and a.uitvoer_datumtijd = b.uitvoer_datumtijd
            and a.uitvoerder_zorgverlener_id = b.uitvoerder_zorgverlener_id

    where 1=1
                


--alter table INT_ZORG..ggz_zorgprestatie ADD diagnose_huidig_id int
--update Task 1530: ADD: HuidigeDiagnoseJn

    update a 
    set a.HuidigeDiagnoseJn=
        CASE WHEN diag.ggz_diagnose_zpm_ok = b.DiagnosisId THEN 'J'
            else 'N'
            end --as HuidigeDiagnoseJn
        , diagnose_huidige_id= diag1.ggz_diagnose_zpm_id  
    from  tempdb..INT_ZORG_ggz_zorgprestatie a
    join (

        select distinct
            HealthcareTrajectoryId
            ,b.DiagnosisId
            --,*
        from ZPMGGZ..HealthcareTrajectoryDiagnoses dia
        cross apply
            (select top(1)
                DiagnosisId
            from ZPMGGZ..HealthcareTrajectoryDiagnoses b
            where 1=1
                and HealthcareTrajectoryId = dia.HealthcareTrajectoryId
                and StartDate < getdate()
                and Removed = 0
            order by 
                --StartDate desc --laatste 
                datediff(hour,StartDate,getdate()) asc --meest recente

            ) b
        where 1=1
            and Removed = 0
    ) b 
    on b.HealthcareTrajectoryId = a.ggz_traject_ok
    
    left join ggz_diagnose_zpm diag 
        on a.ggz_diagnose_zpm_id_zorgprestatie = diag.ggz_diagnose_zpm_id
    
    left join ggz_diagnose_zpm diag1 
        on b.DiagnosisId = diag1.ggz_diagnose_zpm_ok

--update Task 1530: Add HuidigeFaseInTraject

    --wanneer 0 distinct consult_type: nog niet gestart
    --wanneer diag_ind groter dan 0 en consult_type = 1 dan diag
    --wanneer beh_ind groter dan 0: dan behandeling
 
 
    update a 
    set a.HuidigeFaseInTraject= b. HuidigeFaseInTraject  
      --from INT_ZORG..ggz_zorgprestatie aangemaakt
    
    from tempdb..INT_ZORG_ggz_zorgprestatie a 
    left join (
            select 
                ggz_traject_ok,
                case   when count(distinct c.consult_type) = 0 THEN 'NogNietGestart' 
                        when count(distinct c.consult_type) = 1 AND sum(CASE WHEN c.consult_type = 'Diagnostiek' then 1 else 0 end) > 0 THEN 'Diagnostiek'
                        when sum(CASE WHEN c.consult_type = 'Behandeling' then 1 else 0 end) > 0 THEN 'Behandeling'
                END as HuidigeFaseInTraject
            from tempdb..INT_ZORG_ggz_zorgprestatie b
            left join  INT_ZORG..ggz_zorgprestatie_dim c 
                on b.ggz_zorgprestatie_dim_id = c.ggz_zorgprestatie_dim_id
                
            group by b.ggz_traject_ok
            ) b 
        on a.ggz_traject_ok = b.ggz_traject_ok
    --select * from INT_ZORG..ggz_zorgprestatie_dim c 
   

--update Task 1530: ADD: HuidigeRegiebehandelaarJn

    update a 
    set a.HuidigeRegiebehandelaarJn=
        CASE WHEN rbh.ggz_regiebehandelaar_ok = b.OrganizationUserId THEN 'J'
            else 'N'
            end --as HuidigeDiagnoseJn
        ,regiebehandelaar_huidige_id = rbh1.ggz_regiebehandelaar_id
        
    from  tempdb..INT_ZORG_ggz_zorgprestatie a
    join (
            select distinct
                HealthcareTrajectoryId
                ,b.OrganizationUserId
            from ZPMGGZ..HealthcareTrajectoryOrganizationUsers rb
                
            cross apply
                (select top(1)
                    OrganizationUserId
                from ZPMGGZ..HealthcareTrajectoryOrganizationUsers b
                where 1=1
                    and HealthcareTrajectoryId = rb.HealthcareTrajectoryId
                    and StartDate < getdate()
                    and Removed = 0
                order by 
                    --StartDate desc --laatste 
                    datediff(hour,StartDate,getdate()) asc --meest recente

                ) b
            where 1=1
                and Removed = 0
        ) b 
        on b.HealthcareTrajectoryId = a.ggz_traject_ok
    left join ggz_regiebehandelaar rbh 
          on rbh.ggz_regiebehandelaar_id = a.ggz_regiebehandelaar_id_zorgprestatie

    left join ggz_regiebehandelaar rbh1 
          on rbh1.ggz_regiebehandelaar_ok = b.OrganizationUserId and rbh1.verwijderd_datum is null

   --regiebehandelaren bij zorgprestaties met alleen een traject (geen consulten)
   --- traject kan in januari begonnen zijn, regiebehandelaar pas vanaf juni in ZPMGGZ.
   --- regiebehandelaar kan meerdere keren voorkomen of wijzigen gedurende traject
    

 
     update a 
     set a.ggz_regiebehandelaar_id_zorgprestatie = rbh.ggz_regiebehandelaar_id
    --from INT_ZORG..ggz_zorgprestatie a 
    from  tempdb..INT_ZORG_ggz_zorgprestatie a
    cross apply (
            select top 1 OrganizationUserId--datediff(day,ISNULL(EndDate,'9999-12-31'),getdate()),* 
            from ZPMGGZ..HealthcareTrajectoryOrganizationUsers b
            where 1=1
                and Removed= 0
                and HealthcareTrajectoryId = a.ggz_traject_ok
            order by datediff(day,ISNULL(EndDate,'9999-12-31'),getdate()) --asc
                ) rb 
    cross apply  (
            select top 1 ggz_regiebehandelaar_id 
            FROM ggz_regiebehandelaar
            where 1=1   
                and ggz_regiebehandelaar_ok= rb.OrganizationUserId
            order by datediff(day,ISNULL(einddatum,'9999-12-31'),getdate()) --asc
    ) rbh
    where 1=1
        and a.ggz_regiebehandelaar_id_zorgprestatie IS NULL
        --and verwijderd_datum IS NULL
 

       	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_zorgprestatie',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_zorgprestatie',
			@full = 1,
			@do_update_statistics = 1
 

    drop table tempdb..INT_ZORG_ggz_zorgprestatie

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie: Error merge tables',16,1)
		RETURN -1
	END
 
  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_zorgprestatie'

end