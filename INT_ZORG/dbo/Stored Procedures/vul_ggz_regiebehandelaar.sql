CREATE      proc [dbo].[vul_ggz_regiebehandelaar] as 

--select * from ggz_regiebehandelaar
 
/*## 
datum		wie		wat
------------------------------------------------------------------- 
2022-01-10  Howard  Creatie
 

-------------------------------------------------------------------
##*/
 
 

begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_regiebehandelaar'

/*

drop table if exists ggz_regiebehandelaar
CREATE TABLE [dbo].[ggz_regiebehandelaar](
	[ggz_regiebehandelaar_id] [int] IDENTITY(1,1),
    [ggz_regiebehandelaar_ok] [int] NOT NULL,
    [ggz_regiebehandelaar_code] varchar(16) NULL,
	[ggz_regiebehandelaar_agb] [varchar](16) NULL,
    [ggz_regiebehandelaar_naam] [varchar](255) NULL,
	--[zorgverlener_jn] [varchar](1) NOT NULL,
    [creatie_datum] [datetime] NOT NULL,
	[mutatie_datum] [datetime] NOT NULL,
	[verwijderd_datum] [datetime] NULL,
) ON [PRIMARY]
 */

--drop table if exists tempdb..INT_ZORG_ggz_regiebehandelaar
	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_regiebehandelaar',
			@pk1 = 'ggz_regiebehandelaar_ok',
            @ts = 'ggz_regiebehandelaar_id'

--drop table tempdb..INT_ZORG_ggz_regiebehandelaar

 -- select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ggz_regiebehandelaar'
	-- Insert alle nieuwe records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_regiebehandelaar (
            
            ggz_regiebehandelaar_ok
            ,ggz_regiebehandelaar_code
            ,ggz_regiebehandelaar_agb
            ,ggz_regiebehandelaar_naam
            --,zorgverlener_jn
 
        )
	  

    select 
        Id
        ,[HealthcareProviderCode]
        ,HealthcareProviderAgbCode
        ,FullName
        /*,CASE WHEN IsHealthcareProvider = 0 THEN '0'
                WHEN IsHealthcareProvider = 1 THEN '1'
            END as zorgverlener_jn
      */
    from ZPMGGZ..OrganizationUsers
    where 1=1
        and Removed = 0 --alleen zorgverleners?
        and IsHealthcareProvider = 1

  


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_regiebehandelaar: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_regiebehandelaar',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_regiebehandelaar',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_regiebehandelaar: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_regiebehandelaar


  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_regiebehandelaar'

end