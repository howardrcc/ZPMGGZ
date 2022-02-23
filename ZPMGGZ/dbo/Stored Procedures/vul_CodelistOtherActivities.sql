CREATE        proc [dbo].[vul_CodelistOtherActivities] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistOtherActivities]

--SET IDENTITY_INSERT CodelistOtherActivities on 


insert into CodelistOtherActivities(
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
      ,[DurationInMinutesFrom]
      ,[ProfessionCategoryCode]
  

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
      ,[DurationInMinutesFrom]
      ,[ProfessionCategoryCode]
  --into CodelistOtherActivities
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistOtherActivities]

--  SET IDENTITY_INSERT CodelistOtherActivities off