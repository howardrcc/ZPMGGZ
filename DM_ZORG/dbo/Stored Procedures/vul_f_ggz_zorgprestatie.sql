   

CREATE    proc [dbo].[vul_f_ggz_zorgprestatie]
as
/*## 
Historie
Datum       wie		    wat
-------------------------------------------------------------------
2022-10-04  Howard      delete alleen wanneer brontabel gevuld is
2022-09-27  Howard      diverse factuur status/codes toegevoegd. (omschrijvingen zijn er nog niet)
2022-09-09  Howard      toeslag_id toegevoegd aan sleutel
2022-08-31  Howard      omzet_vz toegevoegd
2022-07-14  Howard      Traject_ok vervangen met Id uit dimensie, trajecten werden niet goed gekoppeld (melding Tim)
2022-07-12  Howard      US1767: ADD verzekeraar_tarief
2022-06-27  Howard      Task:1753: Nieuwe release GGZ, toeslagen als reguliere activiteit
2022-04-20  Howard      Task 1530: ADD: HuidigeDiagnoseJn en HuidigeRegiebehandelaarJn  en een veld HuidigeFaseInTraject 
2022-04-20  Howard      Task 413: Update Groepsconsult-tijd voor aantal groepsconsulten in bron:(meerdere ZPM consulten voor één epic afspraak, 1op1 relatie).  
2022-04-12  Howard      Trajectkenmerken bij de zorgprestatie(opbouwen vanuit traject)
2022-03-28  Howard      ADD: zorgprestatie_toeslag_id, bedrag_toeslag, bedrag_totaal
2022-03-25  Howard      diagnose en regiebehandelaar toegevoegd op basis van start en einddatum en datum zorgprestatie
2022-03-17  Howard      berekeningen moeten richting INT_laag.
                        Aan deze feit zal een peilmaand worden toegevoegd.
                        Het is van belang dat het OHW en gefactureerde bedrag, statussen worden bevroren voor o.a. accountant en audit-doeleinden. 
                        mbv peilmaand of start en eind-maand dat de data niet-veranderd?
2022-03-07  Howard      klinisch toegevoegd
2022-02-07  Howard      Opname_nr en afspraak_nr epic toegevoegd
2022_02-07  Howard      Doorberekende directe tijd toegevoegd
2022-01-31  Howard      Normtijden toegevoegd vanuit EIFFEL/EXTERN
2022-01-19  Howard      Aanvullingen Anne-Marie
2022-01-12	Howard		Creatie


--doorberekende directe tijd?
  --voor de consulten: DM_ZORG.dbo.f_ggz_zorgprestatie.[aantal]*DM_DIM.dbo.d_ggz_zorgprestatie.[duur_verrichting_minuten_vanaf] (voor de desbetreffende zorgprestatiecode)
--voor de groepsconsulten: (DM_ZORG.dbo.f_ggz_zorgprestatie.[aantal]*DM_DIM.dbo.d_ggz_zorgprestatie.[duur_verrichting_minuten_vanaf])/ DM_DIM.dbo.d_ggz_zorgprestatie.[groeps_grootte](voor de desbetreffende zorgprestatiecode)

select top(100) * from DM_ZORG..f_ggz_zorgprestatie
------------------------------------------------------------------- 
##*/
begin
-- alter table f_ggz_zorgprestatie add verzekeraar_tarief numeric(12,2) 
--alter table f_ggz_zorgprestatie add vz_tarief_ind varchar(1) NULL
--alter table f_ggz_zorgprestatie add ggz_toeslag_id int NOT NULL DEFAULT 0
--predeployment
--EXEC sp_rename 'f_ggz_zorgprestatie.tarief', 'maxtarief', 'COLUMN';
--EXEC sp_rename 'f_ggz_zorgprestatie.omzet', 'omzetmaxtarief', 'COLUMN';



    print convert(varchar(10), getdate(), 108) + ' begin vul_f_ggz_zorgprestatie'

    set nocount on

    declare
        @error int
        ,@peilmaand_id INT


  select @peilmaand_id = periodemaand_id 
  from UMRAP4.dbo.dwh_laad_datum
    where 1=1
        and status = 'OPEN'

    print @peilmaand_id
        --and laatst_geladen=1
 

IF ((select top(1) 1 from INT_ZORG..ggz_zorgprestatie) IS NOT NULL)
BEGIN

    delete a 
    from f_ggz_zorgprestatie a 
    where 1=1   
        and peilmaand_id = @peilmaand_id

END


    insert into f_ggz_zorgprestatie (        
         peilmaand_id
        ,[ggz_zorgprestatie_id]
        ,[ggz_toeslag_id]
        ,[ggz_traject_id]
        ,[patient_id]
        ,[ggz_zorgprestatie_dim_id]
        ,ggz_verzekeraar_id
        ,verzekeraar_id
        ,[zorgverlener_id]
        --,[uitvoer_datumtijd]
        ,[datum_id]
        ,[tijd_id]
        ,[duur_minuten]
        ,[duur_dagen]
        ,[aantal]
        ,omzetmaxtarief
        ,omzet_vz
        ,vz_tarief_ind
        ,verzekeraar_tarief
        ,ggz_zorgprestatie_dim_id_toeslag
        ,bedrag_toeslag
        ,bedrag_totaal
        ,[ggz_opname_id]
        ,opname_id_epic 
        ,afspraak_id_epic
        ,maxtarief
        ,normtijd_indirect
        ,doorberekende_directe_tijd
        ,directe_tijd_groepsconsulten
        ,klinisch_jn
        ,ggz_regiebehandelaar_id_zorgprestatie
        ,werknemer_id
        ,ggz_diagnose_zpm_id_zorgprestatie 

        ,ggz_dbc_id_oud 
        ,[traject_ggz_zorglabel_id] 
        ,[traject_startdatum_id] 
        ,[traject_einddatum_id] 
        ,[traject_registratiedatum_id]
        ,[traject_agb_verwijzer] 
        ,[traject_agb_verwijzer_id]
        ,[traject_ggz_verwijstype_id]
        ,[traject_tariefniveau] 
        ,[HuidigeDiagnoseJn]
        ,[HuidigeRegiebehandelaarJn]
        ,[HuidigeFaseInTraject]
        ,diagnose_huidige_id
        ,regiebehandelaar_huidige_id
        ,gc_geen_tijd_ind
        ,factuur_foutcode 
        ,factuur_statuscode 
        ,factuur_methodecode
        
            
    )
    select  
         @peilmaand_id
        ,a.ggz_zorgprestatie_id                                     as ggz_zorgprestatie_id
        ,isnull(a.ggz_toeslag_id,0)                                 as ggz_toeslag_id
        ,isnull(t.ggz_traject_id,-1)                                as ggz_traject_id
        ,isnull(a.patient_nr,-1)                                    as patient_id
        ,isnull(z.ggz_zorgprestatie_id,-1)                          as zorgprestatie_id
        ,isnull(vgz.ggz_verzekeraar_id,-1)                           as ggz_verzekeraar_id
        ,isnull(v.verzekeraar_id,-1)                                as verzekeraar_id
        ,isnull(zv.zorgverlener_id,-1)                              as zorgverlener_id
        --,a.uitvoer_datumtijd
        ,isnull(dd.datum_id,-1)                                     as datum_id        
        ,isnull(dt.tijd_id,-1)                                      as tijd_id
        ,isnull(a.duur_minuten,0)
        ,isnull(a.duur_dagen,0)
        ,isnull(a.aantal,0)
        ,isnull(a.omzet,0)
        ,isnull(a.omzet_vz,0)
        ,isnull(a.vz_tarief_ind,'O')                                as vz_tarief_ind
        ,isnull(a.verzekeraar_tarief,0)                             as verzekeraar_tarief
        ,-1                                                         as ggz_zorgprestatie_dim_id_toeslag
        ,0.00                                                       as bedrag_toeslag
        ,0.00                                                       as bedrag_totaal
        ,isnull(a.ggz_opname_id ,-1)                                as ggz_opname_id
        ,ISNULL(a.opname_nr,-1)
        ,ISNULL(a.afspraak_nr,-1)
        ,isnull(z.tarief,0)                                         as tarief --maxtarief
        ,isnull(a.normtijd_indirect,0)
        ,isnull(a.doorberekende_directe_tijd,0)
        
        ,isnull(a.directe_tijd_groepsconsulten,0)
        ,isnull(a.klinisch_jn,'O')                                  as klinisch_jn
        ,isnull(a.ggz_regiebehandelaar_id_zorgprestatie,-1)         as ggz_regiebehandelaar_id_zorgprestatie
        ,isnull(w.werknemer_id,-1)                                  as werknemer_id
        ,isnull(a.ggz_diagnose_zpm_id_zorgprestatie,-1)             as ggz_diagnose_zpm_id_zorgprestatie

        ,ISNULL(a.ggz_dbc_id_oud,-1)           
        ,ISNULL(a.[traject_ggz_zorglabel_id],-1)
        ,ISNULL(sd.datum_id,-1)                                                as [traject_startdatum_id] 
        ,ISNULL(ed.datum_id,-1)                                                as [traject_einddatum_id]
        ,ISNULL(rd.[datum_id],-1)                                              as [traject_registratiedatum_id] 
        ,ISNULL(a.[traject_agb_verwijzer] ,-1)      
        ,ISNULL(a.[traject_agb_verwijzer_id],-1)            
        ,ISNULL(a.[traject_ggz_verwijstype_id],-1)              
        ,ISNULL(a.[traject_tariefniveau] ,0)                        
        ,ISNULL([HuidigeDiagnoseJn],'O')
        ,ISNULL([HuidigeRegiebehandelaarJn],'O')
        ,ISNULL([HuidigeFaseInTraject],'Onbekend')
        ,ISNULL(a.diagnose_huidige_id,-1)           
        ,ISNULL(a.regiebehandelaar_huidige_id,-1)   
        ,a.gc_geen_tijd_ind
        ,ISNULL(a.factuur_foutcode,-1)
        ,ISNULL(a.factuur_statuscode ,-1)
        ,ISNULL(a.factuur_methodecode,-1)
        

    --into f_ggz_zorgprestatie
    
    from INT_ZORG..ggz_zorgprestatie           a  
     --left join DM_DIM..d_patient p         on p.patient_id = a.patient_nr
    left join DM_DIM..d_ggz_traject t 
        on a.ggz_traject_ok = t.ggz_traject_ok
    left join DM_DIM..d_ggz_zorgprestatie z 
        on z.ggz_zorgprestatie_ok = a.ggz_zorgprestatie_dim_id
    left join DM_DIM..d_verzekeraar v 
        on v.verz_code = cast(a.verzekeraar_id as varchar)
        and a.uitvoer_datumtijd between v.startdatum and v.einddatum
        and v.verwijderd_datum is null
    left join DM_DIM..d_tijd dt 
        on dt.tijd = left(replace(cast(convert(time(0),a.uitvoer_datumtijd) as varchar),':',''),4) 
    left join DM_DIM..d_datum dd
        on dd.datum_dat = convert(date,a.uitvoer_datumtijd)
    left join DM_DIM..d_datum sd
        on sd.datum_dat = convert(date,a.traject_startdatum)
    left join DM_DIM..d_datum ed
        on ed.datum_dat = convert(date,a.traject_einddatum)
    left join DM_DIM..d_datum rd
        on rd.datum_dat = convert(date,a.traject_registratiedatum)
        
    left join DM_DIM..d_zorgverlener zv          
        on zv.zorgverlener_code = cast(a.uitvoerder_zorgverlener_id as varchar)
        and zv.zorgverlener_id <> -1
    left join DM_DIM..d_werknemer w 
        on w.werknemer_nummer = a.werknemer_id
    left join EXTERN..ggz_normtijden nt 
        on nt.Prestatie_code = z.zorgprestatie_code
        and z.zorgprestatie_code IS NOT NULL
    left join DM_DIM..d_ggz_verzekeraar vgz 
        on vgz.ggz_verzekeraar_id = a.ggz_verzekeraar_id
    where 1=1
        and a.verwijderd_datum IS NULL
        --and z.zorgprestatiegroep_code = 'GC'
        --and duur_minuten_afspraak IS NOT NULL
        --and zv.zorgverlener_id IS NULL
  
  
    select  
        @error = @@error

    if @error <> 0
        return -1

  

    print convert(varchar(10), getdate(), 108) + ' eind vul_f_ggz_zorgprestatie'




end