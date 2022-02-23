CREATE      proc [dbo].[vul_Appointments] as 

/*
Wanneer     Wie     Wat
2022-01-07  Howard   Creatie
2022-02-18  Howard   [AppointmentReportId] uit de bron gehaald

*/


truncate table dbo.[Appointments]



insert into Appointments(
    
    [Id]
      ,[ClientgroupId]
      ,[IsProcessed]
      ,[OrganizationRegistrationType]
      ,[AppointmentType]
      ,[AppointmentConfirmationId]
      ,[ClientReminderEmail]
      ,[ClientReminderSms]
      ,[VideoCallRoomId]
      ,[VideoCallRoomPin]
      ,[Subject]
      ,[StartDateTime]
      ,[EndDateTime]
      ,[Location]
      ,[Description]
      ,[RecurrenceID]
      ,[RecurrenceRule]
      ,[IsAllDay]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[Removed]
      ,[OrganizationId]
      ,[AppointmentCodeId]
      ,[AppointmentReportId]
      ,[AppointmentNumber]
  

)

SELECT 
      [Id]
      ,[ClientgroupId]
      ,[IsProcessed]
      ,[OrganizationRegistrationType]
      ,[AppointmentType]
      ,[AppointmentConfirmationId]
      ,[ClientReminderEmail]
      ,[ClientReminderSms]
      ,[VideoCallRoomId]
      ,[VideoCallRoomPin]
      ,[Subject]
      ,[StartDateTime]
      ,[EndDateTime]
      ,[Location]
      ,[Description]
      ,[RecurrenceID]
      ,[RecurrenceRule]
      ,[IsAllDay]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[Removed]
      ,[OrganizationId]
      ,[AppointmentCodeId]
      ,NULL as [AppointmentReportId]
      ,[AppointmentNumber]
  --into Appointments select *
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[Appointments]