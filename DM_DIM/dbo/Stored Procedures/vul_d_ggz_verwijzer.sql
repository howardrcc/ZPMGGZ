
CREATE PROC [dbo].[vul_d_ggz_verwijzer]

/*## 
historie
datum       wie     wat
------------------------------------------------------------------- 
2017-07-27  MP      Add: startdatum,einddatum,werknemer_nummer
2016-04-12  MP      Creatie
------------------------------------------------------------------- 
##*/
as
begin
    print convert(varchar(20), getdate(), 120) + ' begin vul_d_ggz_verwijzer'

    declare 
       @error int

	if not exists (select 1 from dbo.d_ggz_verwijzer where ggz_verwijzer_id = -1)
    begin

        set identity_insert dbo.d_ggz_verwijzer on

        insert into dbo.d_ggz_verwijzer (    
			 ggz_verwijzer_id
			,verwijzer_agb
			,verwijzer_naam
            ,startdatum
            ,einddatum
            ,werknemer_nummer
			,creatie_datum
			,mutatie_datum
			,verwijderd_datum)
        select 
            -1
            ,'00000000'
            ,'ONBEKEND'
            ,'1900-01-01'
            ,'9999-12-31'
            ,'ONBEKEND'
            ,getdate()
            ,getdate()
            ,null

        set identity_insert dbo.d_ggz_verwijzer off
	   DBCC CHECKIDENT (
           'd_ggz_verwijzer' ,reseed,0
	   )

    end


    exec DM_DIM.dbo.make_temp_tab 
						    @db	= 'DM_DIM'
						  , @tab	= 'd_ggz_verwijzer'
						  , @pk1	= 'verwijzer_agb'   
						  , @ts	= 'ggz_verwijzer_id'

    insert into tempdb.dbo.DM_DIM_d_ggz_verwijzer (   
         verwijzer_agb
        ,verwijzer_naam
        ,startdatum
        ,einddatum
        ,werknemer_nummer
    ) 
	select  
         verwijzer_agb
        ,verwijzer_naam
        ,startdatum
        ,einddatum
        ,werknemer_nummer
    from d_ggz_verwijzer
    where ggz_verwijzer_id = - 1

    union
    
	select  
         verwijzer_agb = zorgverlener_agb
        ,verwijzer_naam = min(naam)
        ,isnull(min(startdatum),'1900-01-01')
        ,isnull(max(einddatum) ,'9999-12-31')
        ,isnull(min(werknemer_nummer),'ONBEKEND')
	from INT_ZORG..verwijzer 
	where isnull(zorgverlener_agb,'99999999')<>'99999999'
	group by zorgverlener_agb
  
 
    if @error <> 0
        return -1

    exec DM_DIM.dbo.merge_dim 
					   @inc_db = 'tempdb'
                          , @inc_tab = 'DM_DIM_d_ggz_verwijzer'
                          , @cum_db = 'DM_DIM'
                          , @cum_tab = 'd_ggz_verwijzer'

   drop table tempdb.dbo.DM_DIM_d_ggz_verwijzer

   print convert(varchar(20), getdate(), 120) + ' eind vul_d_ggz_verwijzer'

end