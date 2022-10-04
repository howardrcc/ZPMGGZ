




CREATE                                        view [ssas_ggz].[FactGgzMedicatieToedieningVersusActiviteiten] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 
2022-09-12	AL		omzet velden aangepast, toegevoegd en verwijderd. (splitsing max tarief of verzekeraar en toeslagen nu in gewone omzetvelden)
2022-09-06 HCC      vw_f_medicatie_toediening naar tabel
2022-08-15	AL		verzekeraar toegevoegd
2022-06-15	AL		peilmaand en laatst geladen maand uit de velden gehaald maar in het filter van de registratie in ZorgGGZ opgenomen dat alleen laatst geladen maand meegenomen moet worden
2022-04-28	AL		baseren of tabellen ipv views
2022-04-21	AL		opnames toegevoegd
2022-04-08	AL		filter toegevoegd toegediend=j en orderdosering
2022-04-06	AL		peilmaand en filter toegevoegd
2022-03-14  AL		aangemaakt
------------------------------------------------------------------- 

##*/
select
--opname voor esketamine
  a.opname_nr																								as OpnameNr
, a.patient_id																								as OpnamePatientId
, a.datum_id_opname																							as OpnameDatumId
, b.kamer_id																								as OpnameOnderdeelKamerId
, a.specialisme_id_eerste_onderdeel																			as OpnameEersteOnderdeelSpecialismeId
--medicatietoediening
, iif (d.start_datum_id is null, -1,d.start_datum_id)														as ToedieningStartDatumId
, iif (d.start_tijd_id is null, -1,d.start_tijd_id)															as ToedieningStartTijdId
, iif (d.totale_hoeveelheid>0, d.totale_hoeveelheid,0)														as MedicatieToedieningHoeveelheid
, iif (d.medicatie_id is null, -1,d.medicatie_id)															as MedicatieId
, iif (d.doseringsberekening is null, ' ', d.doseringsberekening)											as MedicatieToedieningDoseringsberekening
, iif (d.toegediend_jn is null, ' ', d.toegediend_jn)														as MedicatieToedieningToegediendJn
, iif (d.toediening_zorgverlener_id is null, -1,d.toediening_zorgverlener_id)								as ToedieningZorgverlenerId
, iif (d.atc is null, ' ',d.atc)																			as MedicatieToedieningAtc
--registratie in zorgGGZ
, iif (g.duur_minuten>0,g.duur_minuten,0)																	as GgzActiviteitDuurInMinuten
, iif (g.aantal>0 and g.zorgprestatie_code = 'CO0130',g.aantal,0)											as GgzActiviteitAantalCO0130
, iif (g.aantal>0 and g.zorgprestatie_code = 'CO0260',g.aantal,0)											as GgzActiviteitAantalCO0260
, iif (g.aantal>0 and g.zorgprestatie_code = 'CO0390',g.aantal,0)											as GgzActiviteitAantalCO0390
, iif (g.aantal>0 and g.zorgprestatie_code = 'TC0015',g.aantal,0)											as GgzActiviteitAantalTC0015
, iif (g.zorgprestatie_code is null,' ',g.zorgprestatie_code)												as GgzActiviteitZorgprestatieCode
, iif (g.omzet_vz>0,g.omzet_vz,0)																			as GgzActiviteitOmzetVerzekeraar
, iif (g.verzekeraar_id is null,-1, verzekeraar_id)															as GgzActiviteiVerzekeraarId
--, iif (g.peilmaand_id>0, g.peilmaand_id,CONVERT(varchar(6), GETDATE(), 112))								as GgzActiviteitPeilmaandId--nog aanpassen 202205
--, iif (i.IsLaatstGeladenMaandJn is null,'J',i.IsLaatstGeladenMaandJn)										as IsLaatstGeladenMaandJn

from [$(DM_ZORG)].dbo.f_opname a
left join [$(DM_ZORG)].dbo.f_opname_onderdeel b
on a.opname_nr = b.opname_nr
left join [$(DM_DIM)].dbo.d_kamer c
on b.kamer_id=c.kamer_id

left join(
		select
		*
from [$(DM_ZORG)].dbo.f_medicatie_toediening d
where d.medicatie_id in (301895,310440)) d
on a.opname_nr = d.opname_nr
--and a.MedicatieId in (301895,310440)
	--left join BI.ssas_pgs.DimMedicatieAtc e
--	on d.MedicatieId = e.MedicatieId
--	left join BI.ssas_pgs.DimAtc f
--	on e.AtcId=f.AtcId
--	and d.MedicatieToedieningToegediendJn='J'
		

left join( 
            select 
                g.*
				,h.zorgprestatie_code
			   ,i.IsLaatstGeladenMaandJn
            from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie g
            left outer join [$(DM_DIM)].dbo.d_ggz_zorgprestatie h
            on g.ggz_zorgprestatie_dim_id=h.ggz_zorgprestatie_id 
			left join pub.DimPeilmaand i
			on g.peilmaand_id=i.PeilmaandId
				 where 1=1
				 and i.IsLaatstGeladenMaandJn='J'
                and h.zorgprestatie_code in ('CO0130','CO0260','CO0390','TC0015')
        ) g
on a.patient_id = g.patient_id
and a.datum_id_opname=g.datum_id

	left join pub.DimPeilmaand i
	    on g.peilmaand_id=i.PeilmaandId
       

where a.specialisme_id_eerste_onderdeel = 44
and a.datum_id_opname>20211231
and c.kamer_naam = 'ESK'
--and (f.IsLaatstGeladenMaandJn = 'J'  OR f.IsLaatstGeladenMaandJn IS NULL)
