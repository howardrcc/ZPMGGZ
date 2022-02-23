

CREATE   proc [dbo].[vul_ggz_traject] as 


 
/*## 
datum		wie		wat
------------------------------------------------------------------- 
2022-01-19  Howard  zorglabel, regiebehandelaar
2022-01-10  Howard  Creatie
 
            opbouwen vanuit trajecten 

-------------------------------------------------------------------
##*/
 
 

begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_traject'

 

	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_traject',
			@pk1 = 'ggz_traject_ok',
            @ts = 'ggz_traject_id'

--drop table tempdb..INT_ZORG_ggz_traject

 
	-- Insert alle nieuwe records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_traject (
            
             [ggz_traject_ok]
            ,[ggz_dbc_id_oud]
            ,[patient_nr]
            ,ggz_diagnose_zpm_id
            ,ggz_regiebehandelaar_id
            ,ggz_zorglabel_id
            ,[startdatum]
            ,[einddatum]
            ,[registratiedatum]
            ,[privacy]
            ,[financieel_type]
            ,[ggz_verwijstype_id]
            ,[agb_verwijzer]
            ,[tariefniveau]
        
        )
	  

    SELECT  
 
         t.[Id]                         as ggz_traject_ok
        --,[HealthcareTrajectoryNumber] as ggz_traject_guid
        ,t.[ExternalTrajectoryId]       as ggz_dbc_id_oud
        ,c.ClientNumber                 as patient_nr
        ,di.ggz_diagnose_zpm_id         as ggz_diagnose_zpm_id    
        ,rbh.ggz_regiebehandelaar_id     as ggz_regiebehandelaar_id --laatste rb. is ok
        ,zli.ggz_zorglabel_id           as ggz_zorglabel_id --is ok
        ,t.[StartDate]                  as startdatum
        ,t.[EndDate]                    as einddatum
        ,t.[RegistrationDate]           as registratiedatum
        --,t.[OrganizationId]           as ggz_organisatie_id --alleen radboud nog
        ,t.[Privacy]                    as privacy
        --,[ExternalInstitutionId]      
        ,t.[FinanceType]                as financieel_type
        --,[CodelistGbGgzProfileId]     
        ,vt.ggz_verwijstype_id          as ggz_verwijstype_id
        ,CASE WHEN t.ReferrerAgbCode IS NOT NULL
                THEN right(concat('0000000', t.[ReferrerAgbCode]),8)            
                                    END as agb_verwijzer
        --,[ClientIdOld]                as id_oud
        ,t.[TariffLevel]                as tariefniveau
        
 
  FROM [ZPMGGZ].[dbo].[HealthcareTrajectories] t 
  
  left join ZPMGGZ..HealthcareTrajectoryDiagnoses d 
        on t.Id = d.HealthcareTrajectoryId
    left join INT_ZORG..ggz_diagnose_zpm di
        on di.ggz_diagnose_zpm_ok = d.DiagnosisId
    left join ZPMGGZ..Clients c 
        on t.ClientId = c.Id
    left join INT_ZORG..ggz_verwijstype vt 
        on vt.ggz_verwijstype_ok = t.CodelistReferrerTypeId
        and vt.bron = 'ZPM'
    outer apply (
        select top 1 
            OrganizationUserId 
        from ZPMGGZ..HealthcareTrajectoryOrganizationUsers rb --regiebehandelaar
        where 1=1
            and rb.HealthcareTrajectoryId = t.Id
            --and rb.StartDate between t.StartDate and ISNULL(t.EndDate,'9999-12-31') --overbodig, behandelaar valt altijd binnen start einddatum van traject
            and ISNULL(rb.EndDate,'9999-12-31') >=  convert(date,GETDATE()) --in de toekomst uitsluiten
        order by rb.StartDate desc --is de laatste, niet huidig 
    ) rb
    left join ggz_regiebehandelaar rbh 
        on rbh.ggz_regiebehandelaar_ok = rb.OrganizationUserId
    left join ZPMGGZ..CodelistCareLabelHealthcareTrajectories zl
        on zl.HealthcareTrajectoriesId=t.Id
    left join ggz_zorglabel zli 
        on zli.ggz_zorglabel_ok = zl.CodelistCareLabelsId
  where t.Removed = 0
    
--select * from  UMCRADARP01.ZPMGGZ.sys.tables
--select * from UMCRADARP01.ZPMGGZ.dbo.CodelistCareLabelHealthcareConsults
--select * from CodelistCareLabelHealthcareTrajectories

--create SYNONYM CodelistCareLabelHealthcareConsults FOR UMCRADARP01.ZPMGGZ.dbo.CodelistCareLabelHealthcareConsults
--create SYNONYM CodelistCareLabelHealthcareTrajectories FOR UMCRADARP01.ZPMGGZ.dbo.CodelistCareLabelHealthcareTrajectories
--CodelistCareLabels
--CodelistCareLabelHealthcareTrajectories
--CodelistCareLabelHealthcareConsults

 --select * from ZPMGGZ..HealthcareTrajectoryOrganizationUsers
 --select * from [ZPMGGZ].[dbo].[HealthcareTrajectories] t 
--   select * from ggz_traject
--select * from ggz_zorglabel
--select * from ggz_regiebehandelaar

--aparte dim_traject_behandelaren voor history
/*
select 
    *
    ,case when GETDATE() between StartDate and ISNULL(EndDate,'9999-12-31') THEN 'J' 
          when GETDATE() > ISNULL(EndDate,'9999-12-31') THEN 'X' --update cross apply selecteer laatste
          ELSE 'N'

        END as huidig_JN --huidig of laatste

from ZPMGGZ..HealthcareTrajectoryOrganizationUsers a 
left join [ZPMGGZ].[dbo].[HealthcareTrajectories] t 
    on t.Id = a.HealthcareTrajectoryId
    and t.Start

--dim_traject_behandelaar
*/


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_traject: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_traject',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_traject',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_traject: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_traject


  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_traject'

end