create         proc [dbo].[vul_CodelistCareLabelHealthcareConsults] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistCareLabelHealthcareConsults]

 


insert into CodelistCareLabelHealthcareConsults(
   
[CodelistCareLabelsId]
      ,[HealthcareConsultsId]
  

)
 
 SELECT 
      [CodelistCareLabelsId]
      ,[HealthcareConsultsId]
	--into CodelistCareLabelHealthcareConsults
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistCareLabelHealthcareConsults]