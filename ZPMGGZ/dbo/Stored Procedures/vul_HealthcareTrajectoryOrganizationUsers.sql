create     proc [dbo].[vul_HealthcareTrajectoryOrganizationUsers] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[HealthcareTrajectoryOrganizationUsers]

SET IDENTITY_INSERT HealthcareTrajectoryOrganizationUsers on 


insert into HealthcareTrajectoryOrganizationUsers(
    
    [Id]
      ,[HealthcareTrajectoryId]
      ,[OrganizationUserId]
      ,[StartDate]
      ,[EndDate]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  

)
SELECT 
        [Id]
      ,[HealthcareTrajectoryId]
      ,[OrganizationUserId]
      ,[StartDate]
      ,[EndDate]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[HealthcareTrajectoryOrganizationUsers]

  SET IDENTITY_INSERT HealthcareTrajectoryOrganizationUsers off