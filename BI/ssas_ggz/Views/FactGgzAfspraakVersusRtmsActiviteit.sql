

 

CREATE                                         View [ssas_ggz].[FactGgzAfspraakVersusRtmsActiviteit] as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------

2022-04-06	AL		filter peilmaand aangepast
2022-03-31	AL		peilmaand toevoegen
2022-01-14	AL		aangemaakt
2022-01-17	AL		Verzekeraar toegevoegd
----------------------------------------------------------------------------------------------------------------------------

##*/
SELECT [AgendahouderAfspraakId]
      ,a.[AgendahouderId]
      ,[AgendahouderDepartmentId]
      ,[AgendahouderAfspraakDuur]
      ,[AfspraakAgendahouderPrimairJn]
      ,[AgendahouderSpecialismeId]
      ,[AgendahouderAfspraakTijdId]
      ,[GerealiseerdAantal]
      ,[AfspraakNr]
      ,[AfspraakStatusId]
      ,a.[AfspraakTypeId]
      ,[BezoekSpecialismeId]
      ,[AfspraakDatumId]
      ,[RealisatieDuur]
      ,[PatientId]
      ,[AfspraakTijdId]
	  ,d.GgzActiviteitEpicContactNr 
	  ,d.GgzActiviteitZorgverlenerId
	  ,d.GgzActiviteitZorgprestatieDimId
	  ,d.GgzActiviteitOmzetMaxTarief
	  ,d.GgzActiviteitOmzetPerverzekeraar
	  ,d.GgzActiviteitDuurInMinuten
	  ,d.GgzActiviteitDirecteTijdGroepsconsulten
	  ,d.GgzActiviteitAantal
	  ,d.GgzActiviteitPeilmaandId
	  ,e.IsLaatstGeladenMaandJn

--select count(* )
    FROM [ssas_pgs].[FactAfspraak] a
    left join ssas_pgs.DimAfspraakType b         
        on a.AfspraakTypeId = b.AfspraakTypeId

    left join (
        select d.*
            ,a.ZorgverlenerNr
        from [ssas_ggz].FactGgzActiviteit d
        left join ssas_pgs.DimZorgverlener a 
            on a.ZorgverlenerId = d.GgzActiviteitZorgverlenerId

    ) d 
        on  d.GgzActiviteitPatientId = a.PatientId
        and a.AfspraakDatumId = d.GgzActiviteitUitvoerdatumId
        and a.AfspraakTijdId = d.GgzActiviteitUitvoerTijdId
        
        

	left join pub.DimPeilmaand e
    on d.GgzActiviteitPeilmaandId=e.PeilmaandId
    
    left outer join [ssas_ggz].DimGgzZorgprestatie c
        on d.GgzActiviteitZorgprestatieDimId=c.GgzZorgprestatieId
    
    where AgendahouderDepartmentId=903
	and b.AfspraakTypeAfk = 'RTMS'
        and GerealiseerdAantal >0
        and AgendahouderAfspraakDatumId>=20220101
        and (e.IsLaatstGeladenMaandJn = 'J'  OR e.IsLaatstGeladenMaandJn IS NULL)
