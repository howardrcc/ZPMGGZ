create      proc [dbo].[vul_AppointmentClients] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[AppointmentClients]




insert into AppointmentClients(
    
     [Id]
      ,[AppointmentId]
      ,[ClientId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[PlannedDuration]
      ,[RealizedDuration]
      ,[ConfirmationSent]
      ,[ReminderEmailSent]
      ,[ReminderSmsSent]
      ,[GlobalClientReportId]
      ,[SpecificClientReportId]
      ,[ClientIdOld]
      ,[Selected]
      ,[IsNoShow]
  

)
SELECT 
      [Id]
      ,[AppointmentId]
      ,[ClientId]
      ,[Removed]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[PlannedDuration]
      ,[RealizedDuration]
      ,[ConfirmationSent]
      ,[ReminderEmailSent]
      ,[ReminderSmsSent]
      ,[GlobalClientReportId]
      ,[SpecificClientReportId]
      ,[ClientIdOld]
      ,[Selected]
      ,[IsNoShow]
     -- into AppointmentClients
  
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[AppointmentClients]

  --SET IDENTITY_INSERT AppointmentClients off