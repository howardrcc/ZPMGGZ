CREATE        proc [dbo].[vul_CodelistProfessionCategories] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistProfessionCategories]

--SET IDENTITY_INSERT CodelistProfessionCategories on 


insert into CodelistProfessionCategories(
    [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[Name]
)
SELECT 
        [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[Name]
  --into CodelistProfessionCategories
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistProfessionCategories]

  --SET IDENTITY_INSERT CodelistProfessionCategories off