



CREATE       view [ssas_ggz].[FactGgzBopz] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 
2021-07-07  BIA    aangemaakt
------------------------------------------------------------------- 

##*/
select
  ggz_bopz_id										as GgzBopzId
, patient_id										as GgzBopzPatientId
, opname_nr											as GgzBopzOpnameNr
, meting_datumtijd									as GgzBopzMetingDatumTijd
, registratie_datumtijd								as GgzBopzRegistratieDatumTijd
, registratie_werknemer_id							as GgzBopzRegistratieWerknemerId
, department_id										as GgzBopzDepartmentId
, juridische_status									as GgzBopzJuridischeStatus
, juridische_status_opm								as GgzBopzJuridischeStatusOpm
, juridische_status_aanvullend						as GgzBopzJuridischeStatusAanvullend
, juridische_status_aanvullend_opm					as GgzBopzJuridischeStatusAanvullendOpm
, datum_aanvraag_ibs								as GgzBopzDatumAanvraagIbs
, datum_aanvraag_ibs_opm							as GgzBopzDatumAanvraagIbsOpm
, datum_toekenning_ibs								as GgzBopzDatumToekenningIbs
, datum_toekenning_ibs_opm							as GgzBopzDatumToekenningIbsOpm
, einddatum_ibs_termijn								as GgzBopzEinddatumIbsTermijn
, einddatum_ibs_termijn_opm							as GgzBopzEinddatumIbsTermijnOpm
, datum_beeindiging_ibs								as GgzBopzDatumBeeindigingIbs
, datum_beeindiging_ibs_opm							as GgzBopzDatumBeeindigingIbsOpm
, datum_aanvraag_rm									as GgzBopzDatumAanvraagRm
, datum_aanvraag_rm_opm								as GgzBopzDatumAanvraagRmOpm
, datum_toekenning_rm								as GgzBopzDatumToekenningRm
, datum_toekenning_rm_opm							as GgzBopzDatumToekenningRmOpm
, einddatum_rm										as GgzBopzEinddatumRm
, einddatum_rm_opm									as GgzBopzEinddatumRmOpm
, datum_beeindiging_rm								as GgzBopzDatumBeeindigingRm							
, datum_beeindiging_rm_opm							as GgzBopzDatumBeeindingingRmOpm
, aanvangsdatum_m_en_m								as GgzBopzAanvangsdatumMEnM
, aanvangsdatum_m_en_m_opm							as GgzBopzAanvangsdatumMEnMOpm
, einddatum_m_en_m									as GgzBopzEinddatumMEnM
, einddatum_m_en_m_opm								as GgzBopzEinddatumMEnMOpm
, aanvangsdatum_dwangbehandeling					as GgzBopzAanvangsdatumDwangbehandeling
, aanvangsdatum_dwangbehandeling_opm				as GgzBopzAanvangsdatumDwangbehandelingOpm
, datum_beeindiging_dwangbehandeling				as GgzBopzBeeindigingDwangbehandeling
, datum_beeindiging_dwangbehandeling_opm			as GgzBopzBeeindigingDwangbehandelingOpm
, afspraken_mbt_beperkingen							as GgzBopzAfsprakenMbtBeperkingen
, afspraken_mbt_beperkingen_opm						as GgzBopzAfsprakenMbtBeperkingenOpm
, bopz_geldig_tot									as GgzBopzGeldigTot
, bopz_geldig_tot_opm								as GgzBopzGeldigTotOpm
, bopz_toelichting									as GgzBopzToelichting
, bopz_toelichting_opm								as GgzBopzToelichtingOpm


from [$(DM_ZORG)].dbo.f_ggz_bopz
