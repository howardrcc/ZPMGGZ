CREATE        proc [dbo].[vul_CodelistActivities] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistActivities]

--SET IDENTITY_INSERT CodelistActivities on 


insert into CodelistActivities(
    [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Tariff]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[FinanceStream]
      ,[Name]
      ,[SnomedCode]
      ,[ActivityType]
      ,[TariffType]
  

)
SELECT 
        [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Tariff]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[FinanceStream]
      ,[Name]
      ,[SnomedCode]
      ,[ActivityType]
      ,[TariffType]
  --into CodelistActivities
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistActivities]

  --SET IDENTITY_INSERT CodelistActivities off