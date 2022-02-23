create     proc [dbo].[vul_Admissions] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[Admissions]

SET IDENTITY_INSERT Admissions on 


insert into Admissions(
    
     [Id]
      ,[OrganizationId]
      ,[ClientId]
      ,[AdmissionNumber]
      ,[DepartmentId]
      ,[RoomId]
      ,[BedId]
      ,[StartDateTime]
      ,[EndDateTime]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[ClientIdOld]
  

)
SELECT 
       [Id]
      ,[OrganizationId]
      ,[ClientId]
      ,[AdmissionNumber]
      ,[DepartmentId]
      ,[RoomId]
      ,[BedId]
      ,[StartDateTime]
      ,[EndDateTime]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[ClientIdOld]
  
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[Admissions]

  SET IDENTITY_INSERT Admissions off