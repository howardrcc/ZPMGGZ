CREATE        proc [dbo].[vul_CodelistGroupConsults] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistGroupConsults]

--SET IDENTITY_INSERT CodelistGroupConsults on 


insert into CodelistGroupConsults(
     [Id]
      ,[StartDate]
      ,[EndDate]
      ,[ActivityCode]
      ,[GroupSize]
      ,[BlockLengthMinutes]
      ,[ProfessionCategoryCode]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[FinanceStream]
)
SELECT 
    [Id]
      ,[StartDate]
      ,[EndDate]
      ,[ActivityCode]
      ,[GroupSize]
      ,[BlockLengthMinutes]
      ,[ProfessionCategoryCode]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[FinanceStream]
  --into CodelistGroupConsults
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistGroupConsults]

  --SET IDENTITY_INSERT CodelistGroupConsults off