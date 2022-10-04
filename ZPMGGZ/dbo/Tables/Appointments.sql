CREATE TABLE [dbo].[Appointments] (
    [Subject]                      NVARCHAR (100)   DEFAULT (N'') NOT NULL,
    [StartDateTime]                DATETIME2 (7)    NOT NULL,
    [EndDateTime]                  DATETIME2 (7)    NOT NULL,
    [Location]                     NVARCHAR (50)    NULL,
    [Description]                  NVARCHAR (MAX)   NULL,
    [RecurrenceID]                 BIGINT           NULL,
    [RecurrenceRule]               NVARCHAR (100)   NULL,
    [IsAllDay]                     BIT              DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [CreatedBy]                    NVARCHAR (50)    NULL,
    [Created]                      DATETIME2 (7)    NOT NULL,
    [LastModifiedBy]               NVARCHAR (50)    NULL,
    [LastModified]                 DATETIME2 (7)    NULL,
    [Removed]                      BIT              DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [OrganizationId]               BIGINT           DEFAULT (CONVERT([bigint],(0))) NOT NULL,
    [AppointmentCodeId]            BIGINT           NULL,
    [GlobalReportId]               BIGINT           NULL,
    [AppointmentNumber]            NVARCHAR (25)    NULL,
    [Id]                           BIGINT           IDENTITY (1, 1) NOT NULL,
    [ClientgroupId]                BIGINT           NULL,
    [IsProcessed]                  BIT              DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [OrganizationRegistrationType] INT              DEFAULT ((0)) NOT NULL,
    [AppointmentType]              TINYINT          NULL,
    [AppointmentConfirmationId]    BIGINT           NULL,
    [ClientReminderEmail]          BIT              DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [ClientReminderSms]            BIT              DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [VideoCallRoomId]              UNIQUEIDENTIFIER NULL,
    [VideoCallRoomPin]             INT              NULL,
    CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);








GO



GO



GO



GO



GO



GO


