 

CREATE PROC [dbo].[vul_d_ggz_diagnose_zpm]

/*## 

historie

datum       wie			wat
------------------------------------------------------------------- 
2022-02-14  Howard      hierarchie
2022-01-12  Howard      Creatie
------------------------------------------------------------------- 

##*/
as
begin


--select * from INT_ZORG..ggz_diagnose_zpm

    print convert(varchar(20), getdate(), 120) + ' begin vul_d_ggz_diagnose_zpm'

    set nocount on
    declare 
       @error int

	if not exists (select * from dbo.d_ggz_diagnose_zpm where ggz_diagnose_zpm_id = -1)
    begin

        --set identity_insert dbo.d_ggz_diagnose_zpm on

        insert into dbo.d_ggz_diagnose_zpm (    
            ggz_diagnose_zpm_id
            ,ggz_diagnose_zpm_ok
            ,startdatum
            ,einddatum
            ,diagnose_code
            ,diagnose_oms
            ,hierarchie
            ,icd9
            ,icd10
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
            ,   creatie_datum
            ,   mutatie_datum
            ,   verwijderd_datum)
        select 
            -1
        ,   -1
        ,   '1900-01-01'
        ,   '1900-01-01'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   -1
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   'Onbekend'
        ,   GETDATE()
        ,   GETDATE()
        ,   NULL

        --set identity_insert dbo.d_ggz_diagnose_zpm off
 
    end

--drop table  select * from tempdb.dbo.DM_DIM_d_ggz_diagnose_zpm 
    exec DM_DIM.dbo.make_temp_tab 
						    @db	    = 'DM_DIM'
						  , @tab	= 'd_ggz_diagnose_zpm'
						  , @pk1	= 'ggz_diagnose_zpm_id'   
                          --, @pk2	= 'diagnose_code'   
                          --, @pk3	= 'startdatum'   
						  --, @ts	    =   ''
   
    insert into tempdb.dbo.DM_DIM_d_ggz_diagnose_zpm (   
        ggz_diagnose_zpm_id
        ,ggz_diagnose_zpm_ok
        ,startdatum
        ,einddatum
        ,diagnose_code
        ,diagnose_oms
        ,hierarchie
        ,icd9
        ,icd10
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
	select  
        ggz_diagnose_zpm_id
        ,ggz_diagnose_zpm_ok
        ,startdatum
        ,einddatum
        ,diagnose_code
        ,diagnose_oms
        ,hierarchie
        ,icd9
        ,icd10
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
    from d_ggz_diagnose_zpm
    where ggz_diagnose_zpm_id = -1

    union
    
	select 
        ggz_diagnose_zpm_id
        ,ggz_diagnose_zpm_ok
        ,startdatum
        ,einddatum
        ,diagnose_code
        ,diagnose_oms
        ,hierarchie
        ,icd9
        ,icd10
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
    --into d_ggz_diagnose_zpm select *   
    from INT_ZORG..ggz_diagnose_zpm
    where verwijderd_datum is NULL
     
	 
    if @error <> 0
        return -1

    exec DM_DIM.dbo.merge_dim 
					   @inc_db = 'tempdb'
                          , @inc_tab = 'DM_DIM_d_ggz_diagnose_zpm'
                          , @cum_db = 'DM_DIM'
                          , @cum_tab = 'd_ggz_diagnose_zpm'
--                          , @print_only = 1

   drop table tempdb.dbo.DM_DIM_d_ggz_diagnose_zpm

   print convert(varchar(20), getdate(), 120) + ' eind vul_d_ggz_diagnose_zpm'

end;