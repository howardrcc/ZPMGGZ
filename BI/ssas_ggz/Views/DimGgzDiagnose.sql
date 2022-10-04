

CREATE   VIEW [ssas_ggz].[DimGgzDiagnose]	as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-01-14	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select

	  [ggz_diagnose_zpm_id]				as GgzDiagnoseId
	, [startdatum]						as GgzDiagnoseStartDatum
	, [einddatum]						as GgzDiagnoseEindDatum
	, [diagnose_code]					as GgzDiagnoseCode
	, [diagnose_oms]					as GgzDiagnoseOms
	, [hierarchie]						as GgzDiagnoseHierarchie
	, [icd9]							as GgzDiagnoseIcd9
	, [icd10]							as GgzDiagnoseIcd10
	, [niv1_diagnose_code]				as GgzDiagnoseCodeNiv1
	, [niv1_diagnose_oms]				as GgzDiagnoseOmsNiv1
	, [niv2_diagnose_code]				as GgzDiagnoseCodeNiv2
	, [niv2_diagnose_oms]				as GgzDiagnoseOmsNiv2
	, [niv3_diagnose_code]				as GgzDiagnoseCodeNiv3
	, [niv3_diagnose_oms]				as GgzDiagnoseOmsNiv3
	, [niv4_diagnose_code]				as GgzDiagnoseCodeNiv4
	, [niv4_diagnose_oms]				as GgzDiagnoseOmsNiv4
	, [niv5_diagnose_code]				as GgzDiagnoseCodeNiv5
	, [niv5_diagnose_oms]				as GgzDiagnoseOmsNiv5
	, [niv6_diagnose_code]				as GgzDiagnoseCodeNiv6
	, [niv6_diagnose_oms]				as GgzDiagnoseOmsNiv6

	from [$(DM_DIM)].dbo.d_ggz_diagnose_zpm
