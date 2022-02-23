

CREATE    proc [dbo].[vul_d_ggz_zorglabel] AS
 
/*## 
Historie

Datum       wie    wat
-------------------------------------------------------------------
2022-01-19  Howard  creatie
 

------------------------------------------------------------------- 

##*/

--select * from INT_ZORG..ggz_zorglabel
BEGIN

    PRINT convert(varchar(20), getdate(), 120) + ' begin vul_d_ggz_zorglabel'

   set nocount on

    declare
        @error int


    if not exists (select 1 from d_ggz_zorglabel where ggz_zorglabel_id = -1)
    begin

--        set identity_insert d_ggz_zorglabel on

        insert    into d_ggz_zorglabel (    
                 [ggz_zorglabel_id]
                ,[ggz_zorglabel_ok]
                ,[ggz_zorglabel_code]
                ,[ggz_zorglabel_oms]
                ,geldstroom
                ,creatie_datum
                ,mutatie_datum
                ,verwijderd_datum
                )
                
        select 
                -1
                ,-1
                ,'Onbekend'
                ,'Onbekend'
                ,NULL
                ,getdate()
                ,getdate()
                ,NULL

        --set identity_insert d_ggz_zorglabel off

    end


  

exec make_temp_tab @db = 'DM_DIM',@tab='d_ggz_zorglabel', @pk1='ggz_zorglabel_id'

--select * from tempdb..DM_DIM_d_ggz_zorglabel
--drop table if exists tempdb..DM_DIM_d_ggz_zorglabel
insert into tempdb..DM_DIM_d_ggz_zorglabel(
                [ggz_zorglabel_id]
                ,[ggz_zorglabel_ok]
                ,[ggz_zorglabel_code]
                ,[ggz_zorglabel_oms]
                ,geldstroom
  
)

    select 
        [ggz_zorglabel_id]
        ,[ggz_zorglabel_ok]
        ,[ggz_zorglabel_code]
        ,[ggz_zorglabel_oms]
        ,geldstroom
    from d_ggz_zorglabel
    where ggz_zorglabel_id = -1

UNION ALL

    select 
        [ggz_zorglabel_id]
        ,[ggz_zorglabel_ok]
        ,[ggz_zorglabel_code]
        ,[ggz_zorglabel_oms]
        ,geldstroom
    --select *
    from INT_ZORG..ggz_zorglabel 


	 
    if @error <> 0
        return -1

    exec DM_DIM.dbo.merge_dim 
					   @inc_db = 'tempdb'
                          , @inc_tab = 'DM_DIM_d_ggz_zorglabel'
                          , @cum_db = 'DM_DIM'
                          , @cum_tab = 'd_ggz_zorglabel'

   drop table tempdb.dbo.DM_DIM_d_ggz_zorglabel
   
    PRINT convert(varchar(20), getdate(), 120) + ' eind vul_d_ggz_zorglabel'



end