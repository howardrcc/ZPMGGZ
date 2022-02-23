CREATE      proc [dbo].[vul_OrganizationUsers] as 

/*###

wanneer     Wie     Wat
2022-01-07  Howard   Creatie
2022-02-18  Howard  [HealthcareProviderAgbCode] uit bron verwijderd

###*/


truncate table dbo.[OrganizationUsers]

 


insert into OrganizationUsers(
    
     [Id]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[OrganizationId]
      ,[StartDate]
      ,[EndDate]
      ,[Removed]
      ,[ApplicationUserId]
      ,[ZorgMailAccountNumber]
      ,[ZorgMailUserName]
      ,[ZorgMailPassword]
      ,[Gender]
      ,[HealthcareProviderAgbCode]
      ,[HealthcareProviderBigNumber]
      ,[HealthcareProviderCode]
      ,[IsHealthcareProvider]
      ,[FullName]
      ,[PhoneNumber]
      ,[PhoneNumberMobile]
      ,[WorkEmail]
      ,[ExternalId]
  

)
SELECT 
      [Id]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[OrganizationId]
      ,[StartDate]
      ,[EndDate]
      ,[Removed]
      ,[ApplicationUserId]
      ,[ZorgMailAccountNumber]
      ,[ZorgMailUserName]
      ,[ZorgMailPassword]
      ,[Gender]
      ,NULL as [HealthcareProviderAgbCode]
      ,[HealthcareProviderBigNumber]
      ,[HealthcareProviderCode]
      ,[IsHealthcareProvider]
      ,[FullName]
      ,[PhoneNumber]
      ,[PhoneNumberMobile]
      ,[WorkEmail]
      ,[ExternalId]
  --select * 
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[OrganizationUsers]