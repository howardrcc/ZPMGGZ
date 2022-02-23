create         proc [dbo].[vul_CodelistCareLabelHealthcareTrajectories] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistCareLabelHealthcareTrajectories]

 


insert into CodelistCareLabelHealthcareTrajectories(
   
 [CodelistCareLabelsId]
      ,[HealthcareTrajectoriesId]
  

)
 
 SELECT 
       [CodelistCareLabelsId]
      ,[HealthcareTrajectoriesId]
	--into CodelistCareLabelHealthcareTrajectories
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistCareLabelHealthcareTrajectories]