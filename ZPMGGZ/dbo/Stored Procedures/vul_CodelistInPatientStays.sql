CREATE        proc [dbo].[vul_CodelistInPatientStays] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistInPatientStays]

--SET IDENTITY_INSERT CodelistInPatientStays on 


insert into CodelistInPatientStays(
  [Id]
      ,[StartDate]
      ,[EndDate]
      ,[ActivityCode]
      ,[CareLevel]
      ,[SecurityLevel]
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
      ,[CareLevel]
      ,[SecurityLevel]
      ,[FinanceStream]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  --into CodelistInPatientStays
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistInPatientStays]

--  SET IDENTITY_INSERT CodelistInPatientStays off