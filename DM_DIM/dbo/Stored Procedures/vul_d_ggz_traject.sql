 
--select * from d_ggz_traject
 
CREATE   proc [dbo].[vul_d_ggz_traject]
as
/*## 
Historie

Datum       wie    wat
-------------------------------------------------------------------
2022-01-19  Howard  ADD: zorglabel, regiebehandelaar 
2022-01-12  Howard  Creatie
------------------------------------------------------------------- 
select * from DM_DIM..d_ggz_traject
##*/

begin

    print convert(varchar(10), getdate(), 108) + ' begin vul_d_ggz_traject'

    set nocount on

    declare
        @error int


    --select * from INT_ZORG..ggz_traject

    if not exists (select * from d_ggz_traject where ggz_traject_id = -1)
    begin

        --set identity_insert d_ggz_traject on

        insert    into d_ggz_traject (    
            ggz_traject_id
            ,ggz_traject_ok
            ,ggz_dbc_id_oud
            ,patient_id
 
            ,ggz_zorglabel_id
            ,ggz_verwijstype_id
            
            ,startdatum_id
            ,einddatum_id
            ,registratiedatum_id
            ,agb_verwijzer

            ,agb_verwijzer_id
            ,tariefniveau
                ,creatie_datum
                ,mutatie_datum
                ,verwijderd_datum)
        select 
                 -1  
                ,-1 
                ,-1
                ,-1
 
                ,-1 
                ,-1 

                ,-1 
                ,-1 
                ,-1
                ,'Onbekend'

                ,-1
                ,-1

                ,getdate()
                ,getdate()
                ,NULL

        --set identity_insert d_ggz_traject off

    end
    --drop table tempdb.dbo.DM_DIM_d_ggz_traject

    exec    DM_DIM..make_temp_tab    @db = 'DM_DIM'
                                    ,@tab = 'd_ggz_traject'
                                    ,@pk1 = 'ggz_traject_id'
                                    --,@ts = 'ggz_traject_id'

    insert    into tempdb.dbo.DM_DIM_d_ggz_traject (      
       
             ggz_traject_id
            ,ggz_traject_ok
            ,ggz_dbc_id_oud
            ,patient_id
 
            ,ggz_zorglabel_id
            ,ggz_verwijstype_id
            ,startdatum_id
            ,einddatum_id
            ,registratiedatum_id

            ,agb_verwijzer
            ,agb_verwijzer_id
            ,tariefniveau
            )
    select
            ggz_traject_id
            ,ggz_traject_ok
            ,ggz_dbc_id_oud
            ,patient_id
     
            ,ggz_zorglabel_id
            ,ggz_verwijstype_id
            ,startdatum_id
            ,einddatum_id
            ,registratiedatum_id
            ,agb_verwijzer
            ,agb_verwijzer_id
            ,tariefniveau
    from    d_ggz_traject
    where    ggz_traject_id = -1

    UNION
	-- alle
	select	 
      
        ggz_traject_id
        ,t.ggz_traject_ok
        ,isnull(t.ggz_dbc_id_oud,-1) 
        
        ,isnull(p.patient_id,-1)
 
        ,isnull(t.ggz_zorglabel_id,-1) 
        ,isnull(t.ggz_verwijstype_id,-1)    as ggz_verwijstype_id
        ,isnull(dd.datum_id,-1)             as startdatum_id
        ,isnull(de.datum_id,-1)             as einddatum_id
        ,isnull(dr.datum_id,-1)             as registratiedatum_id

        ,isnull(t.agb_verwijzer,'Onbekend')
        ,isnull(t.agb_verwijzer_id,-1)         as agb_verwijzer_id
        
        ,tariefniveau
        --select * 
    from	INT_ZORG..ggz_traject t 
    left join DM_DIM..d_patient p 
        on p.patient_nr = t.patient_nr
        and p.verwijderd_datum is null
    left join DM_DIM..d_datum dd 
        on dd.datum_dat = t.startdatum
    left join DM_DIM..d_datum de
        on de.datum_dat = t.einddatum
    left join DM_DIM..d_datum dr
        on dr.datum_dat = t.registratiedatum
	where	1=1
        --and ggz_traject_id = 1
	


    select  
            @error = @@error

    if @error <> 0
        return -1

    exec DM_DIM..merge_dim    @inc_db = 'tempdb'
                            ,@inc_tab = 'DM_DIM_d_ggz_traject'
                            ,@cum_db = 'DM_DIM'
                            ,@cum_tab = 'd_ggz_traject'
 

    print convert(varchar(10), getdate(), 108) + ' eind vul_d_ggz_traject'

end