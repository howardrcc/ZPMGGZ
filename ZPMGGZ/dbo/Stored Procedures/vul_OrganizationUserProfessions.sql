CREATE      proc [dbo].[vul_OrganizationUserProfessions] as 

/*

2022-01-07 Howard   Creatie


*/
 

truncate table dbo.[OrganizationUserProfessions]

 


insert into OrganizationUserProfessions(
    
    [Id]
      ,[OrganizationUserId]
      ,[ProfessionId]
      ,[StartDate]
      ,[EndDate]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  

)
SELECT 
      [Id]
      ,[OrganizationUserId]
      ,[ProfessionId]
      ,[StartDate]
      ,[EndDate]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
  --into OrganizationUserProfessions
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[OrganizationUserProfessions]