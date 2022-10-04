
CREATE   PROC [dbo].[vul_ggz_verwijstype]
/*## 
datum		wie			wat
-------------------------------------------------------------------
2022-07-03  Howard  ODE is leeg (op ACC?)
                    ADD verwijstypen vanuit ZPM
2018-10-22	MP		Upd: @vanafjaar 2014
2015-08-13	MP		voorloop-0 toegevoegd
2015-07-09  MP		Creatie
-------------------------------------------------------------------
Bron: ODE..stamtypeverwijzerbasisggz
##*/
as
begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_verwijstype'

	declare @vanafjaar int = 2014

	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_verwijstype',
			@pk1 = 'startdatum',
            @pk3 = 'ggz_verwijstype_ok',
            @pk2 = 'bron',
            @ts =  'ggz_verwijstype_id'

	-- Insert alle records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_verwijstype (
		 ggz_verwijstype_ok
		,verwijstype_code
		,verwijstype_oms
		,startdatum
		,einddatum
		,agb_verplicht_jn
        ,bron
		)
	select
		 stvbg_id											as ggz_verwijstype_ok
		,right('00'+stvbg_code,2)							as verwijstype_code
		,stvbg_omschrijving									as verwijstype_oms
		,convert(date,stvbg_begindatum)						as startdatum
		,isnull(convert(date,stvbg_einddatum),'9999-12-31')	as einddatum
		,case when stvbg_agbverplicht=1 
			then 'J' 
			else 'N' 
		 end												as agb_verplicht_jn
         ,'ODE'                                             as bron


	from	
			ODE..stamtypeverwijzerbasisggz
	where 1=1
        --and isnull(year(stvbg_einddatum),9999) >= @vanafjaar
        
	INSERT INTO tempdb..INT_ZORG_ggz_verwijstype (
		 ggz_verwijstype_ok
		,verwijstype_code
		,verwijstype_oms
		,startdatum
		,einddatum
		,agb_verplicht_jn
        ,bron
		)
	select
		 Id     											as ggz_verwijstype_ok
		,right('00'+Code,2)							        as verwijstype_code
		,[Name]									            as verwijstype_oms
		,convert(date,StartDate)						    as startdatum
		,isnull(convert(date,EndDate),'9999-12-31')     	as einddatum
		,case when AgbCodeRequired=1 
			then 'J' 
			else 'N' 
		 end												as agb_verplicht_jn
         ,'ZPM'                                             as bron


	from	
			ZPMGGZ..CodelistReferrerTypes
	where 1=1
        and Removed = 0
        --and isnull(year(stvbg_einddatum),9999) >= @vanafjaar
        

          



	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_verwijstype: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_verwijstype',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_verwijstype',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_verwijstype: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_verwijstype

    print convert(varchar(10), getdate(), 108) + ' einde vul_ggz_verwijstype'

end