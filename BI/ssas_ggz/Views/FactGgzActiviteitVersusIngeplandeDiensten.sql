




CREATE                              View [ssas_ggz].[FactGgzActiviteitVersusIngeplandeDiensten] as


/*############################################################
Historie

Datum		Wie		    wat
----------------------------------------------------------------------------------------------------------------------------
2022-06-20  Howard      RegiebehandelaarId eruit -> GGzBehandelaar_id. Voor GGZ:Op basis van zorgverlener van consult ipv trajectverantwoordelijke
2022-06-01  Howard      #task 1728 
                        roostergroep nodig (dus ook in de tweede helft van de query bedoel ik) kunnen we die nog ophalen uit de OWS gegevens? 
                        En de beroeps_categorie uit de zorgprestatie zowel in het stukje uit OWS als in het stuk uit ZorgGGZ. toegevoegd aan fact
2022-05-17  Howard      Nieuwe opzet
2022-05-09	AL		    aangemaakt

----------------------------------------------------------------------------------------------------------------------------

definieer sleutels in CTE/OWS met WITH: dienstroosters en ggz:
 		on ggz.werknemer_nummer=LEFT(d.functieplaats_nummer,7)
        and ggz.datum_id = a.periodedag_id

############################################*/

WITH OWS AS(

        select 
             a.*
            ,CASE WHEN LEFT(d.functieplaats_nummer,7) <> '' THEN LEFT(d.functieplaats_nummer,7) 
                ELSE 'Onbekend' --of Z000000
            END as werknemer_nummer
            ,r.ggz_regiebehandelaar_id
            ,bc.ggz_beroepscategorie_id
            
        from [$(DM_OWS2020)].dbo.f_ingeplande_diensten a
        left join [$(DM_OWS2020)].dbo.d_medewerker_ows d
            on a.medewerker_ows_id = d.medewerker_ows_id
        /*
        left join [$(DM_OWS2020)].dbo.d_datum b
        on a.periodedag_id=b.datum_id
        */
        left join [$(DM_DIM)].dbo.d_kostenplaats c
            on a.kostenplaats_id = c.kostenplaats_id
        
        left join [$(DM_DIM)]..d_ggz_regiebehandelaar r 
            on r.ggz_regiebehandelaar_code = LEFT(d.functieplaats_nummer,7)
            and a.periodedag_id between r.startdatum_id and r.einddatum_id

        left join [$(DM_DIM)]..d_ggz_beroepscategorie bc 
            on bc.ggz_beroepscategorie_code = r.beroepscategorie_code

        where 1=1
            and left(a.periodedag_id,4) > 2021
            and c.afdeling_oms= 'Psychiatrie'
            --and a.medewerker_ows_id <> -1 --roosters van onbekende medewerkers psychiatrie mee of niet?
),

GGZ AS(
        select 
            e.*
            ,CASE WHEN e.werknemer_id = -1 THEN 'Onbekend' 
                else zv.ZorgverlenerNr
                END as werknemer_nummer --select top(100) *
            ,bc.ggz_beroepscategorie_id
            ,rb.ggz_regiebehandelaar_id as GgzBehandelaarId
            --select *
		from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie e
        left join ssas_pgs.DimZorgverlener zv 
            on zv.ZorgverlenerId = e.zorgverlener_id
	
        LEFT JOIN [$(DM_DIM)]..d_ggz_regiebehandelaar rb 
            on zv.ZorgverlenerNr = upper(rb.ggz_regiebehandelaar_code)
            and e.datum_id BETWEEN rb.startdatum_id and rb.einddatum_id
		
        left join [$(DM_DIM)]..d_ggz_beroepscategorie bc 
            on bc.ggz_beroepscategorie_code = rb.beroepscategorie_code
		    --select [$(DM_DIM)] from  [$(DM_DIM)]..d_ggz_beroepscategorie bc
        left join [$(DM_DIM)].dbo.d_ggz_zorgprestatie h
		    on e.ggz_zorgprestatie_dim_id = h.ggz_zorgprestatie_id
		left join pub.DimPeilmaand g
			on e.peilmaand_id = g.PeilmaandId
		
            

        where 1=1
            and h.zorgprestatiegroep_code in ('CO','GC')
            and IsLaatstGeladenMaandJn='J'
             --and e.werknemer_id <> -1 --ggz onbekende werknemers wel mee!
            --and f.werknemer_id <> -1
)

/* niet nodig
,PK AS (

    select 
          werknemer_nummer
        , periodedag_id as datum_id
	from OWS
	
    where 1=1
    group by 
         werknemer_nummer
        ,periodedag_id
 
 UNION
        
    SELECT
         werknemer_nummer
        ,datum_id
    FROM GGZ
    group by 
         werknemer_nummer
        ,datum_id
)
 */
  
,PEILMAAND AS(
    select periodemaand_id
    FROM [$(UMRAP4)].[dbo].[dwh_laad_datum]
    where status = 'OPEN'
)

select
      p.periodemaand_id                 			as GgzActiviteitPeilmaandId
    , a.periodedag_id                               as GgzActiviteitUitvoerdatumId --DatumId --GgzActiviteitUitvoerdatumId
    , a.werknemer_nummer                            as GgzActiviteitWerknemerId-- MedewerkerNummer  --GgzActiviteitWerknemerId
    

	, -1                                            as GgzActiviteitId
	, -1                                            as GgzActiviteitZorgprestatieDimId
	, -1                                            as GgzActiviteitZorgverlenerId
    , ISNULL(a.ggz_beroepscategorie_id,-1 )         as GgzActiviteitBeroepsCategorieId
    , ISNULL(a.ggz_regiebehandelaar_id,-1)          as GgzActiviteitBehandelaarId
    , 0                                             as GgzActiviteitDuurInMinuten
	, 0                                             as GgzActiviteitDirecteTijdGroepsconsulten
	, 0                                             as GgzActiviteitAantal
	, 0                                             as GgzActiviteitOmzetMaxTarief
	, 0                                             as GgzActiviteitMaxTarief
	, 0                                             as GgzActiviteitNormtijdIndirect
	, 0                                             as GgzActiviteitDirecteTijdDoorberekend

    , ISNULL(a.roostergroep_id,-1)                  as MedewerkerRoosterGroepId
	, ISNULL(a.dienst_naam,'')						as MederwerkerDienstNaam
    , SUM(ISNULL(a.uren_werk,0))                    as MedewerkerUrenWerk
	, SUM(ISNULL(a.dienst_duur,0))                  as MedewerkerDienstDuur
	, SUM(ISNULL(a.uren_pauze,0))                   as MedewerkerUrenPauze
 
	from OWS a
        
    cross apply PEILMAAND p
    where 1=1
    
        --and a.werknemer_nummer IS NOT NULL         and ggz.werknemer_nummer IS NOT NULL
    group by 
          p.periodemaand_id  
        , a.periodedag_id
        , a.werknemer_nummer
        , ISNULL(a.roostergroep_id,-1)
		, ISNULL(a.dienst_naam,'')
        , ISNULL(a.ggz_regiebehandelaar_id,-1) 
        , ISNULL(a.ggz_beroepscategorie_id,-1)

UNION 

 select
      p.periodemaand_id                 			    as GgzActiviteitPeilmaandId
    , ggz.datum_id                                        as GgzActiviteitUitvoerdatumId --DatumId --GgzActiviteitUitvoerdatumId
    , ggz.werknemer_nummer                                as GgzActiviteitWerknemerId-- MedewerkerNummer  --GgzActiviteitWerknemerId

	, ISNULL(ggz.ggz_zorgprestatie_id,-1)	            as GgzActiviteitId
	, ISNULL(ggz.ggz_zorgprestatie_dim_id,-1)           as GgzActiviteitZorgprestatieDimId
	, ISNULL(ggz.zorgverlener_id,-1)		            as GgzActiviteitZorgverlenerId
    , ISNULL(ggz.ggz_beroepscategorie_id,-1)             as  GgzActtiviteitBeroepsCategorieId
    , ISNULL(ggz.GgzBehandelaarId,-1)                    as GgzActiviteitBehandelaar
    , SUM(ISNULL(ggz.[duur_minuten],0))                  as GgzActiviteitDuurInMinuten
	, SUM(ISNULL(ggz.[directe_tijd_groepsconsulten],0))  as GgzActiviteitDirecteTijdGroepsconsulten
	, SUM(ISNULL(ggz.[aantal],0))                        as GgzActiviteitAantal
	, SUM(ISNULL(ggz.[omzetmaxtarief],0))               as GgzActiviteitOmzetMaxTarief
	, SUM(ISNULL(ggz.[maxtarief],0))                     as GgzActiviteitMaxTarief
	, SUM(ISNULL(ggz.[normtijd_indirect],0))             as GgzActiviteitNormtijdIndirect
	, SUM(ISNULL(ggz.[doorberekende_directe_tijd],0))    as GgzActiviteitDirecteTijdDoorberekend

    , ISNULL(o.roostergroep_id,-1)	                    as MedewerkerRoosterGroepId --Howard kun je hier nog het RoostergroepId toevoegen vanuit het eerste gedeelte op basis van het werknemer id en datum
    , ISNULL(o.dienst_naam,'')							as MederwerkerDienstNaam
    , 0                                                 as MedewerkerUrenWerk
	, 0                                                 as MedewerkerDienstDuur
	, 0                                                 as MedewerkerUrenPauze
   
    from GGZ ggz
    cross apply PEILMAAND p
    left join (
        select werknemer_nummer, periodedag_id, roostergroep_id, dienst_naam 
        from OWS 
        group by werknemer_nummer, periodedag_id, roostergroep_id, dienst_naam, ggz_beroepscategorie_id
        having count(distinct roostergroep_id) = 1
     ) o
           on o.werknemer_nummer = ggz.werknemer_nummer
            and ggz.datum_id = o.periodedag_id
            
         
    where 1=1
        --and a.werknemer_nummer IS NOT NULL         and ggz.werknemer_nummer IS NOT NULL
    
	group by 
          p.periodemaand_id                 			
        , ggz.datum_id                                   
        , ggz.werknemer_nummer                           
        , ISNULL(ggz.ggz_zorgprestatie_id,-1)	       
        , ISNULL(ggz.ggz_zorgprestatie_dim_id,-1)      
        , ISNULL(ggz.zorgverlener_id,-1)		       
        , ISNULL(o.roostergroep_id,-1)
		, ISNULL(o.dienst_naam,'')
        , ISNULL(ggz.GgzBehandelaarId,-1)
        , ISNULL(ggz.ggz_beroepscategorie_id,-1)
