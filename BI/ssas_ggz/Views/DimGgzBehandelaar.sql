

CREATE   view [ssas_ggz].[DimGgzBehandelaar] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 
2022-06-20 HCC    behandelaar data uit zorgggz ipv ode
2022-01-17  AL    aangemaakt
------------------------------------------------------------------- 

##*/

select
	  [ggz_regiebehandelaar_id]			as GgzBehandelaarId
	, [ggz_regiebehandelaar_code]		as GgzBehandelaarCode
	, [ggz_regiebehandelaar_agb]		as GgzBehandelaarAgb
	, [ggz_regiebehandelaar_naam]		as GgzBehandelaarNaam
	, beroep_code						as GgzBehandelaarBeroepCode
	, beroep_oms						as GgzBehandelaarBeroepOms
	, beroepscategorie_code				as GgzBehandelaarBeroepsCatCode
	, beroepscategorie_oms				as GgzBehandelaarBeroepsCatOms
	
	from [$(DM_DIM)].dbo.d_ggz_regiebehandelaar
