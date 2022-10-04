


CREATE                                view [ssas_ggz].[FactOpnameEnDagopnameVersusVerblijfsdagenOudEnNieuw] as

/*## 

Historie

Datum       wie     wat
------------------------------------------------------------------- 
2022-05-20	AL		query omgebouwd op tabellen ipv views
2022-05-19	AL		union toegevoegd
2022-05-13	AL		left foin aangepast in full join
2022-04-06	AL		Peilmaand toegevoegd
2022-03-08  HC		Group by vanwege dubbele regels verblijfsdagen
2021-11-08  HM      Toegevoegd: is_laatste_jn, OPNAME deel eruit
2021-11-02  HM      Combi-view Opname + Opname-Onderdeel
2021-10-27	AL		creatie_datum, mutatie_datum verwijderd
2021-10-27	AL		veldnamen aangepast
2021-07-07  BIA     aangemaakt
------------------------------------------------------------------- 

##*/
--Opnameonderdelen


    select
      a.opname_nr										as OpnameNr
    --, row_number () over 	(partition by a.opname_nr 		order by a.volg_nr_opn )							as OpnameOnderdeelVolgNr
    , a.volg_nr_opn                                     as OpnameOnderdeelVolgNr
    , datum_id_ontslag 									as OpnameOntslagDatumId
    , datum_id_opname									as OpnameDatumId
    , enkel_dv_jn										as OpnameEnkelDvJn
    , klinische_opname_jn								as OpnameKlinischeOpnameJn
    , h.patient_id										as OpnamePatientId
    , spoed_ind											as OpnameSpoedInd
    , tijd_id_ontslag									as OpnameOntslagTijdId
    , tijd_id_opname									as OpnameTijdId
    , event_id											as OpnameOnderdeelEventId
    , datum_id_start									as OpnameOnderdeelStartDatumId
    , tijd_id_start										as OpnameOnderdeelStartTijdId
    , datum_id_eind										as OpnameOnderdeelEindDatumId
    , tijd_id_eind										as OpnameOnderdeelEindTijdId
    , a.specialisme_id_intern							as OpnameOnderdeelInternSpecialismeId
    , department_id										as OpnameOnderdeelDepartmentId
    , soort_zorg_id										as OpnameOnderdeelPatientKlasseId
    , kamer_id											as OpnameOnderdeelKamerId
    , start_reden										as OpnameOnderdeelStartReden
    , eind_reden										as OpnameOnderdeelEindReden
    , avg(duur)											as OpnameOnderdeelDuur
    , avg(ligduur)									    as OpnameOnderdeelLigduur
    , avg(verlofduur)							        as OpnameOnderdeelVerlofduur
    , adt_event_type_id									as OpnameOnderdeelAdtEventTypeId
    , 0													as GgzActiviteitDuurInDagen
	, -1												as GgzZorgprestatieId
	, k.peilmaand_id									as GgzActiviteitPeilmaandId
	
  	
    
    from [$(DM_ZORG)].dbo.f_opname_onderdeel a
	inner join [$(DM_ZORG)].dbo.f_opname h
	on a.opname_nr = h.opname_nr
    
   left join( 
            select 
                b.*
            from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie b 
            left outer join [$(DM_DIM)].dbo.d_ggz_zorgprestatie c
                on b.ggz_zorgprestatie_dim_id=c.ggz_zorgprestatie_id
            where 1=1
                and c.zorgprestatiegroep_code = 'VD'
        ) k
        on	h.patient_id = k.patient_id

        and convert(date ,convert(char(8),k.datum_id)) >= 
            CASE
                WHEN tijd_id_start >= 2000 THEN dateadd(day,1,convert(date,convert(char(8),a.datum_id_start))) 
                WHEN tijd_id_start <  2000 THEN  convert(date,convert(char(8),a.datum_id_start)) 
            END

        and DATEADD(day,k.duur_dagen,convert(date,convert(char(8), CASE WHEN k.datum_id = 99991231 THEN cast(convert(char(8), getdate()-1, 112) as int)  ELSE datum_id END ))) --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN tijd_id_eind >= 2000 and a.datum_id_eind<>-1 THEN DATEADD(day,1,convert(date,convert(char(8),a.datum_id_eind)))
                WHEN tijd_id_eind <  2000 and a.datum_id_eind<>-1 THEN dateadd(day,0,convert(date,convert(char(8),a.datum_id_eind)))
           		WHEN a.datum_id_eind= -1                                      THEN cast(getdate() as date)
            END
    
    left join pub.DimPeilmaand e
        on k.peilmaand_id=e.PeilmaandId
       
    where (a.datum_id_eind >= 20220101 or a.datum_id_eind=-1)
        and a.specialisme_id_intern=44
		and (e.IsLaatstGeladenMaandJn = 'J'  OR e.IsLaatstGeladenMaandJn IS NULL)
       
    group by
          a.opname_nr
        , a.volg_nr_opn --, row_number () over 	(partition by a.opname_nr 		order by volg_nr_opn )	
        , bevat_verlof_jn
        , datum_id_ontslag
        , datum_id_opname
        , enkel_dv_jn
        , klinische_opname_jn
        , h.patient_id
        , spoed_ind
        , tijd_id_ontslag
        , tijd_id_opname
        , event_id
        , datum_id_start
        , tijd_id_start
        , datum_id_eind
        , tijd_id_eind
        , specialisme_id_intern
        , department_id
        , soort_zorg_id
        , kamer_id
        , start_reden
        , eind_reden
        , adt_event_type_id
		, peilmaand_id
		, ggz_zorgprestatie_id
		
		
union    
--Verblijfsdagen
    select
      iif (a.opname_nr is null,-1,opname_nr)														as OpnameNr
    --, iif (row_number () over 	(partition by a.opname_nr 	order by volg_nr_opn ) is null,-1,
		   --row_number () over 	(partition by a.opname_nr   order by volg_nr_opn ))				as OpnameOnderdeelVolgNr

    , ISNULL(a.volg_nr_opn,-1)                                                                  as OpnameOnderdeelVolgNr
    , iif (a.datum_id_ontslag is null,-1,datum_id_ontslag)										as OpnameOntslagDatumId
    , iif (a.datum_id_opname is null,-1,datum_id_opname)											as OpnameDatumId
    , iif (a.enkel_dv_jn is null, 'O',enkel_dv_jn)												as OpnameEnkelDvJn
    , iif (a.klinische_opname_jn is null, 'J',klinische_opname_jn)								as OpnameKlinischeOpnameJn
    , k.patient_id																				as OpnamePatientId
    , iif (a.spoed_ind is null, 'Onbekend',spoed_ind)												as OpnameSpoedInd
    , iif (a.tijd_id_ontslag is null, -1,tijd_id_ontslag)											as OpnameOntslagTijdId
    , iif (a.tijd_id_opname is null,-1,tijd_id_opname)											as OpnameTijdId
    , iif (a.event_id is null, -1, event_id)														as OpnameOnderdeelEventId
    , iif (a.datum_id_start is null,-1, datum_id_start)											as OpnameOnderdeelStartDatumId
    , iif (a.tijd_id_start is null, -1, tijd_id_start)											as OpnameOnderdeelStartTijdId
    , iif (a.datum_id_eind is null,-1, datum_id_eind)												as OpnameOnderdeelEindDatumId
    , iif (a.tijd_id_eind is null,-1,tijd_id_eind)												as OpnameOnderdeelEindTijdId
    , iif (a.specialisme_id_intern is null,-1, specialisme_id_intern)								as OpnameOnderdeelInternSpecialismeId
    , iif (a.department_id is null, -1, department_id)											as OpnameOnderdeelDepartmentId
    , iif (a.soort_zorg_id is null,-1,soort_zorg_id)												as OpnameOnderdeelPatientKlasseId
    , iif (a.kamer_id is null,-1, kamer_id)														as OpnameOnderdeelKamerId
    , iif (a.start_reden is null, 'Onb', start_reden)												as OpnameOnderdeelStartReden
    , iif (a.eind_reden is null, 'Onb', eind_reden)												as OpnameOnderdeelEindReden
    , 0																							as OpnameOnderdeelDuur
    , 0																							as OpnameOnderdeelLigduur
    , 0																							as OpnameOnderdeelVerlofduur
    , iif (a.adt_event_type_id is null,-1, adt_event_type_id)										as OpnameOnderdeelAdtEventTypeId	
    , sum(duur_dagen)																			as GgzActiviteitDuurInDagen
	, c.ggz_zorgprestatie_id																	as GgzZorgprestatieId
	, k.peilmaand_id																			as GgzActiviteitPeilmaandId
	
  	
    
    from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie k
	 left join [$(DM_DIM)].dbo.d_ggz_zorgprestatie c
		 on k.ggz_zorgprestatie_dim_id=c.ggz_zorgprestatie_id 

	left join(select 
                 a.event_id
                ,a.[opname_nr]
                ,a.[volg_nr_opn]
                ,a.[datumtijd_start]
                ,a.[datum_id_start]
                ,a.[tijd_id_start]
                ,a.[datumtijd_eind]
                ,a.[datum_id_eind]
                ,a.[tijd_id_eind]
                ,a.[specialisme_id_intern]
                ,a.[kpl_id_specialisme]
                ,a.[department_id]
                ,a.[kpl_id_department]
                ,a.[soort_zorg_id]
                ,a.[kamer_id]
                ,a.[department_id_voorgaand]
                ,a.[specialisme_id_intern_voorgaand]
                ,a.[start_reden]
                ,a.[eind_reden]
                ,a.[duur]
                ,a.[ligduur]
                ,a.[verlofduur]
                ,a.[aantal_opnames_initieel]
                ,a.[aantal_opnames_specialisme]
                ,a.[aantal_opnames_afdeling]
                ,a.[adt_event_type_id]
                ,a.[aantal_opnames_initieel_totaal]
                ,a.[aantal_opnames_initieel_klinisch]
                ,a.[aantal_opnames_specialisme_klinisch]
                ,a.[aantal_opnames_afdeling_klinisch]
                ,a.[is_laatste_jn]
                ,h.[aantal]
                ,h.[afspraak_24_uur_voor_opname_id]
                ,h.[afspraak_24_uur_voor_opname_jn]
                ,h.[afspraak_type_id]
                ,h.[bestemming_id]
                ,h.[bevat_operatie_jn]
                ,h.[bevat_verlof_jn]
                ,h.[datum_id_ontslag]
                ,h.[datum_id_opname]
                ,h.[datum_id_tweede_onderdeel]
                ,h.[dbc_diagnose_id]
                ,h.[department_id_eerste_onderdeel]
                ,h.[department_id_laatste_onderdeel]
                ,h.[department_id_tweede_onderdeel]
                ,h.[dreigende_vroeggeboorte_jn]
                ,h.[foetale_bewaking_jn]
                ,h.[enkel_dv_jn]
                ,h.[eindbestemming_id]
                ,h.[geen_belafspraak_nodig_jn]
                ,h.[herkomst_id]
                ,h.[heropname_in_dagen]
                ,h.[instelling_id]
                ,h.[klinische_opname_jn]
                ,h.[klinische_opname_na_seh_jn]
                ,h.[lbz_codeer_status_id]
                ,h.[lbz_contact_type_id]
                ,h.[lbz_diagnose_jn]
                ,h.[leeftijd_id]
                ,h.[needle_time_dt]
                ,h.[opname_24_uur_voor_opname_id]
                ,h.[opname_24_uur_voor_opname_jn]
                ,h.[opname_nr_alt]
                ,h.[opname_nr_voorgaand]
                ,h.[opname_type_id]
                ,h.[opnemend_arts_id]
                ,h.[overleden_30_dgn_na_ontslag_jn]
                ,h.[overleden_30_dgn_na_ontslag_teller]
                ,h.[overleden_45_dgn_na_opname_jn]
                ,h.[overleden_45_dgn_na_opname_teller]
                ,h.[overleden_90_dgn_na_ontslag_jn]
                ,h.[overleden_90_dgn_na_ontslag_teller]
                ,h.[patient_id]
                ,h.[patient_klasse_id]
                ,h.[soort_zorg_id_eerste_onderdeel]
                ,h.[specialisme_id_eerste_onderdeel]
                ,h.[specialisme_id_laatste_onderdeel]
                ,h.[specialisme_id_tweede_onderdeel]
                ,h.[spoed_ind]
                ,h.[tijd_id_ontslag]
                ,h.[tijd_id_opname]
                ,h.[tijd_id_tweede_onderdeel]
                ,h.[urgentie_id]
                ,h.[vpl_dagen_jn]
                ,h.[ic_dagen_jn]
                ,h.[vpl_ic_dagen_jn]
				from [$(DM_ZORG)].dbo.f_opname_onderdeel a
				inner join [$(DM_ZORG)].dbo.f_opname h
				on a.opname_nr = h.opname_nr
		) a
     on	a.patient_id = k.patient_id

         and convert(date ,convert(char(8),k.datum_id)) >= 
            CASE
                WHEN tijd_id_start >= 2000 THEN dateadd(day,1,convert(date,convert(char(8),a.datum_id_start))) 
                WHEN tijd_id_start <  2000 THEN  convert(date,convert(char(8),a.datum_id_start)) 
            END

        and DATEADD(day,k.duur_dagen,convert(date,convert(char(8), CASE WHEN k.datum_id = 99991231 THEN cast(convert(char(8), getdate()-1, 112) as int)  ELSE datum_id END ))) --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN tijd_id_eind >= 2000 and a.datum_id_eind<>-1 THEN DATEADD(day,1,convert(date,convert(char(8),a.datum_id_eind)))
                WHEN tijd_id_eind <  2000 and a.datum_id_eind<>-1 THEN dateadd(day,0,convert(date,convert(char(8),a.datum_id_eind)))
           		WHEN a.datum_id_eind= -1                                      THEN cast(getdate() as date)
            END
    
		left join pub.DimPeilmaand e
	    on k.peilmaand_id=e.PeilmaandId
        

    /*,1
        and DATEADD(day,b.GgzActiviteitDuurInDagen,convert(date,convert(char(8), CASE WHEN b.GgzActiviteitUitvoerdatumId = 99991231 THEN cast(getdate()-1  as date)  ELSE   convert(date,convert(char(8),GgzActiviteitUitvoerdatumId)) END)))  --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN OpnameOnderdeelEindTijdId >= 2000 and a.OpnameOnderdeelEindDatumId <>-1 THEN a.OpnameOnderdeelEindDatumId
                WHEN OpnameOnderdeelEindTijdId <  2000 and a.OpnameOnderdeelEindDatumId <>-1 THEN cast(convert(char(8), dateadd(day,-1,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId))) , 112) as int) 
           		WHEN a.OpnameOnderdeelEindDatumId =-1 Then  cast(convert(char(8), getdate()-1, 112) as int) 
                                                               
            END*/

   where (e.IsLaatstGeladenMaandJn = 'J'  OR e.IsLaatstGeladenMaandJn IS NULL)
		 and c.zorgprestatiegroep_code = 'VD'
       
    group by
         a.opname_nr
        , volg_nr_opn
        , bevat_verlof_jn
        , datum_id_ontslag
        , datum_id_opname
        , enkel_dv_jn
        , klinische_opname_jn
        , k.patient_id
        , spoed_ind
        , tijd_id_ontslag
        , tijd_id_opname 
        , event_id
        , datum_id_start
        , tijd_id_start
        , datum_id_eind
        , tijd_id_eind
        , specialisme_id_intern
        , department_id
        , soort_zorg_id
        , kamer_id
        , start_reden
        , eind_reden
        , adt_event_type_id
		, peilmaand_id
		, c.ggz_zorgprestatie_id
