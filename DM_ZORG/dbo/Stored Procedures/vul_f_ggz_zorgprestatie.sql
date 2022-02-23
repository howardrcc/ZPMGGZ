 



CREATE    proc [dbo].[vul_f_ggz_zorgprestatie]
as
/*## 
Historie
Datum       wie		wat
-------------------------------------------------------------------
2022-02-07  Howard      Opname_nr en afspraak_nr epic toegevoegd
2022_02-07  Howard      Doorberekende directe tijd toegevoegd
2022-01-31  Howard      Normtijden toegevoegd vanuit EIFFEL/EXTERN
2022-01-19  Howard      Aanvullingen Anne-Marie
2022-01-12	Howard		Creatie


--doorberekende directe tijd?
  --voor de consulten: DM_ZORG.dbo.f_ggz_zorgprestatie.[aantal]*DM_DIM.dbo.d_ggz_zorgprestatie.[duur_verrichting_minuten_vanaf] (voor de desbetreffende zorgprestatiecode)
--voor de groepsconsulten: (DM_ZORG.dbo.f_ggz_zorgprestatie.[aantal]*DM_DIM.dbo.d_ggz_zorgprestatie.[duur_verrichting_minuten_vanaf])/ DM_DIM.dbo.d_ggz_zorgprestatie.[groeps_grootte](voor de desbetreffende zorgprestatiecode)

select top(100) * from DM_ZORG..f_ggz_zorgprestatie
------------------------------------------------------------------- 
##*/
begin

    print convert(varchar(10), getdate(), 108) + ' begin vul_f_ggz_zorgprestatie'

    set nocount on

    declare
        @error int
--drop table tempdb.dbo.DM_ZORG_f_ggz_zorgprestatie
    exec DM_ZORG..make_temp_tab	@db = 'DM_ZORG'
                                ,@tab = 'f_ggz_zorgprestatie'
                                ,@pk1 = 'ggz_zorgprestatie_id'

--SELECT * FROM DM_DIM..d_ggz_traject
--select * from DM_ZORG..f_ggz_zorgprestatie
 
    insert into tempdb.dbo.DM_ZORG_f_ggz_zorgprestatie (        
        [ggz_zorgprestatie_id]
      ,[ggz_traject_id]
      ,[patient_id]
      ,[ggz_zorgprestatie_dim_id]
      ,verzekeraar_id
      ,[zorgverlener_id]
      --,[uitvoer_datumtijd]
      ,[datum_id]
      ,[tijd_id]
      ,[duur_minuten]
      ,[duur_dagen]
      ,[aantal]
      ,omzet
      ,[ggz_opname_id]
      ,opname_id_epic 
      ,afspraak_id_epic
      ,tarief
      ,normtijd_indirect
      ,doorberekende_directe_tijd
      ,directe_tijd_groepsconsulten
    )
    select  
         a.ggz_zorgprestatie_id                                     as ggz_zorgprestatie_id
        ,isnull(t.ggz_traject_id,-1)                                as ggz_traject_id
        ,isnull(t.patient_id,-1)                                    as patient_id
        ,isnull(z.ggz_zorgprestatie_id,-1)                          as zorgprestatie_id
        ,isnull(v.verzekeraar_id,-1)                                as verzekeraar_id
        ,isnull(zv.zorgverlener_id,-1)                              as zorgverlener_id
        --,a.uitvoer_datumtijd
        ,dd.datum_id        
        ,dt.tijd_id 
        ,a.duur_minuten
        ,a.duur_dagen
        ,CASE WHEN z.zorgprestatiegroep_code = 'CO' THEN 1
            ELSE a.aantal
            END as aantal
        ,CASE WHEN z.zorgprestatiegroep_code = 'CO' THEN 1 * z.tarief + a.duur_dagen*z.tarief
            ELSE a.aantal * z.tarief + a.duur_dagen*z.tarief
            END as omzet
            --tijdseenheid bij GC zit er nog niet in. checken of het bij andere typen consulten wel allemaal in zit.
        ,a.ggz_opname_id 
        ,a.opname_nr
        ,a.afspraak_nr
        ,z.tarief                                                   as tarief
        ,ISNULL(cast(ROUND((a.duur_minuten/(nt.[Percentage direct]*100))*(nt.[Percentage indirect]*100),3) as numeric(6,3)),0) as tijd_indirect
        ,CASE   WHEN z.zorgprestatiegroep_code = 'CO' THEN 1 * cast(z.duur_verrichting_minuten_vanaf as numeric(6,3))
                WHEN z.zorgprestatiegroep_code = 'GC' AND a.aantal <> 0 THEN cast(round(a.aantal * cast(z.duur_verrichting_minuten_vanaf as decimal(6,3)) / z.groeps_grootte ,3) as numeric(7,3))
            ELSE 0
            END as doorberekende_directe_tijd
        
        --deze gaat niet goed wanneer er voor een 'dubbel consult' 2 regels wordt aangemaakt. de realistatie van de afspraak corrigeren met hoeveel consulten op dit tijdstip?
        ,CASE  WHEN z.zorgprestatiegroep_code = 'GC' AND a.aantal <> 0 AND dd.jaarmaand <> 202201 THEN  ISNULL(cast(round(a.aantal * cast(a.duur_minuten_afspraak as decimal(6,3)) / z.groeps_grootte ,3) as numeric(7,3)),0)
               WHEN z.zorgprestatiegroep_code = 'GC' AND a.aantal <> 0 AND dd.jaarmaand = 202201 THEN  ISNULL(cast(round(a.aantal * cast(z.duur_verrichting_minuten_vanaf as decimal(6,3)) / z.groeps_grootte ,3) as numeric(7,3)),0)
            
                ELSE 0
            END as directe_tijd_groepsconsulten
        --,a.duur_minuten_afspraak
        --,z.groeps_grootte
        --,z.duur_verrichting_minuten_vanaf
       --,isnull(a.aantal_uren,0)                                  as dagbesteding_uren
       --,isnull(a.aantal_dagen,0)                                 as verblijf_dagen
       --,isnull(a.aantal_dagen,0)*isnull(a.act_tarief,0)        as verblijf_bedrag      --(verzekeraarafhankelijk vanaf 2014-01-01)
       --,isnull(a.aantal_verrichtingen,0)                         as verrichting_aantal
       --,isnull(a.aantal_verrichtingen,0)*isnull(a.act_tarief,0)as verrichting_bedrag   --(verzekeraarafhankelijk vanaf 2014-01-01)
       --,1                                                          as act_aantal           --(aantal act records tbv telling)
       --,isnull(a.act_declaratiecode,'')                          as act_declaratiecode   --declaratiecode..
       --,isnull(a.act_tarief,0)                                   as act_tarief           --..en (verzekeraarafhankelijk)tarief is bepaald in INT_ZORG
                            
        --into f_ggz_zorgprestatie
    --select top (10)* 
    from INT_ZORG..ggz_zorgprestatie           a  
    left join DM_DIM..d_ggz_traject t
        on t.ggz_traject_id = a.ggz_traject_id
    left join DM_DIM..d_patient p 
        on p.patient_id = t.patient_id
    left join DM_DIM..d_ggz_zorgprestatie z 
        on z.ggz_zorgprestatie_ok = a.ggz_zorgprestatie_dim_id
    left join DM_DIM..d_verzekeraar v 
        on v.verz_code = cast(a.verzekeraar_id as varchar)
        and a.uitvoer_datumtijd between v.startdatum and v.einddatum
        and v.verwijderd_datum is null
    left join DM_DIM..d_tijd dt 
        on dt.tijd = left(replace(cast(convert(time(0),a.uitvoer_datumtijd) as varchar),':',''),4) 
    left join DM_DIM..d_datum dd
        on dd.datum_dat = convert(date,a.uitvoer_datumtijd)
    left join DM_DIM..d_zorgverlener zv          
        on zv.zorgverlener_code = cast(a.uitvoerder_zorgverlener_id as varchar)
        and zv.zorgverlener_id <> -1
    left join EXTERN..ggz_normtijden nt 
        on nt.Prestatie_code = z.zorgprestatie_code
        and z.zorgprestatie_code IS NOT NULL
    where 1=1
        and a.verwijderd_datum IS NULL
        --and z.zorgprestatiegroep_code = 'GC'
        --and duur_minuten_afspraak IS NOT NULL
        --and zv.zorgverlener_id IS NULL
  

    update a 
        set a.directe_tijd_groepsconsulten = a.directe_tijd_groepsconsulten / b.aantal_zv
    from tempdb.dbo.DM_ZORG_f_ggz_zorgprestatie a 
    join (
        select 
            patient_id
            ,datum_id
            ,tijd_id
            ,afspraak_id_epic
            ,count(distinct zorgverlener_id) as aantal_zv
        from f_ggz_zorgprestatie
        group by 
            patient_id
            ,datum_id
            ,tijd_id
            ,afspraak_id_epic
        having count(distinct zorgverlener_id) > 1
    ) b 
        on a.patient_id = b.patient_id
        and a.datum_id = b.datum_id
        and a.tijd_id = b.tijd_id
        and a.afspraak_id_epic = b.afspraak_id_epic
    where 1=1
        and a.datum_id >= 20220201
/*
 --update voor dubbele groepsconsulten op zelfde tijdstip:

    update a
        set a.directe_tijd_groepsconsulten = a.directe_tijd_groepsconsulten/x.aantal_dups
    --select         *, a.directe_tijd_groepsconsulten/x.aantal_dups, a.directe_tijd_groepsconsulten
        
    from f_ggz_zorgprestatie a 
    join (
        select 
            patient_id
            ,datum_id
            ,tijd_id
            ,count(*) as aantal_dups
        from f_ggz_zorgprestatie a 
        join DM_DIM..d_ggz_zorgprestatie z 
                on z.ggz_zorgprestatie_id = a.ggz_zorgprestatie_dim_id
        
        where 1=1
            and z.zorgprestatiegroep_code = 'GC'
            and directe_tijd_groepsconsulten  IS NOT NULL
        group by 
            patient_id
            ,datum_id
            ,tijd_id
        having count(*) >1
    ) x 
        on x.patient_id =a.patient_id
        and x.datum_id = a.datum_id
        and x.tijd_id = a.tijd_id
    join DM_DIM..d_ggz_zorgprestatie z 
                on z.ggz_zorgprestatie_id = a.ggz_zorgprestatie_dim_id
    where 1=1
          and z.zorgprestatiegroep_code = 'GC'
          and directe_tijd_groepsconsulten  IS NOT NULL



*/
 --select top(10) * from DM_DIM..d_zorgverlener where zorgverlener_code = 'E00117'
 --select top(10) * from INT_ZORG..zorgverlener
/*
select a.uitvoerder_zorgverlener_id, a.uitvoer_datumtijd, a.ggz_traject_id, count(*) as duplicates
--select * 
from INT_ZORG..ggz_zorgprestatie a
join INT_ZORG..ggz_zorgprestatie_dim b --duur verrichting minuten tot berekenen, evenals gemiddeld
    on a.ggz_zorgprestatie_dim_id = b.ggz_zorgprestatie_dim_id
    and left(zorgprestatie_code,2) = 'GC'
where 1=1
    and a.verwijderd_datum is null
group by a.uitvoerder_zorgverlener_id, a.uitvoer_datumtijd, a.ggz_traject_id
*/

    select  
        @error = @@error

    if @error <> 0
        return -1

    exec DM_ZORG..merge_fact    @inc_db = 'tempdb'
                                ,@inc_tab = 'DM_ZORG_f_ggz_zorgprestatie'
                                ,@cum_db = 'DM_ZORG'
                                ,@cum_tab = 'f_ggz_zorgprestatie'



 

    drop table tempdb.dbo.DM_ZORG_f_ggz_zorgprestatie

    print convert(varchar(10), getdate(), 108) + ' eind vul_f_ggz_zorgprestatie'




end