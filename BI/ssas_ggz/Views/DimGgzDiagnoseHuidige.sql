



CREATE       VIEW [ssas_ggz].[DimGgzDiagnoseHuidige]	as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-08-10	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select

	  GgzDiagnoseId						as HuidigeGgzDiagnoseId
	, GgzDiagnoseStartDatum				as HuidigeGgzDiagnoseStartDatum
	, GgzDiagnoseEindDatum				as HuidigeGgzDiagnoseEindDatum
	, GgzDiagnoseCode					as HuidigeGgzDiagnoseCode
	, GgzDiagnoseOms					as HuidigeGgzDiagnoseOms
	, GgzDiagnoseHierarchie				as HuidigeGgzDiagnoseHierarchie
	, GgzDiagnoseIcd9					as HuidigeGgzDiagnoseIcd9
	, GgzDiagnoseIcd10					as HuidigeGgzDiagnoseIcd10
	, GgzDiagnoseCodeNiv1				as HuidigeGgzDiagnoseCodeNiv1
	, GgzDiagnoseOmsNiv1				as HuidigeGgzDiagnoseOmsNiv1
	, GgzDiagnoseCodeNiv2				as HuidigeGgzDiagnoseCodeNiv2
	, GgzDiagnoseOmsNiv2				as HuidigeGgzDiagnoseOmsNiv2
	, GgzDiagnoseCodeNiv3				as HuidigeGgzDiagnoseCodeNiv3
	, GgzDiagnoseOmsNiv3				as HuidigeGgzDiagnoseOmsNiv3
	, GgzDiagnoseCodeNiv4				as HuidigeGgzDiagnoseCodeNiv4
	, GgzDiagnoseOmsNiv4				as HuidigeGgzDiagnoseOmsNiv4
	, GgzDiagnoseCodeNiv5				as HuidigeGgzDiagnoseCodeNiv5
	, GgzDiagnoseOmsNiv5				as HuidigeGgzDiagnoseOmsNiv5
	, GgzDiagnoseCodeNiv6				as HuidigeGgzDiagnoseCodeNiv6
	, GgzDiagnoseOmsNiv6			as HuidigeGgzDiagnoseOmsNiv6

	from ssas_ggz.DimGgzDiagnose
