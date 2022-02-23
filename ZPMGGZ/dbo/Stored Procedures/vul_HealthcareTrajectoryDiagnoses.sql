create     proc [dbo].[vul_HealthcareTrajectoryDiagnoses] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[HealthcareTrajectoryDiagnoses]

SET IDENTITY_INSERT HealthcareTrajectoryDiagnoses on 


insert into HealthcareTrajectoryDiagnoses(
    
    [Id]
      ,[StartDate]
      ,[EndDate]
      ,[DiagnosisId]
      ,[HealthcareTrajectoryId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]

)
SELECT 
     [Id]
      ,[StartDate]
      ,[EndDate]
      ,[DiagnosisId]
      ,[HealthcareTrajectoryId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[HealthcareTrajectoryDiagnoses]

  SET IDENTITY_INSERT HealthcareTrajectoryDiagnoses off