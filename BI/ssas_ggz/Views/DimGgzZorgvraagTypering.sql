




CREATE                           View [ssas_ggz].[DimGgzZorgvraagTypering] as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-08-31  Howard  add: verwijderd_datum is null
2022-06-15  Howard  Add: LaatsteUitvraagJN
2022-03-28	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select

	 [ggz_uitvraag_id]						as ZorgvraagTyperingUitvraagId
	, [ggz_traject_id]						as ZorgvraagTyperingTrajectId
	, [ggz_uitvraag_datum]					as ZorgvraagTyperingDatum
	, [ggz_regiebehandelaar_naam]			as ZorgvraagTyperingRegiebehandelaarNaam
	, [ggz_hoofdgroep_jn]					as ZorgvraagTyperingHoofdgroepJn
	, [ggz_uitvraag_type]					as ZorgvraagTyperingUitvraagType
	, [ggz_zorgvraagtype_code_advies]		as ZorgvraagTyperingAdviesCode
	, [ggz_zorgvraagtype_oms_advies]		as ZorgvraagTyperingAdviesOms
	, [ggz_zorgvraagtype_code]				as ZorgvraagTyperingCode
	, [ggz_zorgvraagtype_oms]				as ZorgvraagTyperingOms
	, [ggz_uitvraag_status]					as ZorgvraagTyperingStatus
	, [ggz_uitvraag_steekproef]				as ZorgvraagTyperingSteekproef
    , laatste_uitvraag_jn                   as ZorgvraagTyperingLaatsteUitvraagJn
	

From [$(DM_DIM)].dbo.d_ggz_uitvraag
where verwijderd_datum is null
