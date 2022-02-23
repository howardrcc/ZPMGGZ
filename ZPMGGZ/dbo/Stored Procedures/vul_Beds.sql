create       proc [dbo].[vul_Beds] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[Beds]

 


insert into Beds(
    
[Id]
      ,[Code]
      ,[Name]
      ,[RoomId]
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
      ,[RoomId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[SettingCode]
	--into Beds
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[Beds]