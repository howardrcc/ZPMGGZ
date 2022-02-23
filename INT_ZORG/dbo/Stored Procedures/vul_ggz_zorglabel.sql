
CREATE    proc [dbo].[vul_ggz_zorglabel] as 


 
/*## 
datum		wie		wat
------------------------------------------------------------------- 
2022-01-10  Howard  Creatie
 

-------------------------------------------------------------------
##*/
 
 

begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_zorglabel'

/*

drop table if exists ggz_zorglabel
CREATE TABLE [dbo].[ggz_zorglabel](
	[ggz_zorglabel_id] [int] IDENTITY(1,1),
    [ggz_zorglabel_ok] [int] NOT NULL,
    [ggz_zorglabel_code] varchar(16) NOT NULL,
	[ggz_zorglabel_oms] [varchar](200) NOT NULL,
    [startdatum] [datetime] NOT NULL,
	[einddatum] [datetime] NULL,
	[geldstroom] [tinyint] NOT NULL,
    [creatie_datum] [datetime] NOT NULL,
	[mutatie_datum] [datetime] NOT NULL,
	[verwijderd_datum] [datetime] NULL,
) ON [PRIMARY]
 */


	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_zorglabel',
			@pk1 = 'ggz_zorglabel_ok',
            @ts = 'ggz_zorglabel_id'

--drop table tempdb..INT_ZORG_ggz_zorglabel

 -- select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ggz_zorglabel'
	-- Insert alle nieuwe records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_zorglabel (
            
            ggz_zorglabel_ok
            ,ggz_zorglabel_code
            ,ggz_zorglabel_oms
            ,startdatum
            ,einddatum
            ,geldstroom
 
        
        )
	  

    select 
        Id
        ,Code
        ,[Name]
        ,StartDate
        ,ISNULL(EndDate,'9999-12-31')
        ,FinanceStream



    from ZPMGGZ..CodelistCareLabels

 

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorglabel: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_zorglabel',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_zorglabel',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorglabel: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_zorglabel


  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_zorglabel'

end