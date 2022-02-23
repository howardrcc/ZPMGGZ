create        proc [dbo].[vul_CodelistSurchargeInPatientStays] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistSurchargeInPatientStays]

--SET IDENTITY_INSERT CodelistSurchargeInPatientStays on 


insert into CodelistSurchargeInPatientStays(
[Id]
      ,[StartDate]
      ,[EndDate]
      ,[ActivityCode]
      ,[FinanceStream]
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
      ,[ActivityCode]
      ,[FinanceStream]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  --into CodelistSurchargeInPatientStays
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistSurchargeInPatientStays]

--  SET IDENTITY_INSERT CodelistSurchargeInPatientStays off