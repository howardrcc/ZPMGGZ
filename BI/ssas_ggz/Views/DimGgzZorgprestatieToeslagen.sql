



CREATE     View [ssas_ggz].[DimGgzZorgprestatieToeslagen] as

/*##
Historie

Datum				wie		wat
-----------------------------------------------------------------------------------------------------------------
2022-01-24			AL		consult type, zorgprestatiegroep code en oms toegevoegd
2022-01-14			AL		aangemaakt
-----------------------------------------------------------------------------------------------------------------

##*/
select
      GgzZorgprestatieId										as GgzZorgprestatieToeslagId
	, GgzZorgprestatieCode										as GgzZorgprestatieToeslagCode
	, GgzZorgprestatieOms										as GgzZorgprestatieToeslagOms
	, GgzZorgprestatieGroepCode									as GgzZorgprestatieToeslagGroepCode
	, GgzZorgprestatieGroepOms									as GgzZorgprestatieToeslagGroepOms
	, GgzZorgprestatieConsultType								as GgzZorgprestatieToeslagConsultType
	, GgzZorgprestatieStartDatum								as GgzZorgprestatieToeslagStartDatum
	, GgzZorgprestatieEindDatum									as GgzZorgprestatieToeslagEindDatum
	, GgzZorgprestatieMaxTarief									as GgzZorgprestatieToeslagMaxTarief
	, GgzZorgprestatieTariefNiveau								as GgzZorgprestatieToeslagTariefNiveau
	, GgzZorgprestatieGeldstroom								as GgzZorgprestatieToeslagGeldstroom
	, GgzZorgprestatieSettingCode								as GgzZorgprestatieToeslagSettingCode
	, GgzZorgprestatieBeroepCatCode								as GgzZorgprestatieToeslagBeroepCatCode
	, GgzZorgprestatieDuurVerrichtingMinutenVanaf				as GgzZorgprestatieToeslagDuurVerrichtingMinutenVanaf
	, GgzZorgprestatieGroepsGrootte								as GgzZorgprestatieToeslagGroepsGrootte
	, GgzZorgprestatieVerblijfNiveauZorg						as GgzZorgprestatieToeslagVerblijfNiveauZorg
	, GgzZorgprestatieVerblijfNiveauBeveiliging					as GgzZorgprestatieToeslagVerblijfNiveauBeveiliging

from ssas_ggz.DimGgzZorgprestatie
