CREATE TABLE [dbo].[AppointmentClients] (
    [Id]                     INT           NOT NULL,
    [AppointmentId]          INT           NOT NULL,
    [ClientId]               INT           NOT NULL,
    [Removed]                BIT           NOT NULL,
    [CreatedBy]              VARCHAR (50)  NULL,
    [Created]                DATETIME2 (7) NOT NULL,
    [LastModifiedBy]         VARCHAR (50)  NULL,
    [LastModified]           DATETIME2 (7) NULL,
    [PlannedDuration]        INT           NOT NULL,
    [RealizedDuration]       INT           NULL,
    [ConfirmationSent]       DATETIME2 (7) NULL,
    [ReminderEmailSent]      DATETIME2 (7) NULL,
    [ReminderSmsSent]        DATETIME2 (7) NULL,
    [GlobalClientReportId]   INT           NULL,
    [SpecificClientReportId] INT           NULL,
    [ClientIdOld]            INT           NULL,
    [Selected]               BIT           NOT NULL,
    [IsNoShow]               BIT           NOT NULL
)
WITH (DATA_COMPRESSION = PAGE);

