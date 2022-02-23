CREATE        proc [dbo].[vul_CodelistReferrerTypes] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistReferrerTypes]

--SET IDENTITY_INSERT CodelistReferrerTypes on 


insert into CodelistReferrerTypes(
    [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Name]
      ,[FinanceStream]
      ,[AgbCodeRequired]
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
      ,[Code]
      ,[Name]
      ,[FinanceStream]
      ,[AgbCodeRequired]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  --into CodelistReferrerTypes
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistReferrerTypes]

  --SET IDENTITY_INSERT CodelistReferrerTypes off