 
create       proc [dbo].[vul_ggz_beroepscategorie] AS

 


/*## 
datum		wie		wat
------------------------------------------------------------------- 
 
2022-02-07  Howard  Creatie
-------------------------------------------------------------------
##*/
 





begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_beroepscategorie'

 
	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_beroepscategorie',
			@pk1 = 'ggz_beroepscategorie_ok',
            @ts = 'ggz_beroepscategorie_id'

--drop table tempdb..INT_ZORG_ggz_beroepscategorie
 

	-- Insert alle nieuwe records in temp
--    drop table tempdb..INT_ZORG_ggz_beroepscategorie
	INSERT INTO tempdb..INT_ZORG_ggz_beroepscategorie (
         ggz_beroepscategorie_ok      
        ,ggz_beroepscategorie_code      
        ,ggz_beroepscategorie_oms      
        
        )
    --select * from ZPMGGZ..Appointments

    select 
        a.Id             as ggz_beroepscategorie_ok
        ,a.Code          as ggz_beroepscategorie_code
        ,a.[Name]        as ggz_beroepscategorie_oms
    --into ggz_beroepscategorie
    from ZPMGGZ..CodelistProfessionCategories a
    where 1=1
        and a.Removed = 0
        --and a.AppointmentId IN(229,240)
        --and c.ClientNumber IS NULL
   
 --4581
 
 

 


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_beroepscategorie: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_beroepscategorie',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_beroepscategorie',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_beroepscategorie: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_beroepscategorie

--select * from ggz_beroepscategorie

  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_beroepscategorie'

end