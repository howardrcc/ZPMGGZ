CREATE TABLE [dbo].[AppointmentClients] (
    [Id]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [AppointmentId]          BIGINT        NOT NULL,
    [ClientId]               BIGINT        NOT NULL,
    [Removed]                BIT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [Created]                DATETIME2 (7) NOT NULL,
    [LastModifiedBy]         NVARCHAR (50) NULL,
    [LastModified]           DATETIME2 (7) NULL,
    [PlannedDuration]        INT           DEFAULT ((0)) NOT NULL,
    [RealizedDuration]       INT           NULL,
    [ConfirmationSent]       DATETIME2 (7) NULL,
    [ReminderEmailSent]      DATETIME2 (7) NULL,
    [ReminderSmsSent]        DATETIME2 (7) NULL,
    [GlobalClientReportId]   BIGINT        NULL,
    [SpecificClientReportId] BIGINT        NULL,
    [ClientIdOld]            BIGINT        NULL,
    [Selected]               BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [IsNoShow]               BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_AppointmentClients] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);








GO



GO



GO



GO


