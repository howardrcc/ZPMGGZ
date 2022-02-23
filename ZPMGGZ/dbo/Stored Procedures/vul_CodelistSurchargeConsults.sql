CREATE        proc [dbo].[vul_CodelistSurchargeConsults] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistSurchargeConsults]

--SET IDENTITY_INSERT CodelistSurchargeConsults on 


insert into CodelistSurchargeConsults(
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
  --into CodelistSurchargeConsults
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistSurchargeConsults]

--  SET IDENTITY_INSERT CodelistSurchargeConsults off