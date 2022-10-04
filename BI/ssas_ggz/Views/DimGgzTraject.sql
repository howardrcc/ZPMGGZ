




CREATE         View [ssas_ggz].[DimGgzTraject] as

/*##
Historie

Datum		Wie		wat
----------------------------------------------------------------------------------------------------------------------------
2022-01-20  AL		regiebehandelaar en zorglabel toegevoegd
2022-01-19	AL		Ok aangepast naar Code
2022-01-14	AL		aangemaakt
----------------------------------------------------------------------------------------------------------------------------

##*/
select
	  [ggz_traject_id]   			as GgzTrajectId
	, [ggz_traject_ok]				as GgzTrajectCode
	, [ggz_dbc_id_oud]				as GgzTrajectOudDbcId
	, [patient_id]					as GgzTrajectPatientId
	, [ggz_zorglabel_id]			as GgzTrajectZorglabelId
	, [startdatum_id]				as GgzTrajectStartDatumId
	, [einddatum_id]				as GgzTrajectEindDatumId
	, [registratiedatum_id]			as GgzTrajectRegistratieDatumId
	, [ggz_verwijstype_id]			as GgzTrajectVerwijzerId
	, [agb_verwijzer]				as GgzTrajectAgbVerwijzer
	, [tariefniveau]				as GgzTrajectTariefNiveau
	, [agb_verwijzer_id]			as GgzTrajectAgbVerwijzerId
	
from [$(DM_DIM)].dbo.d_ggz_traject
