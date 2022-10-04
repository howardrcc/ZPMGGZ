











CREATE           view [ssas_ggz].[DimPatientGGZ] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 
2022-24-03  HCC     PatientId IN -> GgzActiviteitPatientId 
2021-12-08   AL     aangemaakt
------------------------------------------------------------------- 

##*/
select
  PatientId
, PatientNr
, PatientGeboorteJaar
, PatientGeslacht
, PatientLeeftijdActueel
, PatientOverledenJn
, PatientOverlijdensJaar
, PatientHuisartsActueelId
, PatientPostcode4Id
, PatientZwangerschapsduurId
-- select count(*)
from ssas_pgs.DimPatient a
where a.PatientId in (select distinct GgzActiviteitPatientId from ssas_ggz.FactGgzActiviteit)
