
CREATE view [ssas_ggz].[DimGgzVerwijstype]  as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-01-14	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select
      [ggz_verwijstype_id]		as GgzVerwijstypeId
	, [verwijstype_code]		as GgzVerwijstypeCode
	, [verwijstype_oms]			as GgzVerwijstypeOms
	, [startdatum]				as GgzVerwijstypeStartDatum
	, [einddatum]				as GgzVerwijstypeEindDatum
	, [agb_verplicht_jn]		as GgzVerwijstypeAgbVerplichtJn
	, [bron]					as GgzVerwijstypeBron
	
 
 from [$(DM_DIM)].dbo.d_ggz_verwijstype
