CREATE   proc [dbo].[vul_HealthcareConsults] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[HealthcareConsults]

SET IDENTITY_INSERT HealthcareConsults on 


insert into HealthcareConsults(
    
    [Id]
      ,[HealthcareTrajectoryId]
      ,[ConsultDateTime]
      ,[OrganizationUserId]
      ,[DurationInMinutes]
      ,[HealthcareConsultType]
      ,[CodelistSettingId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[DurationInDays]
      ,[DurationInUnits]
      ,[OrganizationId]
      ,[ActivityCode]
      ,[ClientgroupRegistrationId]
      ,[ClientReportId]
      ,[AdmissionId]
      ,[BillingMethod]
      ,[AppointmentId]
      ,[OrganizationalUnitId]
      ,[ClaimType]
      ,[InterpreterType]
  

)
SELECT [Id]
      ,[HealthcareTrajectoryId]
      ,[ConsultDateTime]
      ,[OrganizationUserId]
      ,[DurationInMinutes]
      ,[HealthcareConsultType]
      ,[CodelistSettingId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[DurationInDays]
      ,[DurationInUnits]
      ,[OrganizationId]
      ,[ActivityCode]
      ,[ClientgroupRegistrationId]
      ,[ClientReportId]
      ,[AdmissionId]
      ,[BillingMethod]
      ,[AppointmentId]
      ,[OrganizationalUnitId]
      ,[ClaimType]
      ,[InterpreterType]
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[HealthcareConsults]

  SET IDENTITY_INSERT HealthcareConsults off