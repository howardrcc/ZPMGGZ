

CREATE     proc [dbo].[vul_d_ggz_zorgprestatie] AS
 
/*## 
Historie

Datum       wie    wat
-------------------------------------------------------------------
2022-01-10  Howard  Creatie

------------------------------------------------------------------- 

##*/


BEGIN

    PRINT convert(varchar(20), getdate(), 120) + ' begin vul_d_ggz_zorgprestatie'

   set nocount on

    declare
        @error int


    if not exists (select 1 from d_ggz_zorgprestatie where ggz_zorgprestatie_id = -1)
    begin

        --set identity_insert d_ggz_zorgprestatie on

        insert    into d_ggz_zorgprestatie (    
                 [ggz_zorgprestatie_id]
                ,[ggz_zorgprestatie_ok]
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
                --,[consult_type]
                ,[setting_code]
                ,[beroepscategorie_code]
                ,[duur_verrichting_minuten_vanaf]
                ,[groeps_grootte]
                ,[verblijf_niveau_zorg]
                ,[verblijf_niveau_beveiliging]
                ,creatie_datum
                ,mutatie_datum
                ,verwijderd_datum
                )
                
        select 
                -1
                ,-1
                ,'Onbekend'
                ,'Onbekend'
                ,'Onbekend'
                ,'Onbekend'
                ,'Onbekend'
                ,'1900-01-01'
                ,'9999-12-31'
                ,0 --tarief
                ,-1
                ,-1
                --,-1
                ,'Onbekend'
                ,'Onbekend'
                ,0
                ,0
                ,'Onbekend'
                ,-1
                ,getdate()
                ,getdate()
                ,NULL

        --set identity_insert d_ggz_zorgprestatie off

    end


  

exec make_temp_tab @db = 'DM_DIM',@tab='d_ggz_zorgprestatie', @pk1='ggz_zorgprestatie_id' --code',@ts = 'ggz_zorgprestatie_id'

--select * from tempdb..DM_DIM_d_ggz_zorgprestatie

insert into tempdb..DM_DIM_d_ggz_zorgprestatie(
      [ggz_zorgprestatie_id]
      ,[ggz_zorgprestatie_ok]
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
      --,[consult_type]
      ,[setting_code]
      ,[beroepscategorie_code]
      ,[duur_verrichting_minuten_vanaf]
      ,[groeps_grootte]
      ,[verblijf_niveau_zorg]
      ,[verblijf_niveau_beveiliging]
  
)

    select 
        [ggz_zorgprestatie_id]
        ,[ggz_zorgprestatie_ok]
        ,[zorgprestatie_code]
        ,[zorgprestatie_oms]
        ,[zorgprestatiegroep_code]
        ,[zorgprestatiegroep_oms]
        ,[consult_type]
        ,[startdatum]
        ,[einddatum]
        ,[tarief]
        ,[tarief_niveau]
        ,[geldstroom]
        --,[consult_type]
        ,[setting_code]
        ,[beroepscategorie_code]
        ,[duur_verrichting_minuten_vanaf]
        ,[groeps_grootte]
        ,[verblijf_niveau_zorg]
        ,[verblijf_niveau_beveiliging]
    from d_ggz_zorgprestatie
    where ggz_zorgprestatie_id = -1

UNION ALL

    select 
        [ggz_zorgprestatie_dim_id]
        ,[ggz_zorgprestatie_dim_id]
        ,[zorgprestatie_code]
        ,[zorgprestatie_oms]
        ,zorgprestatiegroep_code
        ,zorgprestatiegroep_oms
        ,consult_type
        ,[startdatum]
        ,[einddatum]
        ,[tarief]
        ,[tarief_niveau]
        ,[geldstroom]
--        ,[consult_type]
        ,[setting_code]
        ,[beroepscategorie_code]
        ,[duur_verrichting_minuten_vanaf]
        ,[groeps_grootte]
        ,[verblijf_niveau_zorg]
        ,[verblijf_niveau_beveiliging]
        --select * 
    from INT_ZORG..ggz_zorgprestatie_dim


	 
    if @error <> 0
        return -1

    exec DM_DIM.dbo.merge_dim 
					   @inc_db = 'tempdb'
                          , @inc_tab = 'DM_DIM_d_ggz_zorgprestatie'
                          , @cum_db = 'DM_DIM'
                          , @cum_tab = 'd_ggz_zorgprestatie'

   drop table tempdb.dbo.DM_DIM_d_ggz_zorgprestatie
   
    PRINT convert(varchar(20), getdate(), 120) + ' eind vul_d_ggz_zorgprestatie'



end