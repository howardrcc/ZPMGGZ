





CREATE                                       View [ssas_ggz].[FactGgzActiviteit] as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-09-15	AL		ggz_verzekeraar_id toegevoegd
2022-09-12	AL		omzet velden aangepast, toegevoegd en verwijderd. (splitsing max tarief of verzekeraar en toeslagen nu in gewone omzetvelden)
2022-08-10	AL		huidige diagnose en huidige regiebehandelaar toegevoegd.
2022-07-12  Howard  US1767 ADD:verzekeraar_tarief
2022-04-20	AL		velden toegevoegd: HuidigeRegiebehandelaarJn, HuidigeDiagnoseJn, HuidigeFaseInTraject
2022-01-14	AL		aangemaakt
2022-01-17	AL		Verzekeraar toegevoegd
----------------------------------------------------------------------------------------------------------------------------

##*/
select
	  [ggz_zorgprestatie_id]						as GgzActiviteitId
	, [ggz_traject_id]								as GgzActiviteitTrajectId
	, [patient_id]									as GgzActiviteitPatientId
	, [ggz_zorgprestatie_dim_id]					as GgzActiviteitZorgprestatieDimId
	, [zorgverlener_id]								as GgzActiviteitZorgverlenerId
	, [datum_id]									as GgzActiviteitUitvoerdatumId
	, [tijd_id]										as GgzActiviteitUitvoerTijdId
	, [duur_minuten]								as GgzActiviteitDuurInMinuten
	, [directe_tijd_groepsconsulten]				as GgzActiviteitDirecteTijdGroepsconsulten
	, [duur_dagen]									as GgzActiviteitDuurInDagen
	, [aantal]										as GgzActiviteitAantal
	, [omzetmaxtarief]								as GgzActiviteitOmzetMaxTarief
	, [ggz_opname_id]								as GgzActiviteitOpnameId
	, [opname_id_epic]								as GgzActiviteitEpicOpnameNr
	, [afspraak_id_epic]							as GgzActiviteitEpicContactNr
	, [maxtarief]									as GgzActiviteitMaxTarief
	, [verzekeraar_id]								as GgzActiviteitVerzekeraarId
	, [normtijd_indirect]							as GgzActiviteitNormtijdIndirect
	, [doorberekende_directe_tijd]					as GgzActiviteitDirecteTijdDoorberekend
	, [klinisch_jn]									as GgzActiviteitKlinischJn
	, [peilmaand_id]								as GgzActiviteitPeilmaandId
	, [ggz_regiebehandelaar_id_zorgprestatie]		as GgzActiviteitRegiebehandelaarId
	, [ggz_diagnose_zpm_id_zorgprestatie]			as GgzActiviteitDiagnoseId
	, [ggz_zorgprestatie_dim_id_toeslag]			as GgzActiviteitZorgprestatieToeslagId
	, [werknemer_id]								as GgzActiviteitWerknemerId
	, [ggz_dbc_id_oud]								as GgzActiviteitOudDbcId
	, [traject_ggz_zorglabel_id]					as GgzTrajectZorglabelId
	, [traject_startdatum_id]						as GgzTrajectStartDatumId
	, [traject_einddatum_id]						as GgzTrajectEindDatumId
	, [traject_registratiedatum_id]					as GgzTrajectRegistratieDatumId
	, [traject_agb_verwijzer]						as GgzTrajectAgbVerwijzer
	, [traject_agb_verwijzer_id]					as GgzTrajectAgbVerwijzerId
	, [traject_ggz_verwijstype_id]					as GgzTrajectVerwijstypeId
	, [traject_tariefniveau]						as GgzTrajectTariefNiveau
	, [ggz_traject_id]								as GgzTrajectId
    , [HuidigeDiagnoseJn]							as GgzActiviteitHuidigeDiagnoseJn
    , [HuidigeRegiebehandelaarJn]					as GgzActiviteitHuidigeRegiebehandelaarJn
	, [diagnose_huidige_id]							as GgzActiviteitHuidigeDiagnoseId
	, [regiebehandelaar_huidige_id]					as GgzActiviteitHuidigeRegiebehandelaarId
	, [omzet_vz]									as GgzActiviteitOmzetPerverzekeraar
	, [vz_tarief_ind]								as GgzActiviteitTariefInd
	, [ggz_toeslag_id]								as GgzActiviteitToeslagInd
    , [HuidigeFaseInTraject]						as GgzActiviteitHuidigeFaseInTraject
    , CASE  WHEN gc_geen_tijd_ind = 1 THEN 'J'
            WHEN gc_geen_tijd_ind = 0 THEN 'N'
        Else 'O' END                                as GgzActiviteitGroepsConsultGeenTijdInd
	, verzekeraar_tarief                            as GgzVerzekeraarTarief
	,ggz_verzekeraar_id								as GgzVerzekeraarId
	

from [$(DM_ZORG)].dbo.f_ggz_zorgprestatie
