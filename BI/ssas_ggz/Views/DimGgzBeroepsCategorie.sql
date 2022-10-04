

CREATE view [ssas_ggz].[DimGgzBeroepsCategorie]  as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-02-23	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select
     [ggz_beroepscategorie_id]			as GgzBeroepsCatId 
	,[ggz_beroepscategorie_code]		as GgzBeroepsCatCode
	,[ggz_beroepscategorie_oms]			as GgzBeroepsCatOms
	 

 
 from [$(DM_DIM)].dbo.d_ggz_beroepscategorie
