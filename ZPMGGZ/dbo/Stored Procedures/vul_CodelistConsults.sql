CREATE        proc [dbo].[vul_CodelistConsults] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistConsults]

--SET IDENTITY_INSERT CodelistConsults on 


insert into CodelistConsults(
   [Id]
      ,[StartDate]
      ,[EndDate]
      ,[ActivityCode]
      ,[ConsultType]
      ,[DurationInMinutesFrom]
      ,[SettingCode]
      ,[ProfessionCategoryCode]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[FinanceStream]
      ,[TariffLevel]
)
SELECT 
 [Id]
      ,[StartDate]
      ,[EndDate]
      ,[ActivityCode]
      ,[ConsultType]
      ,[DurationInMinutesFrom]
      ,[SettingCode]
      ,[ProfessionCategoryCode]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[FinanceStream]
      ,[TariffLevel]
  --into CodelistConsults
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistConsults]

  --SET IDENTITY_INSERT CodelistConsults off