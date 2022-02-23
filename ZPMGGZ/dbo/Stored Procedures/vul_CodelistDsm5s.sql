 
create       proc [dbo].[vul_CodelistDsm5s] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[CodelistDsm5s]

 


insert into CodelistDsm5s(
    
 [Id]
      ,[StartDate]
      ,[EndDate]
      ,[DiagnosisCode]
      ,[DiagnosisgroupCode]
      ,[Description]
      ,[HierarchyLevel]
      ,[Selectable]
      ,[RefCodeIcd9cm]
      ,[RefCodeIcd10]
      ,[ClaimType]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[SnomedCode]
  

)
 
   SELECT [Id]
      ,[StartDate]
      ,[EndDate]
      ,[DiagnosisCode]
      ,[DiagnosisgroupCode]
      ,[Description]
      ,[HierarchyLevel]
      ,[Selectable]
      ,[RefCodeIcd9cm]
      ,[RefCodeIcd10]
      ,[ClaimType]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[SnomedCode]

	--into CodelistDsm5s
    FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[CodelistDsm5s] a