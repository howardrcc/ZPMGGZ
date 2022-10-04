


CREATE     View [ssas_ggz].[DimGgzZorgprestatie] as

/*##
Historie

Datum				wie		wat
-----------------------------------------------------------------------------------------------------------------
2022-01-24			AL		consult type, zorgprestatiegroep code en oms toegevoegd
2022-01-14			AL		aangemaakt
-----------------------------------------------------------------------------------------------------------------

##*/
select
      [ggz_zorgprestatie_id]						as GgzZorgprestatieId 
	, [zorgprestatie_code]							as GgzZorgprestatieCode
	, [zorgprestatie_oms]							as GgzZorgprestatieOms
	, [zorgprestatiegroep_code]						as GgzZorgprestatieGroepCode
	, [zorgprestatiegroep_oms]						as GgzZorgprestatieGroepOms
	, consult_type									as GgzZorgprestatieConsultType
	, [startdatum]									as GgzZorgprestatieStartDatum
	, [einddatum]									as GgzZorgprestatieEindDatum
	, [tarief]										as GgzZorgprestatieMaxTarief
	, [tarief_niveau]								as GgzZorgprestatieTariefNiveau
	, [geldstroom]									as GgzZorgprestatieGeldstroom
	, [setting_code]								as GgzZorgprestatieSettingCode
	, [beroepscategorie_code]						as GgzZorgprestatieBeroepCatCode
	, [duur_verrichting_minuten_vanaf]				as GgzZorgprestatieDuurVerrichtingMinutenVanaf
	, [groeps_grootte]								as GgzZorgprestatieGroepsGrootte
	, [verblijf_niveau_zorg]						as GgzZorgprestatieVerblijfNiveauZorg
	, [verblijf_niveau_beveiliging]					as GgzZorgprestatieVerblijfNiveauBeveiliging

from [$(DM_DIM)].dbo.d_ggz_zorgprestatie
