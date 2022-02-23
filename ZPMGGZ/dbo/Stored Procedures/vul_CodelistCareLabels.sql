create         proc [dbo].[vul_CodelistCareLabels] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistCareLabels]

 


insert into CodelistCareLabels(
   
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
      ,[FinanceStream]
  

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
      ,[FinanceStream]
	--into CodelistCareLabels
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistCareLabels]