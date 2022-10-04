














CREATE                                                  View [ssas_ggz].[FactGgzAfspraakVersusActiviteit] as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-06-06	AL		view niet langer baseren op views maar op tabellen
2022-04-06	AL		filter peilmaand aangepast
2022-03-31	AL		peilmaand toevoegen
2022-01-14	AL		aangemaakt
2022-01-17	AL		Verzekeraar toegevoegd
----------------------------------------------------------------------------------------------------------------------------

##*/
--vanuit afspraak
SELECT  a.afspraak_id											as AgendahouderAfspraakId
      , a.agenda_houder_id										as AgendahouderId
	  , aantal_afspraak_agenda_houder							as AgendahouderAantalAfspraken
      , a.agenda_blok_id										as AgendaBlokId
      , a.beroepsgroep_id										as BeroepgroepId
      , a.buiten_basisrooster_ind								as BuitenBasisroosterInd
	  , datum_id_afspraak_agenda_houder							as AgendahouderAfspraakDatumId
	  , a.department_id											as AgendahouderDepartmentId	
	  , duur_afspraak_agenda_houder								as AgendahouderAfspraakDuur
	  , primair_jn												as AfspraakAgendahouderPrimairJn
	  , a.spec_agb_id											as AgendahouderAgbSpecialismeId
	  , a.specialisme_id										as AgendahouderSpecialismeId
      , tijd_id_afspraak_agenda_houder							as AgendahouderAfspraakTijdId
      , iif(primair_jn= 'J',aantal_gerealiseerd,0)				as GerealiseerdAantal
      , afspraak_nr												as AfspraakNr
	  , afspraak_overboekt_jn									as AfspraakOverboektJn	
	  , afspraak_status_id										as AfspraakStatusId
	  , afspraak_type_id										as AfspraakTypeId 
	  , bezoek_specialisme_id									as BezoekSpecialismeId
	  , bezoek_zorgactiviteit_id								as BezoekZorgactiviteitId
	  , contact_gesloten_door_id								as ContactGeslotenDoorId
	  , contact_type_id											as ContactTypeId
      , datum_id_afspraak										as AfspraakDatumId
      , duur_afspraak_type_default								as AfspraakTypeDefaultDuur
      , duur_realisatie											as RealisatieDuur
	  , overgenomen_agendahouder_id								as OvergenomenAgendahouderId
	  , overgenomen_jn											as AfspraakOvergenomenJn
	  , pat_locatie_id											as PatLocatieId
	  , b.patient_id											as PatientId
      , triage_jn												as AfspraakTriageJn
      , tijd_id_afspraak										as AfspraakTijdId
	  , afspraak_id_epic										as GgzActiviteitEpicContactNr 
	  , zorgverlener_id											as GgzActiviteitZorgverlenerId
	  , iif(ggz_zorgprestatie_dim_id is null,-1,ggz_zorgprestatie_dim_id)	as GgzActiviteitZorgprestatieDimId
	  , iif(ggz_zorgprestatie_dim_id_toeslag is null,-1,ggz_zorgprestatie_dim_id_toeslag)	as GgzActiviteitZorgprestatieToeslagId
	  , [klinisch_jn]											as GgzActiviteitKlinischJn
	  , 0														as GgzActiviteitDuurInMinuten
	  , 0														as GgzActiviteitDirecteTijdGroepsconsulten
	  , 0														as GgzActiviteitDirecteTijdDoorberekend
	  , 0														as GgzActiviteitAantal
	  , [peilmaand_id]											as GgzActiviteitPeilmaandId
	  

--select count(* )
  

from [$(DM_ZORG)].dbo.f_afspraak_agenda_houder a

inner join (
select b.*
from [$(DM_ZORG)].dbo.f_afspraak b
--where aantal_gerealiseerd>0
)b
  on a.afspraak_id = b.afspraak_id
  

 left join [$(DM_DIM)].dbo.d_agenda_houder c        
        on a.agenda_houder_id = c.agenda_houder_id

		left join [$(DM_DIM)].dbo.d_department h
		on a.department_id=h.department_id

    left join (
        select   d.*
				,e.zorgprestatiegroep_code
				,f.IsLaatstGeladenMaandJn
                ,g.werknemer_nummer
        from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie d
		left join [$(DM_DIM)].dbo.d_ggz_zorgprestatie e
        on d.ggz_zorgprestatie_dim_id=e.ggz_zorgprestatie_id
		left join pub.DimPeilmaand f
		on d.peilmaand_id=f.PeilmaandId
        left join [$(DM_DIM)].dbo.d_zorgverlener g 
        on d.zorgverlener_id = g.zorgverlener_id
		 where 1=1
				 and f.IsLaatstGeladenMaandJn='J'
				 and e.zorgprestatiegroep_code in ('CO','GC')
		) d 
        
		on  b.patient_id = d.patient_id
        and a.datum_id_afspraak_agenda_houder = d.datum_id
        and a.tijd_id_afspraak_agenda_houder = d.tijd_id
        and c.werknemer_nummer = d.werknemer_nummer      

	 
    
    
    where h.department_afkorting='PPSYCH'
     --   and aantal_gerealiseerd =1
        and datum_id_afspraak_agenda_houder>=20220101
 
 group by
		a.afspraak_id											
      , a.agenda_houder_id	
	  , aantal_afspraak_agenda_houder
      , a.agenda_blok_id										
      , a.beroepsgroep_id										
      , a.buiten_basisrooster_ind								
	  , datum_id_afspraak_agenda_houder							
	  , a.department_id											
	  , duur_afspraak_agenda_houder								
	  , primair_jn												
	  , a.spec_agb_id											
	  , a.specialisme_id										
      , tijd_id_afspraak_agenda_houder							
      , aantal_gerealiseerd										
      , afspraak_nr												
	  , afspraak_overboekt_jn									
	  , afspraak_status_id										
	  , afspraak_type_id										
	  , bezoek_specialisme_id									
	  , bezoek_zorgactiviteit_id								
	  , contact_gesloten_door_id								
	  , contact_type_id											
      , datum_id_afspraak										
      , duur_afspraak_type_default								
      , duur_realisatie											
	  , overgenomen_agendahouder_id								
	  , overgenomen_jn											
	  , pat_locatie_id											
	  , b.patient_id											
      , triage_jn												
      , tijd_id_afspraak										
	  , afspraak_id_epic										 
	  , zorgverlener_id											
	  , ggz_zorgprestatie_dim_id														
	  , ggz_zorgprestatie_dim_id_toeslag
	  , [klinisch_jn]	
	  , duur_minuten																	
	  , directe_tijd_groepsconsulten													
	  , doorberekende_directe_tijd														
	  , d.aantal																	
	  , peilmaand_id																									


union

--vanuit de zorgprestatie
	SELECT iif( a.afspraak_id is null,-1,a.afspraak_id)									as AgendahouderAfspraakId
      , iif(a.agenda_houder_id is null,-1,a.agenda_houder_id)							as AgendahouderId
	  , 0																				as AgendahouderAantalAfspraken
      , iif(a.agenda_blok_id is null,-1,a.agenda_blok_id)								as AgendaBlokId
      , iif(a.beroepsgroep_id is null,-1,a.beroepsgroep_id)								as BeroepgroepId
      , iif(a.buiten_basisrooster_ind is null, 'O',a.buiten_basisrooster_ind)			as BuitenBasisroosterInd
	  , d.datum_id																		as AgendahouderAfspraakDatumId
	  , iif(a.department_id	is null,-1,a.department_id)									as AgendahouderDepartmentId	
	  , 0																				as AgendahouderAfspraakDuur
	  , iif(primair_jn is null,'O',primair_jn)											as AfspraakAgendahouderPrimairJn
	  , iif(a.spec_agb_id is null,-1,a.spec_agb_id)										as AgendahouderAgbSpecialismeId
	  , iif(a.specialisme_id is null,-1,a.specialisme_id)								as AgendahouderSpecialismeId
      , iif(tijd_id_afspraak_agenda_houder is null, -1,tijd_id_afspraak_agenda_houder)	as AgendahouderAfspraakTijdId
      , 0																				as GerealiseerdAantal
      , iif(afspraak_nr is null, -1,afspraak_nr)										as AfspraakNr
	  , iif(afspraak_overboekt_jn is null, 'O',afspraak_overboekt_jn)					as AfspraakOverboektJn	
	  , iif(afspraak_status_id is null,-1,afspraak_status_id)							as AfspraakStatusId
	  , iif(afspraak_type_id is null,-1,afspraak_type_id)								as AfspraakTypeId 
	  , iif(bezoek_specialisme_id is null,-1,bezoek_specialisme_id)						as BezoekSpecialismeId
	  , iif(bezoek_zorgactiviteit_id is null,-1,bezoek_zorgactiviteit_id)				as BezoekZorgactiviteitId
	  , iif(contact_gesloten_door_id is null,-1,contact_gesloten_door_id)				as ContactGeslotenDoorId
	  , iif(contact_type_id	is null,-1,contact_type_id)									as ContactTypeId
      , d.datum_id																		as AfspraakDatumId
      , iif(duur_afspraak_type_default is null,0,duur_afspraak_type_default)			as AfspraakTypeDefaultDuur
      , 0																				as RealisatieDuur
	  , iif(overgenomen_agendahouder_id is null, -1,overgenomen_agendahouder_id)		as OvergenomenAgendahouderId
	  , iif(overgenomen_jn is null,'O',overgenomen_jn)									as AfspraakOvergenomenJn
	  , iif(pat_locatie_id is null,-1,pat_locatie_id)									as PatLocatieId
	  , d.patient_id																	as PatientId
      , iif(triage_jn is null,'O',triage_jn)											as AfspraakTriageJn
      , d.tijd_id																		as AfspraakTijdId
	  , afspraak_id_epic																as GgzActiviteitEpicContactNr 
	  , d.zorgverlener_id																as GgzActiviteitZorgverlenerId
	  , ggz_zorgprestatie_dim_id														as GgzActiviteitZorgprestatieDimId
	  , ggz_zorgprestatie_dim_id_toeslag												as GgzActiviteitZorgprestatieToeslagId
	  , [klinisch_jn]																	as GgzActiviteitKlinischJn
	  , sum(duur_minuten)																as GgzActiviteitDuurInMinuten
	  , sum(directe_tijd_groepsconsulten)												as GgzActiviteitDirecteTijdGroepsconsulten
	  , sum(doorberekende_directe_tijd)														as GgzActiviteitDirecteTijdDoorberekend
	  , sum(d.aantal)																	as GgzActiviteitAantal
	  , peilmaand_id																	as GgzActiviteitPeilmaandId
	  

--select count(* )
  

from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie d
	 left join [$(DM_DIM)].dbo.d_zorgverlener g 
            on d.zorgverlener_id = g.zorgverlener_id

	left join (select	a.*
      ,[aantal_gerealiseerd]
      ,[afspraak_nr]
      ,[afspraak_overboekt_jn]
      ,[afspraak_status_id]
      ,[afspraak_type_id]
      ,[bezoek_specialisme_id]
      ,[bezoek_zorgactiviteit_id]
      ,[contact_gesloten_door_id]
      ,[contact_type_id]
      ,[datum_id_afspraak]
      ,[duur_afspraak_type_default]
      ,[duur_realisatie]
      ,[overgenomen_agendahouder_id]
      ,[overgenomen_jn]
      ,[pat_locatie_id]
      ,[patient_id]
      ,[triage_jn]
      ,[tijd_id_afspraak]
	  ,c.werknemer_nummer
		from [$(DM_ZORG)].dbo.f_afspraak_agenda_houder a
		inner join(
		select b.*
		from [$(DM_ZORG)].dbo.f_afspraak b
		where aantal_gerealiseerd>0
		) b
		 on a.afspraak_id = b.afspraak_id

	 left join [$(DM_DIM)].dbo.d_agenda_houder c        
        on a.agenda_houder_id = c.agenda_houder_id
	
	left join [$(DM_DIM)].dbo.d_department h
		on a.department_id=h.department_id
		where h.department_afkorting='PPSYCH'
      --  and aantal_gerealiseerd =1
        and datum_id_afspraak_agenda_houder>=20220101) a
		on  d.patient_id = a.patient_id
        and d.datum_id = datum_id_afspraak_agenda_houder
        and d.tijd_id = a.tijd_id_afspraak_agenda_houder
        and g.werknemer_nummer = a.werknemer_nummer      


   
	left join pub.DimPeilmaand f
		on d.peilmaand_id=f.PeilmaandId
    
    left join [$(DM_DIM)].dbo.d_ggz_zorgprestatie e
        on d.ggz_zorgprestatie_dim_id=e.ggz_zorgprestatie_id
    
    where e.zorgprestatiegroep_code in ('CO','GC')
          and (f.IsLaatstGeladenMaandJn = 'J'  OR f.IsLaatstGeladenMaandJn IS NULL)


	 group by
		a.afspraak_id											
      , a.agenda_houder_id	
	  , aantal_afspraak_agenda_houder
      , a.agenda_blok_id										
      , a.beroepsgroep_id										
      , a.buiten_basisrooster_ind								
	  , d.datum_id							
	  , a.department_id											
	  , duur_afspraak_agenda_houder								
	  , primair_jn												
	  , a.spec_agb_id											
	  , a.specialisme_id										
      , tijd_id_afspraak_agenda_houder							
      , aantal_gerealiseerd										
      , afspraak_nr												
	  , afspraak_overboekt_jn									
	  , afspraak_status_id										
	  , afspraak_type_id										
	  , bezoek_specialisme_id									
	  , bezoek_zorgactiviteit_id								
	  , contact_gesloten_door_id								
	  , contact_type_id											
      , d.datum_id										
      , duur_afspraak_type_default								
      , duur_realisatie											
	  , overgenomen_agendahouder_id								
	  , overgenomen_jn											
	  , pat_locatie_id											
	  , d.patient_id											
      , triage_jn												
      , d.tijd_id										
	  , afspraak_id_epic										 
	  , d.zorgverlener_id											
	  , ggz_zorgprestatie_dim_id														
	  , ggz_zorgprestatie_dim_id_toeslag		
	  , [klinisch_jn]
	  , duur_minuten																	
	  , directe_tijd_groepsconsulten													
	  , doorberekende_directe_tijd														
	  , d.aantal																	
	  , peilmaand_id
