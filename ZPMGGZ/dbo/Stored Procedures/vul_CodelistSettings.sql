CREATE      proc [dbo].[vul_CodelistSettings] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistSettings]

--SET IDENTITY_INSERT CodelistSettings on 


insert into CodelistSettings(
    
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
  --into CodelistSettings
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistSettings]

  --SET IDENTITY_INSERT CodelistSettings off