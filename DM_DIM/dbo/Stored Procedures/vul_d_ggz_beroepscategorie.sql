

create      proc [dbo].[vul_d_ggz_beroepscategorie] AS
 
/*## 
Historie

Datum       wie    wat
-------------------------------------------------------------------
2022-01-19  Howard  creatie
 

------------------------------------------------------------------- 

##*/

--select * from INT_ZORG..ggz_beroepscategorie
BEGIN

    PRINT convert(varchar(20), getdate(), 120) + ' begin vul_d_ggz_beroepscategorie'

   set nocount on

    declare
        @error int


    if not exists (select 1 from d_ggz_beroepscategorie where ggz_beroepscategorie_id = -1)
    begin

--        set identity_insert d_ggz_beroepscategorie on

        insert    into d_ggz_beroepscategorie (    
                 [ggz_beroepscategorie_id]
                ,[ggz_beroepscategorie_ok]
                ,[ggz_beroepscategorie_code]
                ,[ggz_beroepscategorie_oms]
                ,creatie_datum
                ,mutatie_datum
                ,verwijderd_datum
                )
                
        select 
                -1
                ,-1
                ,'Onbekend'
                ,'Onbekend'
                ,getdate()
                ,getdate()
                ,NULL

        --set identity_insert d_ggz_beroepscategorie off

    end


  

exec make_temp_tab @db = 'DM_DIM',@tab='d_ggz_beroepscategorie', @pk1='ggz_beroepscategorie_id'

--select * from tempdb..DM_DIM_d_ggz_beroepscategorie
--drop table if exists tempdb..DM_DIM_d_ggz_beroepscategorie
insert into tempdb..DM_DIM_d_ggz_beroepscategorie(
                [ggz_beroepscategorie_id]
                ,[ggz_beroepscategorie_ok]
                ,[ggz_beroepscategorie_code]
                ,[ggz_beroepscategorie_oms]
                
  
)

    select 
        [ggz_beroepscategorie_id]
        ,[ggz_beroepscategorie_ok]
        ,[ggz_beroepscategorie_code]
        ,[ggz_beroepscategorie_oms]
        
    from d_ggz_beroepscategorie
    where ggz_beroepscategorie_id = -1

UNION ALL

    select 
        [ggz_beroepscategorie_id]
        ,[ggz_beroepscategorie_ok]
        ,[ggz_beroepscategorie_code]
        ,[ggz_beroepscategorie_oms]
            --select *
    from INT_ZORG..ggz_beroepscategorie 


	 
    if @error <> 0
        return -1

    exec DM_DIM.dbo.merge_dim 
					   @inc_db = 'tempdb'
                          , @inc_tab = 'DM_DIM_d_ggz_beroepscategorie'
                          , @cum_db = 'DM_DIM'
                          , @cum_tab = 'd_ggz_beroepscategorie'

   drop table tempdb.dbo.DM_DIM_d_ggz_beroepscategorie
   
    PRINT convert(varchar(20), getdate(), 120) + ' eind vul_d_ggz_beroepscategorie'



end