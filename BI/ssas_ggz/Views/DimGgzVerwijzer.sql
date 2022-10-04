
CREATE View [ssas_ggz].[DimGgzVerwijzer]  as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-01-14	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select

	  [ggz_verwijzer_id]			as GgzVerwijzerId
	, [verwijzer_agb]				as GgzVerwijzerAgb
	, [verwijzer_naam]				as GgzVerwijzerNaam
	, [startdatum]					as GgzVerwijzerStartDatum
	, [einddatum]					as GgzVerwijzerEindDatum
	, [werknemer_nummer]			as GgzVerwijzerWerknemerNr
	from [$(DM_DIM)].dbo.d_ggz_verwijzer
