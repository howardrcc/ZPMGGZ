create       proc [dbo].[vul_Departments] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[Departments]

 


insert into Departments(
    
  [Id]
      ,[Code]
      ,[Name]
      ,[IsMentalHealthcareDepartment]
      ,[OrganizationId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[SettingCode]
  

)
SELECT [Id]
      ,[Code]
      ,[Name]
      ,[IsMentalHealthcareDepartment]
      ,[OrganizationId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[SettingCode]
  --into Departments
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[Departments]