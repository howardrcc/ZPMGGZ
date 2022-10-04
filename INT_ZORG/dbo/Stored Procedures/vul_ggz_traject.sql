
 

CREATE   proc [dbo].[vul_ggz_traject] as 

 
/*## 
datum		wie		wat
------------------------------------------------------------------- 
2022-03-31  Howard  Regiebehandelaar en diagnose uit traject
2022-03-24  Howard  Diagnosis naar cross apply vanwege duplicaten in de bron
2022-03-07  Howard  kun je het verwijstype ook toevoegen in de tabel. 
                    de instelling, 
                    naam bij de agb code van de verwijzer, 
                    beroep verwijzer (alleen bepaalde beroepsgroepen zoals bv een huisarts mogen verwijzer zijn.
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

 
--

	-- Insert alle nieuwe records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_traject (
            
             [ggz_traject_ok]
            ,[ggz_dbc_id_oud]
            ,[patient_nr]
 
            ,ggz_zorglabel_id
            ,[startdatum]
            ,[einddatum]
            ,[registratiedatum]
            ,[privacy]
            ,[financieel_type]
            ,[ggz_verwijstype_id]
            ,[agb_verwijzer]
            ,[agb_verwijzer_id]
            ,[tariefniveau]
 
        )
	  

    SELECT  
 
         t.[Id]                         as ggz_traject_ok
        ,t.[ExternalTrajectoryId]       as ggz_dbc_id_oud
        ,c.ClientNumber                 as patient_nr
        ,zli.ggz_zorglabel_id           as ggz_zorglabel_id --is ok
        ,t.[StartDate]                  as startdatum
        ,t.[EndDate]                    as einddatum
        ,t.[RegistrationDate]           as registratiedatum

        ,t.[Privacy]                    as privacy

        ,t.[FinanceType]                as financieel_type

        ,vt.ggz_verwijstype_id          as ggz_verwijstype_id
        ,CASE WHEN t.ReferrerAgbCode IS NOT NULL
                THEN right(concat('0000000', t.[ReferrerAgbCode]),8)
                                    END as agb_verwijzer
        ,agb.agb_verwijzer_id
        ,t.[TariffLevel]                as tariefniveau
 
 
  FROM [ZPMGGZ].[dbo].[HealthcareTrajectories] t 
 
    left join ZPMGGZ..Clients c 
        on t.ClientId = c.Id
    left join INT_ZORG..ggz_verwijstype vt 
        on vt.ggz_verwijstype_ok = t.CodelistReferrerTypeId
        and vt.bron = 'ZPM'
 
    left join ZPMGGZ..CodelistCareLabelHealthcareTrajectories zl
        on zl.HealthcareTrajectoriesId=t.Id
    left join ggz_zorglabel zli 
        on zli.ggz_zorglabel_ok = zl.CodelistCareLabelsId
    left join agb_verwijzer agb
        on left(right(concat('0000000', t.[ReferrerAgbCode]),8),2) = agb.agb_code_zorgpartij
    where t.Removed = 0
     

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