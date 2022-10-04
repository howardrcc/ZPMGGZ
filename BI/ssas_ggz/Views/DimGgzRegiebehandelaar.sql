



CREATE       VIEW [ssas_ggz].[DimGgzRegiebehandelaar] as 

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-06-01	AL		beroep toegevoegd
2022-01-20	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select
	  [ggz_regiebehandelaar_id]			as GgzRegiebehandelaarId
	, [ggz_regiebehandelaar_code]		as GgzRegiebehandelaarCode
	, [ggz_regiebehandelaar_agb]		as GgzRegiebehandelaarAgb
	, [ggz_regiebehandelaar_naam]		as GgzRegiebehandelaarNaam
	, beroep_code						as GgzRegiebehandelaarBeroepCode
	, beroep_oms						as GgzRegiebehandelaarBeroepOms
	, beroepscategorie_code				as GgzRegiebehandelaarBeroepsCatCode
	, beroepscategorie_oms				as GgzRegiebehandelaarBeroepsCatOms
	
	from [$(DM_DIM)].dbo.d_ggz_regiebehandelaar
