 
CREATE     proc [dbo].[vul_ggz_zorgprestatie] AS

 --select cast('2022-01-12' as smalldatetime)


/*## 
datum		wie		wat
------------------------------------------------------------------- 
2022-02-07  Howard  Epic afspraak_nr toegevoegd
2022-02-07  Howard  Epic opname_nr toegevoegd
2022-01-17  Howard  Polis toegevoegd

            zorgprestatie codelist/dimensie in ggz_zorgprestatie_dim

            opbouwen vanuit trajecten
            volgorderlijkheid: na dims draaien

            overlap in polis (geen einddatum enniet uniek)
2022-01-10  Howard  Creatie
-------------------------------------------------------------------
##*/
 





begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_zorgprestatie'

 

	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_zorgprestatie',
			@pk1 = 'ggz_zorgprestatie_ok',
            @ts = 'ggz_zorgprestatie_id'

--drop table tempdb..INT_ZORG_ggz_zorgprestatie

/*
select Id, po.patient_id, count(*)
  from  ZPMGGZ.dbo.HealthcareConsults c 
    left join ggz_traject t 
        on t.ggz_traject_ok = c.HealthcareTrajectoryId
    left join patient p 
        on t.patient_nr = p.patient_nr
        and p.verwijderd_datum is null
    left join polis po
            on p.patient_id = po.patient_id
            and c.ConsultDateTime between po.startdatum and ISNULL(po.einddatum,'9999-12-31')
            and po.verwijderd_datum is null
group by Id, po.patient_id
having count(*)           > 1
  

select * from polis where patient_id = 'Z2423134'
*/

	-- Insert alle nieuwe records in temp
--    drop table tempdb..INT_ZORG_ggz_zorgprestatie
	INSERT INTO tempdb..INT_ZORG_ggz_zorgprestatie (
            [ggz_zorgprestatie_ok]
            ,[ggz_traject_id]
            ,[ggz_zorgprestatie_dim_id]
            --,[zorgprestatie_code]
            --,[zorgprestatie_type] --
            --,[zorgprestatie_setting_id]
            ,[uitvoerder_zorgverlener_id]
            ,[uitvoer_datumtijd]
            ,[duur_minuten]
            ,[duur_dagen]
            ,[aantal]
            ,[ggz_opname_id]
            ,opname_nr
            ,afspraak_nr
            ,duur_minuten_afspraak
            ,verzekeraar_id
            --,[financiele_afhandeling]
            --,[afspraak_ok]
            --,[afdeling_ok]
            --,[claim_type]
            --,[interpretatie_type]
        
        )
	  
 --drop table ggz_zorgpresatatie
 
    SELECT  
         c.Id                           as ggz_zorgprestatie_ok
        ,t.ggz_traject_id               as ggz_traject_id
        ,zpd.ggz_zorgprestatie_dim_id   as zorgprestatie_dim_id --verrichting
        --,c.[ActivityCode]               as zorgprestatie_code --verrichting
        --,c.[HealthcareConsultType]      as zorgprestatie_type --geen oms
        --,c.[CodelistSettingId]          as zorgprestatie_setting_id --ook in dim_
        ,zv.zorgverlener_id             as uitvoerder_zorgverlener_id
        ,cast(c.ConsultDateTime as smalldatetime)
                                        as uitvoer_datumtijd
        ,c.[DurationInMinutes]          as zorgprestatie_duur_minuten
        ,c.[DurationInDays]             as zorgprestatie_duur_dagen --alleen van verblijfsdagen?
        ,c.[DurationInUnits]            as aantal --units nergens opgegeven, nergens van toepassing?
 
        --,c.[ClientgroupRegistrationId]  
        --,c.[ClientReportId]   
        ,o.ggz_opname_id                 as ggz_opname_id
        ,o.opname_nr                     as opname_nr
        ,af.afspraak_nr_epic             as afspraak_nr
        ,af.duur_minuten_realisatie      as duur_minuten_afspraak
        ,po.verzekeraar_id               as verzekeraar_id --uit polis
  
       -- ,c.[BillingMethod]              as zorgprestatie_financiele_afhandeling
        --,c.[OrganizationalUnitId]       as zorgprestatie_afdeling_ok
        --,c.[ClaimType]                  as zorgprestatie_claim_type
        --,c.[InterpreterType]            as zorgprestatie_interpretatie_type
 --select count(*) drop table if exists #tempggz ax.* into #tempggz
 
  from  ZPMGGZ.dbo.HealthcareConsults c 
 
    left join ggz_zorgprestatie_dim zpd
        on c.ActivityCode = zpd.zorgprestatie_code
        
    left join ggz_traject t 
        on t.ggz_traject_ok = c.HealthcareTrajectoryId
   
    left join patient p 
        on t.patient_nr = p.patient_nr
        and p.verwijderd_datum is null
    outer apply (
        select top 1
            verzekeraar_id
            ,startdatum
            ,isnull(einddatum,'9999-12-31') as einddatum
        from polis po
        where 1=1
            and p.patient_id = po.patient_id
            and c.ConsultDateTime between po.startdatum and ISNULL(po.einddatum,'9999-12-31')
            and po.verwijderd_datum is null
            
        order by --startdatum desc
            datediff(day,po.startdatum,c.ConsultDateTime) asc, polis_id desc
        ) po
          
        
    left join ZPMGGZ..OrganizationUsers org 
        on c.OrganizationUserId = org.Id
    left join INT_ZORG..zorgverlener zv 
        on  zv.werknemer_nummer = upper(org.HealthcareProviderCode) COLLATE  Database_Default 
    left join ggz_opname o 
        on o.ggz_opname_ok = c.AdmissionId
     
        /*
    outer apply (
        select top 1
            af.afspraak_nr_epic, af.ggz_afspraak_id, duur_minuten_realisatie 
        from ggz_afspraak af 
        where af.patient_id = p.patient_nr
            and c.ConsultDateTime between af.start_afspraak_datumtijd and dateadd(SECOND, -1, eind_afspraak_datumtijd)
            and af.patient_id <> -1
        order by datediff(s,af.start_afspraak_datumtijd, af.eind_afspraak_datumtijd) desc
     ) af
    
    */
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
     
      
    where 1=1
        and c.Removed = 0
        


-- 
   
   /* overlappende afspraken in de bron met één epic afspraak_nr
    select * from #tempggz a 
      left join ggz_afspraak af 
        on af.afspraak_nr_epic = a.afspraak_nr
     where ggz_zorgprestatie_ok IN(
        select ggz_zorgprestatie_ok  from #tempggz
        group by ggz_zorgprestatie_ok
        having count(*)>1
    ) order by 1

    select * from ggz_afspraak where afspraak_nr_epic IN(
        78835962
 
        ,78421857
 
        ,78786865
    )

*/
 --select * from ggz_zorgprestatie 4694
--select top(100) * from patient
--select * from INT_ZORG..zorgverlener
--select * from ZPMGGZ..OrganizationUsers org 


/* 
--update di verzekeraar met overlap
   outer apply (
        select top 1
            verzekeraar_id
            ,startdatum
            ,isnull(einddatum,'9999-12-31') as einddatum
        from polis po
        where 1=1
            and p.patient_id = po.patient_id
            and c.ConsultDateTime between po.startdatum and ISNULL(po.einddatum,'9999-12-31')
            and po.verwijderd_datum is null
            
        order by --startdatum desc
            datediff(day,po.startdatum,c.ConsultDateTime) asc
        ) po
        


*/


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_zorgprestatie',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_zorgprestatie',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_zorgprestatie

--select * from ggz_zorgprestatie

  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_zorgprestatie'

end