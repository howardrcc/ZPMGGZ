










CREATE                              view [ssas_ggz].[FactOpnameEnDagopnameVersusVerblijfsdagen] as

/*## 

Historie

Datum       wie     wat
------------------------------------------------------------------- 
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
      OpnameNr
    , OpnameOnderdeelVolgNr
    , OpnameOntslagDatumId
    , OpnameDatumId
    , OpnameEnkelDvJn
    , OpnameKlinischeOpnameJn
    , OpnamePatientId
    , OpnameSpoedInd
    , OpnameOntslagTijdId
    , OpnameTijdId
    , OpnameOnderdeelEventId
    , OpnameOnderdeelStartDatumId
    , OpnameOnderdeelStartTijdId
    , OpnameOnderdeelEindDatumId
    , OpnameOnderdeelEindTijdId
    , OpnameOnderdeelInternSpecialismeId
    , OpnameOnderdeelDepartmentId
    , OpnameOnderdeelPatientKlasseId
    , OpnameOnderdeelKamerId
    , OpnameOnderdeelStartReden
    , OpnameOnderdeelEindReden
    , avg(OpnameOnderdeelDuur)                          as OpnameOnderdeelDuur
    , avg(OpnameOnderdeelLigduur)                       as OpnameOnderdeelLigduur
    , avg(OpnameOnderdeelVerlofduur)                    as OpnameOnderdeelVerlofduur
    , OpnameOnderdeelAdtEventTypeId
    , 0													as GgzActiviteitDuurInDagen
	, -1												as GgzZorgprestatieId
	, b.GgzActiviteitPeilmaandId
	
  	
    
    from [ssas_pgs].[FactOpnameEnDagopname] a
    
   left join( 
            select 
                *
            from ssas_ggz.FactGgzActiviteit b 
            left outer join [ssas_ggz].DimGgzZorgprestatie c
                on b.GgzActiviteitZorgprestatieDimId=c.GgzZorgprestatieId
            where 1=1
                and c.GgzZorgprestatieGroepCode = 'VD'
        ) b
        on	a.OpnamePatientId = b.GgzActiviteitPatientId

        and convert(date ,convert(char(8),b.GgzActiviteitUitvoerdatumId)) >= 
            CASE
                WHEN OpnameOnderdeelStartTijdId >= 2000 THEN dateadd(day,1,convert(date,convert(char(8),a.OpnameOnderdeelStartDatumId))) 
                WHEN OpnameOnderdeelStartTijdId <  2000 THEN  convert(date,convert(char(8),a.OpnameOnderdeelStartDatumId)) 
            END

        and DATEADD(day,b.GgzActiviteitDuurInDagen,convert(date,convert(char(8), CASE WHEN b.GgzActiviteitUitvoerdatumId = 99991231 THEN cast(convert(char(8), getdate()-1, 112) as int)  ELSE GgzActiviteitUitvoerdatumId END ))) --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN OpnameOnderdeelEindTijdId >= 2000 and a.OpnameOnderdeelEindDatumId<>-1 THEN DATEADD(day,1,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId)))
                WHEN OpnameOnderdeelEindTijdId <  2000 and a.OpnameOnderdeelEindDatumId<>-1 THEN dateadd(day,0,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId)))
           		WHEN a.OpnameOnderdeelEindDatumId = -1                                      THEN cast(getdate() as date)
            END
    
		left join pub.DimPeilmaand e
	    on b.GgzActiviteitPeilmaandId=e.PeilmaandId
        

    /*,1
        and DATEADD(day,b.GgzActiviteitDuurInDagen,convert(date,convert(char(8), CASE WHEN b.GgzActiviteitUitvoerdatumId = 99991231 THEN cast(getdate()-1  as date)  ELSE   convert(date,convert(char(8),GgzActiviteitUitvoerdatumId)) END)))  --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN OpnameOnderdeelEindTijdId >= 2000 and a.OpnameOnderdeelEindDatumId <>-1 THEN a.OpnameOnderdeelEindDatumId
                WHEN OpnameOnderdeelEindTijdId <  2000 and a.OpnameOnderdeelEindDatumId <>-1 THEN cast(convert(char(8), dateadd(day,-1,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId))) , 112) as int) 
           		WHEN a.OpnameOnderdeelEindDatumId =-1 Then  cast(convert(char(8), getdate()-1, 112) as int) 
                                                               
            END*/

    where (a.OpnameOnderdeelEindDatumId >= 20220101 or a.OpnameOnderdeelEindDatumId=-1)
        and a.OpnameOnderdeelInternSpecialismeId=44
		and (e.IsLaatstGeladenMaandJn = 'J'  OR e.IsLaatstGeladenMaandJn IS NULL)
       
    group by
         OpnameNr
        , OpnameOnderdeelVolgNr
        , OpnameBevatVerlofJn
        , OpnameOntslagDatumId
        , OpnameDatumId
        , OpnameEnkelDvJn
        , OpnameKlinischeOpnameJn
        , OpnamePatientId
        , OpnameSpoedInd
        , OpnameOntslagTijdId
        , OpnameTijdId
        , OpnameOnderdeelEventId
        , OpnameOnderdeelStartDatumId
        , OpnameOnderdeelStartTijdId
        , OpnameOnderdeelEindDatumId
        , OpnameOnderdeelEindTijdId
        , OpnameOnderdeelInternSpecialismeId
        , OpnameOnderdeelDepartmentId
        , OpnameOnderdeelPatientKlasseId
        , OpnameOnderdeelKamerId
        , OpnameOnderdeelStartReden
        , OpnameOnderdeelEindReden
        , OpnameOnderdeelAdtEventTypeId
		, GgzActiviteitPeilmaandId
		, GgzZorgprestatieId
		
union    
--Verblijfsdagen
    select
      iif (OpnameNr is null,-1,OpnameNr) as OpnameNr
    , iif (OpnameOnderdeelVolgNr is null,-1,OpnameOnderdeelVolgNr) as OpnameOnderdeelVolgNr
    , iif (OpnameOntslagDatumId is null,-1,OpnameOntslagDatumId) as OpnameOntslagDatumId
    , iif (OpnameDatumId is null,-1,OpnameDatumId) as OpnameDatumId
    , iif (OpnameEnkelDvJn is null, 'O',OpnameEnkelDvJn) as OpnameEnkelDvJn
    , iif (OpnameKlinischeOpnameJn is null, 'J',OpnameKlinischeOpnameJn) as OpnameKlinischeOpnameJn
    , GgzActiviteitPatientId as OpnamePatientId
    , iif (OpnameSpoedInd is null, 'Onbekend',OpnameSpoedInd) as OpnameSpoedInd
    , iif (OpnameOntslagTijdId is null, -1,OpnameOntslagTijdId) as OpnameOntslagTijdId
    , iif (OpnameTijdId is null,-1,OpnameTijdId) as OpnameTijdId
    , iif (OpnameOnderdeelEventId is null, -1, OpnameOnderdeelEventId) as OpnameOnderdeelEventId
    , iif (OpnameOnderdeelStartDatumId is null,-1, OpnameOnderdeelStartDatumId) as OpnameOnderdeelStartDatumId
    , iif (OpnameOnderdeelStartTijdId is null, -1, OpnameOnderdeelStartTijdId) as OpnameOnderdeelStartTijdId
    , iif (OpnameOnderdeelEindDatumId is null,-1, OpnameOnderdeelEindDatumId) as OpnameOnderdeelEindDatumId
    , iif (OpnameOnderdeelEindTijdId is null,-1,OpnameOnderdeelEindTijdId) as OpnameOnderdeelEindTijdId
    , iif (OpnameOnderdeelInternSpecialismeId is null,-1, OpnameOnderdeelInternSpecialismeId) as OpnameOnderdeelInternSpecialismeId
    , iif (OpnameOnderdeelDepartmentId is null, -1, OpnameOnderdeelDepartmentId) as OpnameOnderdeelDepartmentId
    , iif (OpnameOnderdeelPatientKlasseId is null,-1,OpnameOnderdeelPatientKlasseId) as OpnameOnderdeelPatientKlasseId
    , iif (OpnameOnderdeelKamerId is null,-1,OpnameOnderdeelKamerId) as OpnameOnderdeelKamerId
    , iif (OpnameOnderdeelStartReden is null, 'Onb', OpnameOnderdeelStartReden) as OpnameOnderdeelStartReden
    , iif (OpnameOnderdeelEindReden is null, 'Onb', OpnameOnderdeelEindReden) as OpnameOnderdeelEindReden
    , 0													     as OpnameOnderdeelDuur
    , 0														 as OpnameOnderdeelLigduur
    , 0														 as OpnameOnderdeelVerlofduur
    , iif (OpnameOnderdeelAdtEventTypeId is null,-1,OpnameOnderdeelAdtEventTypeId) as OpnameOnderdeelAdtEventTypeId	
    , sum(GgzActiviteitDuurInDagen)							 as GgzActiviteitDuurInDagen
	, c.GgzZorgprestatieId									as GgzZorgprestatieId
	, b.GgzActiviteitPeilmaandId
	
  	
    
    from ssas_ggz.FactGgzActiviteit b
	 left join [ssas_ggz].DimGgzZorgprestatie c
		 on b.GgzActiviteitZorgprestatieDimId=c.GgzZorgprestatieId 

	left join [ssas_pgs].[FactOpnameEnDagopname] a 
            on	a.OpnamePatientId = b.GgzActiviteitPatientId

        and convert(date ,convert(char(8),b.GgzActiviteitUitvoerdatumId)) >= 
            CASE
                WHEN OpnameOnderdeelStartTijdId >= 2000 THEN dateadd(day,1,convert(date,convert(char(8),a.OpnameOnderdeelStartDatumId))) 
                WHEN OpnameOnderdeelStartTijdId <  2000 THEN  convert(date,convert(char(8),a.OpnameOnderdeelStartDatumId)) 
            END

        and DATEADD(day,b.GgzActiviteitDuurInDagen,convert(date,convert(char(8), CASE WHEN b.GgzActiviteitUitvoerdatumId = 99991231 THEN cast(convert(char(8), getdate()-1, 112) as int)  ELSE GgzActiviteitUitvoerdatumId END ))) --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN OpnameOnderdeelEindTijdId >= 2000 and a.OpnameOnderdeelEindDatumId<>-1 THEN DATEADD(day,1,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId)))
                WHEN OpnameOnderdeelEindTijdId <  2000 and a.OpnameOnderdeelEindDatumId<>-1 THEN dateadd(day,0,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId)))
           		WHEN a.OpnameOnderdeelEindDatumId = -1                                      THEN cast(getdate() as date)
            END
    
		left join pub.DimPeilmaand e
	    on b.GgzActiviteitPeilmaandId=e.PeilmaandId
        

    /*,1
        and DATEADD(day,b.GgzActiviteitDuurInDagen,convert(date,convert(char(8), CASE WHEN b.GgzActiviteitUitvoerdatumId = 99991231 THEN cast(getdate()-1  as date)  ELSE   convert(date,convert(char(8),GgzActiviteitUitvoerdatumId)) END)))  --einddatum op basis van duur in dagen
            <= 
            CASE --WHEN OpnameOnderdeelEindDatumId = -1  THEN GETDATE()-1 
                WHEN OpnameOnderdeelEindTijdId >= 2000 and a.OpnameOnderdeelEindDatumId <>-1 THEN a.OpnameOnderdeelEindDatumId
                WHEN OpnameOnderdeelEindTijdId <  2000 and a.OpnameOnderdeelEindDatumId <>-1 THEN cast(convert(char(8), dateadd(day,-1,convert(date,convert(char(8),a.OpnameOnderdeelEindDatumId))) , 112) as int) 
           		WHEN a.OpnameOnderdeelEindDatumId =-1 Then  cast(convert(char(8), getdate()-1, 112) as int) 
                                                               
            END*/

   where (e.IsLaatstGeladenMaandJn = 'J'  OR e.IsLaatstGeladenMaandJn IS NULL)
		 and c.GgzZorgprestatieGroepCode = 'VD'
       
    group by
         OpnameNr
        , OpnameOnderdeelVolgNr
        , OpnameBevatVerlofJn
        , OpnameOntslagDatumId
        , OpnameDatumId
        , OpnameEnkelDvJn
        , OpnameKlinischeOpnameJn
        , GgzActiviteitPatientId
        , OpnameSpoedInd
        , OpnameOntslagTijdId
        , OpnameTijdId
        , OpnameOnderdeelEventId
        , OpnameOnderdeelStartDatumId
        , OpnameOnderdeelStartTijdId
        , OpnameOnderdeelEindDatumId
        , OpnameOnderdeelEindTijdId
        , OpnameOnderdeelInternSpecialismeId
        , OpnameOnderdeelDepartmentId
        , OpnameOnderdeelPatientKlasseId
        , OpnameOnderdeelKamerId
        , OpnameOnderdeelStartReden
        , OpnameOnderdeelEindReden
        , OpnameOnderdeelAdtEventTypeId
		, GgzActiviteitPeilmaandId
		, GgzZorgprestatieId
