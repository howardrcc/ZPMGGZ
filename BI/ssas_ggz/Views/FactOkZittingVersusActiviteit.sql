







CREATE           view [ssas_ggz].[FactOkZittingVersusActiviteit] as

/*## 

Historie

Datum       wie    wat
------------------------------------------------------------------- 

2022-02-04  BIA    aangemaakt
------------------------------------------------------------------- 

##*/
select
  OkZittingId
, OkZittingDatumId
, OkZittingSpecialismeId
, OkZittingDepartmentId
, OkZittingPatientId
, OkZittingKamerId
, OkZittingLogStatusId
, OkZittingAantalZittingen
, OkZittingOkInTijdId
, OkZittingOkTijd
, OkZittingAsaStatus
, OkZittingEersteVerrichting
, GgzActiviteitZorgverlenerId
, GgzActiviteitZorgprestatieDimId
, GgzActiviteitAantal


from ssas_pgs.FactOkZitting a
left outer join [ssas_ggz].FactGgzActiviteit b
  on a.OkZittingPatientId=b.GgzActiviteitPatientId
  and a.OkZittingDatumId=b.GgzActiviteitUitvoerdatumId

  left join pub.DimPeilmaand f
	    on b.GgzActiviteitPeilmaandId=f.PeilmaandId

where OkZittingSpecialismeId =44
and OkZittingLogStatusId in(3,4,6)
and GgzActiviteitZorgprestatieDimId in (1171,1172)
and OkZittingDatumId>=20220101
and (f.IsLaatstGeladenMaandJn = 'J'  OR f.IsLaatstGeladenMaandJn IS NULL)
