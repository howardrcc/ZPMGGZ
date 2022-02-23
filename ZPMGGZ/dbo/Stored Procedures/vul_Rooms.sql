create       proc [dbo].[vul_Rooms] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[Rooms]

 


insert into Rooms(
    
[Id]
      ,[Code]
      ,[Name]
      ,[DepartmentId]
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
      ,[DepartmentId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[SettingCode]
	--into Rooms
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[Rooms]