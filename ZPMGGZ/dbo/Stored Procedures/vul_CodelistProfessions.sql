CREATE        proc [dbo].[vul_CodelistProfessions] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistProfessions]

--SET IDENTITY_INSERT CodelistProfessions on 


insert into CodelistProfessions(
    [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Name]
      ,[ProfessionCategoryCode]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[OccupationalTherapy]
)
SELECT 
       [Id]
      ,[StartDate]
      ,[EndDate]
      ,[Code]
      ,[Name]
      ,[ProfessionCategoryCode]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[OccupationalTherapy]
  --into CodelistProfessions
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistProfessions]

--  SET IDENTITY_INSERT CodelistProfessions off