
CREATE  PROC [dbo].[vul_ggz_diagnose_zpm]
/*## 
datum		wie		wat
-------------------------------------------------------------------
 2022-02-17 Howard  dmv UNION ALL ipv COALESCE
 2022-02-14 Howard  Hierarchieen gemodelleerd
-------------------------------------------------------------------
##*/
as
begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_diagnose_zpm'

	declare @vanafjaar int = 2014


   SELECT 
        [Id]                                    as ggz_diagnose_zpm_ok
        ,cast([StartDate] as smalldatetime)     as startdatum             
        ,cast([EndDate] as smalldatetime)       as einddatum
        ,[DiagnosisCode]                        as diagnose_code
        ,[DiagnosisgroupCode]                   as diagnosegroep_code
        ,[Description]                          as diagnose_oms
        ,[HierarchyLevel]                       as hierarchie
        ,CASE WHEN [Selectable] = 1 THEN 'N' ELSE 'J' END as selecteerbaar_jn
        ,[RefCodeIcd9cm]                        as icd9
        ,[RefCodeIcd10]                         as icd10
        --,[SnomedCode]
    into #temp_ggz_diagnose_zpm
    FROM [ZPMGGZ].[dbo].[CodelistDsm5s] a 
    where a.Removed = 0
         


    if ((select max(hierarchie)  FROM #temp_ggz_diagnose_zpm h1) > 6) 
    raiserror('hierarchie nr 7 toevoegen',16,1)


	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_diagnose_zpm',
			@pk1 = 'ggz_diagnose_zpm_ok',
            @ts = 'ggz_diagnose_zpm_id'
			--@pk1 = 'diagnose_discode',
			--@pk2 = 'startdatum'

--drop table tempdb..INT_ZORG_ggz_diagnose_zpm
	-- Insert records in temp

    
	  INSERT INTO tempdb..INT_ZORG_ggz_diagnose_zpm (
                [ggz_diagnose_zpm_ok]
            ,[startdatum]
            ,[einddatum]
            ,[diagnose_code]
            ,[diagnosegroep_code]
            ,[diagnose_oms]
            ,[hierarchie]
            ,[icd9]
            ,[icd10]
            ,[niv1_diagnose_code]
            ,[niv1_diagnose_oms]
            ,[niv2_diagnose_code]
            ,[niv2_diagnose_oms]
            ,[niv3_diagnose_code]
            ,[niv3_diagnose_oms]
            ,[niv4_diagnose_code]
            ,[niv4_diagnose_oms]
            ,[niv5_diagnose_code]
            ,[niv5_diagnose_oms]
            ,[niv6_diagnose_code]
            ,[niv6_diagnose_oms]
      ) 

  --COALESCE werkt niet omdat de hierarchie niet puur is.
  /*
    SELECT 
        COALESCE(h6.ggz_diagnose_zpm_ok,h5.ggz_diagnose_zpm_ok,h4.ggz_diagnose_zpm_ok,h3.ggz_diagnose_zpm_ok,h2.ggz_diagnose_zpm_ok,h1.ggz_diagnose_zpm_ok)                                as ggz_diagnose_zpm_ok
        ,COALESCE(h6.startdatum,h5.startdatum,h4.startdatum,h3.startdatum,h2.startdatum,h1.startdatum)                                                  as startdatum
        ,COALESCE(h6.einddatum,h5.einddatum,h4.einddatum,h3.einddatum,h2.einddatum,h1.einddatum)                                                        as einddatum
        ,COALESCE(h6.diagnose_code,h5.diagnose_code,h4.diagnose_code,h3.diagnose_code,h2.diagnose_code,h1.diagnose_code)                                as diagnose_code
        ,COALESCE(h6.diagnosegroep_code,h5.diagnosegroep_code,h4.diagnosegroep_code,h3.diagnosegroep_code,h2.diagnosegroep_code,h1.diagnosegroep_code)  as diagnosegroep_code
        ,COALESCE(h6.diagnose_oms,h5.diagnose_oms,h4.diagnose_oms,h3.diagnose_oms,h2.diagnose_oms,h1.diagnose_oms)                                      as diagnose_oms
        ,COALESCE(h6.hierarchie,h5.hierarchie,h4.hierarchie,h3.hierarchie,h2.hierarchie,h1.hierarchie)                                                  as hierarchie
        ,COALESCE(h6.icd9,h5.icd9,h4.icd9,h3.icd9,h2.icd9,h1.icd9)                                                                                      as icd9
        ,COALESCE(h6.icd10,h5.icd10,h4.icd10,h3.icd10,h2.icd10,h1.icd10)                                                                                as icd10
        ,h1.diagnose_code as niv1_diagnose_code
        ,h1.diagnose_oms as niv1_diagnose_oms
        ,h2.diagnose_code as niv2_diagnose_code
        ,h2.diagnose_oms as niv2_diagnose_oms
        ,h3.diagnose_code as niv3_diagnose_code
        ,h3.diagnose_oms as niv3_diagnose_oms
        ,h4.diagnose_code as niv4_diagnose_code
        ,h4.diagnose_oms as niv4_diagnose_oms
        ,h5.diagnose_code as niv5_diagnose_code
        ,h5.diagnose_oms as niv5_diagnose_oms
        ,h6.diagnose_code as niv6_diagnose_code
        ,h6.diagnose_oms as niv6_diagnose_oms
   
    
    FROM #temp_ggz_diagnose_zpm h1 

    left join  #temp_ggz_diagnose_zpm h2
        on h1.diagnose_code = h2.diagnosegroep_code
        and h2.hierarchie = 2
    left join  #temp_ggz_diagnose_zpm h3
        on h2.diagnose_code = h3.diagnosegroep_code
        and h3.hierarchie = 3
    left join  #temp_ggz_diagnose_zpm h4
        on h3.diagnose_code = h4.diagnosegroep_code
        and h4.hierarchie = 4
    left join  #temp_ggz_diagnose_zpm h5
         on h4.diagnose_code = h5.diagnosegroep_code
         and h5.hierarchie = 5
    left join  #temp_ggz_diagnose_zpm h6
        on h5.diagnose_code = h6.diagnosegroep_code
        and h6.hierarchie = 6
    where 1=1
        and h1.hierarchie = 1
        
    order by COALESCE(h6.ggz_diagnose_zpm_ok,h5.ggz_diagnose_zpm_ok,h4.ggz_diagnose_zpm_ok,h3.ggz_diagnose_zpm_ok,h2.ggz_diagnose_zpm_ok,h1.ggz_diagnose_zpm_ok)                                asc
    */
   
 
    select 
         h1.ggz_diagnose_zpm_ok    as ggz_diagnose_zpm_ok
        ,h1.startdatum             as startdatum
        ,h1.einddatum              as einddatum
        ,h1.diagnose_code          as diagnose_code
        ,h1.diagnosegroep_code     as diagnosegroep_code
        ,h1.diagnose_oms diagnose_oms
        ,h1.hierarchie
        ,h1.icd9
        ,icd10
        ,diagnose_code      as niv1_diagnose_code
        ,diagnose_oms       as niv1_diagnose_oms
        ,NULL               as niv2_diagnose_code
        ,NULL               as niv2_diagnose_oms
        ,NULL               as niv3_diagnose_code
        ,NULL               as niv3_diagnose_oms
        ,NULL               as niv4_diagnose_code
        ,NULL               as niv4_diagnose_oms
        ,NULL               as niv5_diagnose_code
        ,NULL               as niv5_diagnose_oms
        ,NULL               as niv6_diagnose_code
        ,NULL               as niv6_diagnose_oms
    from #temp_ggz_diagnose_zpm h1
    where 1=1
        and hierarchie = 1
        --and not exists (select 1 from INT_ZORG..ggz_diagnose_zpm where ggz_diagnose_zpm_ok = h1.ggz_diagnose_zpm_ok )

    UNION ALL
     
   
    select 
         h2.ggz_diagnose_zpm_ok    as ggz_diagnose_zpm_ok
        ,h2.startdatum             as startdatum
        ,h2.einddatum              as einddatum
        ,h2.diagnose_code          as diagnose_code
        ,h2.diagnosegroep_code     as diagnosegroep_code
        ,h2.diagnose_oms diagnose_oms
        ,h2.hierarchie
        ,h2.icd9
        ,h2.icd10
        ,h1.diagnose_code       as niv1_diagnose_code
        ,h1.diagnose_oms        as niv1_diagnose_oms
        ,h2.diagnose_code       as niv2_diagnose_code
        ,h2.diagnose_oms        as niv2_diagnose_oms
        ,NULL                   as niv3_diagnose_code
        ,NULL                   as niv3_diagnose_oms
        ,NULL                   as niv4_diagnose_code
        ,NULL                   as niv4_diagnose_oms
        ,NULL                   as niv5_diagnose_code
        ,NULL                   as niv5_diagnose_oms
        ,NULL                   as niv6_diagnose_code
        ,NULL                   as niv6_diagnose_oms
    from #temp_ggz_diagnose_zpm h2
    left join #temp_ggz_diagnose_zpm h1
        on h1.diagnose_code = h2.diagnosegroep_code
    where 1=1
        and h2.hierarchie = 2
        --and not exists (select 1 from INT_ZORG..ggz_diagnose_zpm where ggz_diagnose_zpm_ok = h2.ggz_diagnose_zpm_ok )

    UNION ALL
   
    select 
         h3.ggz_diagnose_zpm_ok    as ggz_diagnose_zpm_ok
        ,h3.startdatum             as startdatum
        ,h3.einddatum              as einddatum
        ,h3.diagnose_code          as diagnose_code
        ,h3.diagnosegroep_code     as diagnosegroep_code
        ,h3.diagnose_oms diagnose_oms
        ,h3.hierarchie
        ,h3.icd9
        ,h3.icd10
        ,h1.diagnose_code       as niv1_diagnose_code
        ,h1.diagnose_oms        as niv1_diagnose_oms
        ,h2.diagnose_code       as niv2_diagnose_code
        ,h2.diagnose_oms        as niv2_diagnose_oms
        ,h3.diagnose_code       as niv3_diagnose_code
        ,h3.diagnose_oms        as niv3_diagnose_oms
        ,NULL                   as niv4_diagnose_code
        ,NULL                   as niv4_diagnose_oms
        ,NULL                   as niv5_diagnose_code
        ,NULL                   as niv5_diagnose_oms
        ,NULL                   as niv6_diagnose_code
        ,NULL                   as niv6_diagnose_oms
    from #temp_ggz_diagnose_zpm h3
    left join #temp_ggz_diagnose_zpm h2
        on h2.diagnose_code = h3.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h1
        on h1.diagnose_code = h2.diagnosegroep_code
    where 1=1
        and h3.hierarchie = 3
        --and not exists (select 1 from INT_ZORG..ggz_diagnose_zpm where ggz_diagnose_zpm_ok = h3.ggz_diagnose_zpm_ok )

    UNION ALL
   
    select 
         h4.ggz_diagnose_zpm_ok    as ggz_diagnose_zpm_ok
        ,h4.startdatum             as startdatum
        ,h4.einddatum              as einddatum
        ,h4.diagnose_code          as diagnose_code
        ,h4.diagnosegroep_code     as diagnosegroep_code
        ,h4.diagnose_oms diagnose_oms
        ,h4.hierarchie
        ,h4.icd9
        ,h4.icd10
        ,h1.diagnose_code       as niv1_diagnose_code
        ,h1.diagnose_oms        as niv1_diagnose_oms
        ,h2.diagnose_code       as niv2_diagnose_code
        ,h2.diagnose_oms        as niv2_diagnose_oms
        ,h3.diagnose_code       as niv3_diagnose_code
        ,h3.diagnose_oms        as niv3_diagnose_oms
        ,h4.diagnose_code       as niv4_diagnose_code
        ,h4.diagnose_oms        as niv4_diagnose_oms
        ,NULL                   as niv5_diagnose_code
        ,NULL                   as niv5_diagnose_oms
        ,NULL                   as niv6_diagnose_code
        ,NULL                   as niv6_diagnose_oms
    from #temp_ggz_diagnose_zpm h4
    left join #temp_ggz_diagnose_zpm h3
        on h3.diagnose_code = h4.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h2
        on h2.diagnose_code = h3.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h1
        on h1.diagnose_code = h2.diagnosegroep_code
    where 1=1
        and h4.hierarchie = 4
        --and not exists (select 1 from INT_ZORG..ggz_diagnose_zpm where ggz_diagnose_zpm_ok = h4.ggz_diagnose_zpm_ok )
     

    UNION ALL
   
    select 
         h5.ggz_diagnose_zpm_ok    as ggz_diagnose_zpm_ok
        ,h5.startdatum             as startdatum
        ,h5.einddatum              as einddatum
        ,h5.diagnose_code          as diagnose_code
        ,h5.diagnosegroep_code     as diagnosegroep_code
        ,h5.diagnose_oms diagnose_oms
        ,h5.hierarchie
        ,h5.icd9
        ,h5.icd10
        ,h1.diagnose_code       as niv1_diagnose_code
        ,h1.diagnose_oms        as niv1_diagnose_oms
        ,h2.diagnose_code       as niv2_diagnose_code
        ,h2.diagnose_oms        as niv2_diagnose_oms
        ,h3.diagnose_code       as niv3_diagnose_code
        ,h3.diagnose_oms        as niv3_diagnose_oms
        ,h4.diagnose_code       as niv4_diagnose_code
        ,h4.diagnose_oms        as niv4_diagnose_oms
        ,h5.diagnose_code       as niv5_diagnose_code
        ,h5.diagnose_oms        as niv5_diagnose_oms
        ,NULL   as niv6_diagnose_code
        ,NULL   as niv6_diagnose_oms
    from #temp_ggz_diagnose_zpm h5
    left join #temp_ggz_diagnose_zpm h4
        on h4.diagnose_code = h5.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h3
        on h3.diagnose_code = h4.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h2
        on h2.diagnose_code = h3.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h1
        on h1.diagnose_code = h2.diagnosegroep_code
    where 1=1
        and h5.hierarchie = 5
        --and not exists (select 1 from INT_ZORG..ggz_diagnose_zpm where ggz_diagnose_zpm_ok = h5.ggz_diagnose_zpm_ok )

    UNION ALL
    
    select 
         h6.ggz_diagnose_zpm_ok    as ggz_diagnose_zpm_ok
        ,h6.startdatum             as startdatum
        ,h6.einddatum              as einddatum
        ,h6.diagnose_code          as diagnose_code
        ,h6.diagnosegroep_code     as diagnosegroep_code
        ,h6.diagnose_oms diagnose_oms
        ,h6.hierarchie
        ,h6.icd9
        ,h6.icd10
        ,h1.diagnose_code       as niv1_diagnose_code
        ,h1.diagnose_oms        as niv1_diagnose_oms
        ,h2.diagnose_code       as niv2_diagnose_code
        ,h2.diagnose_oms        as niv2_diagnose_oms
        ,h3.diagnose_code       as niv3_diagnose_code
        ,h3.diagnose_oms        as niv3_diagnose_oms
        ,h4.diagnose_code       as niv4_diagnose_code
        ,h4.diagnose_oms        as niv4_diagnose_oms
        ,h5.diagnose_code       as niv5_diagnose_code
        ,h5.diagnose_oms        as niv5_diagnose_oms
        ,h6.diagnose_code       as niv6_diagnose_code
        ,h6.diagnose_oms        as niv6_diagnose_oms
    from #temp_ggz_diagnose_zpm h6
    left join #temp_ggz_diagnose_zpm h5
        on h5.diagnose_code = h6.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h4
        on h4.diagnose_code = h5.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h3
        on h3.diagnose_code = h4.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h2
        on h2.diagnose_code = h3.diagnosegroep_code
    left join #temp_ggz_diagnose_zpm h1
        on h1.diagnose_code = h2.diagnosegroep_code
    where 1=1
        and h6.hierarchie = 6
        --and not exists (select 1 from INT_ZORG..ggz_diagnose_zpm where ggz_diagnose_zpm_ok = h6.ggz_diagnose_zpm_ok )
     
 


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_diagnose: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_diagnose_zpm',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_diagnose_zpm',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_diagnose_zpm: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_diagnose_zpm

    print convert(varchar(10), getdate(), 108) + ' einde vul_ggz_diagnose_zpm'

end