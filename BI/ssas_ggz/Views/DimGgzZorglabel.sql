
CREATE view [ssas_ggz].[DimGgzZorglabel] as 

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-01-20	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select
	  [ggz_zorglabel_id]			as GgzZorglabelId
	, [ggz_zorglabel_code]			as GgzZorglabelCode 
	, [ggz_zorglabel_oms]			as GgzZorglabelOms
	, [geldstroom]					as GgzZorglabelGeldstroom
	
 from [$(DM_DIM)].dbo.d_ggz_zorglabel
