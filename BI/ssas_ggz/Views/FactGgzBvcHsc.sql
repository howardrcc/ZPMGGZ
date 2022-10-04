





CREATE         view [ssas_ggz].[FactGgzBvcHsc] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 
2021-07-07  BIA    aangemaakt
------------------------------------------------------------------- 

##*/
select
  ggz_bvc_hsc_id										as GgzBvcHscId
, a.patient_id											as GgzBvcHscPatientId
, a.opname_nr											as GgzBvcHscOpnameNr
, datum_id_ontslag										as GgzBvcHscOpnameOntslagDatumId
, datum_id_opname										as GgzBvcHscOpnameDatumId
, opname_type_id										as GgzBvcHscOpnameTypeId
, tijd_id_ontslag										as GgzBvcHscOpnameOntslagTijdId
, tijd_id_opname										as GgzBvcHscOpnameTijdId
, klinische_opname_jn									as GgzBvcHscOpnameKlinischeOpnameJn
, spoed_ind												as GgzBvcHscOpnameSpoedInd
, bevat_verlof_jn										as GgzBvcHscOpnameBevatVerlofJn
, department_id											as GgzBvcHscDepartmentId
, meting_datumtijd										as GgzBvcHscMetingDatumTijd
, YEAR(meting_datumtijd)								as GgzBvcHscMetingDatumJaar
, MONTH(meting_datumtijd)								as GgzBvcHscMetingDatumMaand
, verwardheid											as GgzBvcHscVerwardheid
, geirriteerdheid										as GgzBvcHscGeirriteerdheid
, luidruchtigheid										as GgzBvcHscLuidruchtigheid
, fysiek_bedreigend										as GgzBvcHscFysiekBedriegend
, verbaal_bedreigend									as GgzBvcHscVerbaalBedreigend
, aanval_gericht_op_voorwerpen							as GgzBvcHscAanvalGerichtOpVoorwerpen
, automutilatie											as GgzBvcHscAutomutilatie
, subjectieve_inschatting_gevaar						as GgzBvcHscSubjectieveInschattingGevaar
, score_broset											as GgzBvcHscScoreBroset
, leven_niet_de_moeite_waard							as GgzBvcHscLevenNietDeMoeiteWaard
, sterfwens_doch_geen_plannen							as GgzBvcHscSterfwensDochGeenPlannen
, suicide_gedachten_en_plannen							as GgzBvcHscSuicideGedachtenEnPlannen
, afgelopen_3dg_zelfmoordpoging							as GgzBvcHscAfgelopen3DagenZelfmoordpoging
, onder_toezicht_gevaar_voor_suicide					as GgzBvcHscOnderToezichtGevaarVoorSuicide
, gedragsverandering_gemeld_jn							as GgzBvcHscGedragsveranderingGemeldJn
, iets_aan_de_hand_gevraagd_jn							as GgzBvcHscIetsAanDeHandGevraagdJn
, risico_agressie_geweld_voorgelegd_jn					as GgzBvcHscRisicoAgressieGeweldVoorgelegdJn
, belang_veiligheid_voorgehouden_jn						as GgzBvcHscBelangVeiligheidVoorgehoudenJn
, verblijf_binnentuin_aangeboden_jn						as GgzBvcHscVerblijfBinnentuinAangebodenJn
, verblijf_hc_ic_aangeboden_jn							as GgzBvcHscVerblijfHcIcAangebodenJn
, risicoafwending_besproken_jn							as GgzBvcHscRisicoAfwendingBesprokenJn
, gehandeld_volgens_plan_jn								as GgzBvcHscGehandeldVolgensPlanJn
, contact_aangeboden_jn									as GgzBvcHscContactAangebodenJn
, terugtrekken_aangeboden_jn							as GgzBvcHscTerugtrekkenAangebodenJn
, medicatie_aangeboden_jn								as GgzBvcHscMedicatieAangebodenJn
, wandeling_aangeboden_jn								as GgzBvcHscWandelingAangebodenJn
, zelf_wandelen_aangeboden_jn							as GgzBvcHscZelfWandelenAangebodenJn
, afleiding_voorgesteld_jn								as GgzBvcHscAfleidingVoorgesteldJn
, een_op_een_begeleiding_jn								as GgzBvcHscEenOpEenBegeleidingJn
, elke_15_minuten_zien_jn								as GgzBvcHscElke15MinutenZienJn
, elke_60_minuten_zien_jn								as GgzBvcHscElke60MinutenZienJn
, kamer_veilig_maken_jn									as GgzBvcHscKamerVeiligMakenJn
, anders												as GgzBvcHscAnders
, aantal_actie											as GgzBvcHscActieAantal


from [$(DM_ZORG)].dbo.f_ggz_bvc_hsc a
inner join [$(DM_ZORG)].dbo.f_opname b
  on a.opname_nr = b.opname_nr
