CREATE     proc [dbo].[vul_ggz_zorgprestatie_dim] AS


/*

2022-01-10  Howard  Creatie

*/



BEGIN
    set nocount on
PRINT convert(varchar(20), getdate(), 120) + ' begin vul_ggz_zorgprestatie_dim'


 

 

	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_zorgprestatie_dim',
			@pk1 = 'ggz_zorgprestatie_dim_ok',
            @ts = 'ggz_zorgprestatie_dim_id'

--drop table tempdb..INT_ZORG_ggz_zorgprestatie

 
	-- Insert alle nieuwe records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_zorgprestatie_dim (
 
      [ggz_zorgprestatie_dim_ok]
      ,[zorgprestatie_code]
      ,[zorgprestatie_oms]
      ,[zorgprestatiegroep_code]
      ,[zorgprestatiegroep_oms]
      ,consult_type
      ,[startdatum]
      ,[einddatum]
      ,[tarief]
      ,[tarief_niveau]
      ,[geldstroom]
      ,[setting_code]
      ,setting_oms
      ,[beroepscategorie_code]
      ,[duur_verrichting_minuten_vanaf]
      ,[groeps_grootte]
      ,[verblijf_niveau_zorg]
      ,[verblijf_niveau_beveiliging]
 

    )

 

select 
    act.Id                                                                  as ggz_zorgprestatie_dim_ok
    ,act.Code                                                               as zorgprestatie_code --verrichting_code?
    ,act.[Name]                                                             as zorgprestatie_oms
    ,left(act.Code,2)                                                       as zorgprestatiegroep_code
    ,CASE   WHEN left(act.Code,2) = 'CO' THEN 'Consulten'
            WHEN left(act.Code,2) = 'GC' THEN 'Groepsconsulten'
            WHEN left(act.Code,2) = 'VD' THEN 'Verblijfsdagen'
            WHEN left(act.Code,2) = 'OV' THEN 'Overige Verrichtingen'
            WHEN left(act.Code,2) = 'TC' THEN 'Toeslagen'
            else 'Onbekend'
            END                                                             as ggz_zorgprestatiegroep_oms
    ,CASE   WHEN left(act.Code,2) = 'CO' AND ConsultType = 1 THEN 'Diagnostiek'
            WHEN left(act.Code,2) = 'CO' AND ConsultType = 2 THEN 'Behandeling'
            WHEN left(act.Code,2) = 'GC' THEN 'Groepsconsulten'
            WHEN left(act.Code,2) = 'VD' THEN 'Verblijfsdagen'
            WHEN left(act.Code,2) = 'OV' THEN 'Overige Verrichtingen'
            WHEN left(act.Code,2) = 'TC' THEN 'Toeslagen'
            else 'Onbekend'
            END as consult_type 
    ,convert(datetime2(0),act.StartDate,120)                                as startdatum
    ,ISNULL(convert(datetime2(0),act.EndDate,120),'9999-12-31 00:00:00')    as einddatum  
    
    ,act.Tariff                                                             as tarief
    ,c.TariffLevel                                                          as tarief_niveau
    ,act.FinanceStream                                                      as geldstroom
    ,c.SettingCode                                                          as setting_code
    ,s.[Name]                                                               as setting_oms
    ,COALESCE(c.ProfessionCategoryCode,gc.ProfessionCategoryCode,ov.ProfessionCategoryCode)                                               
                                                                            as beroepscategorie_code
    ,COALESCE(c.DurationInMinutesFrom, gc.BlockLengthMinutes,ov.DurationInMinutesFrom,tc.DurationInMinutesFrom)
                                                                            as duur_verrichting_minuten_vanaf
    ,gc.GroupSize                                                           as groeps_grootte --ISNULL -> 1?
    ,vd.CareLevel                                                           as verblijf_niveau_zorg
    ,vd.SecurityLevel                                                       as verblijf_niveau_beveiliging
    --geen duration tot
--into ggz_zorgprestatie select *
from ZPMGGZ..CodelistActivities act
left join ZPMGGZ..CodelistConsults c 
    on act.Code = c.ActivityCode
    and c.Removed = 0
    and left(c.ActivityCode,2) = 'CO'
left join ZPMGGZ..CodelistGroupConsults gc 
    on gc.ActivityCode = act.Code
    and gc.Removed = 0
    and left(gc.ActivityCode,2) = 'GC'
left join ZPMGGZ..CodelistInPatientStays vd 
    on vd.ActivityCode = act.Code
    and vd.Removed = 0
    and left(vd.ActivityCode,2) = 'VD'
left join ZPMGGZ..CodelistOtherActivities ov
    on ov.ActivityCode = act.Code
    and ov.Removed = 0
    and left(ov.ActivityCode,2) = 'OV'
left join ZPMGGZ..CodelistSurchargeConsults tc
    on tc.ActivityCode = act.Code
    and tc.Removed = 0
    and left(tc.ActivityCode,2) = 'TC'
left join ZPMGGZ..CodelistSurchargeInPatientStays tv
    on tv.ActivityCode = act.Code
    and tv.Removed = 0 
    and left(tv.ActivityCode,2)='TV'
left join ZPMGGZ..CodelistSettings s 
    on s.Code = c.SettingCode
where 1=1
    and act.Removed = 0
     


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie_dim: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_zorgprestatie_dim',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_zorgprestatie_dim',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_zorgprestatie_dim: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_zorgprestatie_dim
 
--select * from INT_ZORG..ggz_zorgprestatie_dim

PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_zorgprestatie_dim'

end 


--