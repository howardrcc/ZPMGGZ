

CREATE    proc [dbo].[vul_d_ggz_regiebehandelaar] AS
 
/*## 
Historie

Datum       wie    wat
-------------------------------------------------------------------
2022-01-19  Howard  creatie
 

------------------------------------------------------------------- 

##*/

--select * from INT_ZORG..ggz_regiebehandelaar
BEGIN

    PRINT convert(varchar(20), getdate(), 120) + ' begin vul_d_ggz_regiebehandelaar'

   set nocount on

    declare
        @error int


    if not exists (select 1 from d_ggz_regiebehandelaar where ggz_regiebehandelaar_id = -1)
    begin

        --set identity_insert d_ggz_regiebehandelaar on

        insert    into d_ggz_regiebehandelaar (    
                 [ggz_regiebehandelaar_id]
                ,[ggz_regiebehandelaar_ok]
                ,[ggz_regiebehandelaar_code]
                ,[ggz_regiebehandelaar_agb]
                ,[ggz_regiebehandelaar_naam]
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
 
                ,getdate()
                ,getdate()
                ,NULL

--        set identity_insert d_ggz_regiebehandelaar off

    end


  

exec make_temp_tab @db = 'DM_DIM',@tab='d_ggz_regiebehandelaar', @pk1='ggz_regiebehandelaar_id'--,@ts = 'ggz_regiebehandelaar_id'

--select * from tempdb..DM_DIM_d_ggz_regiebehandelaar
--drop table if exists tempdb..DM_DIM_d_ggz_regiebehandelaar
insert into tempdb..DM_DIM_d_ggz_regiebehandelaar(
                [ggz_regiebehandelaar_id]
                ,[ggz_regiebehandelaar_ok]
                ,[ggz_regiebehandelaar_code]
                ,[ggz_regiebehandelaar_agb]
                ,[ggz_regiebehandelaar_naam]
  
)

    select 
       [ggz_regiebehandelaar_id]
       ,[ggz_regiebehandelaar_ok]
        ,[ggz_regiebehandelaar_code]
        ,[ggz_regiebehandelaar_agb]
        ,[ggz_regiebehandelaar_naam]
    from d_ggz_regiebehandelaar
    where ggz_regiebehandelaar_id = -1

UNION ALL

    select 
         [ggz_regiebehandelaar_id]
         ,[ggz_regiebehandelaar_ok]
        ,[ggz_regiebehandelaar_code]
        ,[ggz_regiebehandelaar_agb]
        ,[ggz_regiebehandelaar_naam]
    --select *
    from INT_ZORG..ggz_regiebehandelaar 


	 
    if @error <> 0
        return -1

    exec DM_DIM.dbo.merge_dim 
					   @inc_db = 'tempdb'
                          , @inc_tab = 'DM_DIM_d_ggz_regiebehandelaar'
                          , @cum_db = 'DM_DIM'
                          , @cum_tab = 'd_ggz_regiebehandelaar'

   drop table tempdb.dbo.DM_DIM_d_ggz_regiebehandelaar
   
    PRINT convert(varchar(20), getdate(), 120) + ' eind vul_d_ggz_regiebehandelaar'



end