


CREATE   view [ssas_ggz].[FactGgzArgusInterventie] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 
2022-01-10  BIA    aangemaakt
------------------------------------------------------------------- 

##*/
select
  ggz_argus_interventie_id									as GgzArgusInterventieId
, ggz_argus_id												as GgzArgusId
, ggz_dbc_id												as GgzArgusDbc_id
, patient_id												as GgzArgusPatientId
, opname_nr													as GgzArgusOpnameNr
, meting_datumtijd											as GgzArgusMetingDatumTijd
, registratie_datumtijd										as GgzArgusRegistratieDatumTijd
, registratie_werknemer_id									as GgzArgusRegistratieWerknemerId
, department_id												as GgzArgusDepartmentId
, department_id_verblijf									as GgzArgusDepartmentIdVerblijf
, locatie_inschrijving										as GgzArgusLocatieInschrijving
, locatie_inschrijving_opm									as GgzArgusLocatieInschrijvingOpm
, locatie_verblijf											as GgzArgusLocatieVerblijf
, locatie_verblijf_opm										as GgzArgusLocatieVerblijfOpm
, arts_assistent_aanvang									as GgzArgusArtsAssistentAanvang
, arts_assistent_aanvang_opm								as GgzArgusArtsAssistentAanvangOpm
, psychiater_aanvang										as GgzArgusPsychiaterAanvang
, psychiater_aanvang_opm									as GgzArgusPsychiaterAanvangOpm
, arts_assistent_uitvoering									as GgzArgusArtsAssistentUitvoering
, arts_assistent_uitvoering_opm								as GgzArgusArtsAssistentUitvoeringOpm
, risicotaxatie_afgenomen_bij_opname						as GgzArgusRisicoTaxatieAfgenomenBijOpname
, risicotaxatie_afgenomen_bij_opname_opm					as GgzArgusRisicoTaxatieAfgenomenBijOpnameOpm
, risico_op_suicide											as GgzArgusRisicoOpSuicide
, risico_op_suicide_opm										as GgzArgusRisicoOpSuicideOpm
, risico_op_agressie										as GgzArgusRisicoOpAgressie
, risico_op_agressie_opm									as GgzArgusRisicoOpAgressieOpm
, preventief_toegepaste_alternatieven						as GgzArgusPreventiefToegepasteAlternatieven
, preventief_toegepaste_alternatieven_opm					as GgzArgusPreventiefToegepasteAlternatievenOpm
, ander_alternatief											as GgzArgusAnderAlternatief
, ander_alternatief_opm										as GgzArgusAnderAlternatiefOpm
, bopz_aanvang_formulier_verzonden							as GgzArgusBopzAanvangFormulierVerzonden
, bopz_aanvang_formulier_verzonden_opm						as GgzArgusBopzAanvangFormulierVerzondenOpm
, art_39_m_of_m												as GgzArgusArt39MOfM
, art_39_m_of_m_opm											as GgzArgusArt39MOfMOpm
, art_38_dwangbehandeling									as GgzArgusArt38Dwangbehandeling
, art_38_dwangbehandeling_opm								as GgzArgusArt38DwangbehandelingOpm
, juridische_status_ten_tijde_van_toepassing				as GgzArgusJuridischeStatusTenTijdeVanToepassing
, juridische_status_ten_tijde_van_toepassing_opm			as GgzArgusJuridischeStatusTenTijdeVanToepassingOpm
, interventie_soort											as GgzArgusInterventieSoort
, interventie												as GgzArgusInterventie
, interventie_opm											as GgzArgusInterventieOpm
, welk_artikel												as GgzArgusWelkArtikel
, welk_artikel_opm											as GgzArgusWelkArtikelOpm
, ingangsdatum												as GgzArgusIngangsdatum
, ingangsdatum_id											as GgzArgusIngangsdatumId
, ingangsdatum_opm											as GgzArgusIngangsdatumOpm
, einddatum													as GgzArgusEinddatum
, einddatum_id												as GgzArgusEinddatumId
, einddatum_opm												as GgzArgusEinddatumOpm
, starttijd													as GgzArgusStarttijd
, starttijd_opm												as GgzArgusStarttijdOpm
, eindtijd													as GgzArgusEindtijd
, eindtijd_opm												as GgzArgusEindtijdOpm
, duur														as GgzArgusDuur
, duur_opm													as GgzArgusDuurOpm
, gedwongen_voeding											as GgzArgusGedwongenVoeding
, gedwongen_voeding_opm										as GgzArgusGedwongenVoedingOpm
, onderdeel_van_behandelplan								as GgzArgusOnderdeelVanBehandelplan
, onderdeel_van_behandelplan_opm							as GgzArgusOnderdeelVanBehandelplanOpm
, verzet													as GgzArgusVerzet
, verzet_oms												as GgzArgusVerzetOms
, verzet_opm												as GgzArgusVerzetOpm
, probleem													as GgzArgusProbleem


from [$(DM_ZORG)].dbo.f_ggz_argus_interventie
