create   proc [dbo].[vul_HealthcareTrajectories] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[HealthcareTrajectories]

SET IDENTITY_INSERT HealthcareTrajectories on 


insert into HealthcareTrajectories(
    
     [Id]
      ,[ClientId]
      ,[RegistrationDate]
      ,[StartDate]
      ,[EndDate]
      ,[HealthcareTrajectoryNumber]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[OrganizationId]
      ,[Privacy]
      ,[ExternalInstitutionId]
      ,[FinanceType]
      ,[CodelistGbGgzProfileId]
      ,[CodelistReferrerTypeId]
      ,[ReferrerAgbCode]
      ,[ClientIdOld]
      ,[TariffLevel]
      ,[ExternalTrajectoryId]
  

)
SELECT [Id]
      ,[ClientId]
      ,[RegistrationDate]
      ,[StartDate]
      ,[EndDate]
      ,[HealthcareTrajectoryNumber]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[OrganizationId]
      ,[Privacy]
      ,[ExternalInstitutionId]
      ,[FinanceType]
      ,[CodelistGbGgzProfileId]
      ,[CodelistReferrerTypeId]
      ,[ReferrerAgbCode]
      ,[ClientIdOld]
      ,[TariffLevel]
      ,[ExternalTrajectoryId]
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[HealthcareTrajectories]

  SET IDENTITY_INSERT HealthcareTrajectories off