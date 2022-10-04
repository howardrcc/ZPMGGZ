


CREATE     VIEW [ssas_ggz].[DimGgzRegiebehandelaarHuidige] as 

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-08-10	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select
	  GgzRegiebehandelaarId							as HuidigeGgzRegiebehandelaarId
	, GgzRegiebehandelaarCode						as HuidigeGgzRegiebehandelaarCode
	, GgzRegiebehandelaarAgb						as HuidigeGgzRegiebehandelaarAgb
	, GgzRegiebehandelaarNaam						as HuidigeGgzRegiebehandelaarNaam
	, GgzRegiebehandelaarBeroepCode					as HuidigeGgzRegiebehandelaarBeroepCode
	, GgzRegiebehandelaarBeroepOms					as HuidigeGgzRegiebehandelaarBeroepOms
	, GgzRegiebehandelaarBeroepsCatCode				as HuidigeGgzRegiebehandelaarBeroepsCatCode
	, GgzRegiebehandelaarBeroepsCatOms				as HuidigeGgzRegiebehandelaarBeroepsCatOms
	
	from ssas_ggz.DimGgzRegiebehandelaar
