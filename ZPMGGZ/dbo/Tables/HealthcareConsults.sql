CREATE TABLE [dbo].[HealthcareConsults] (
    [Id]                           BIGINT         IDENTITY (1, 1) NOT NULL,
    [HealthcareTrajectoryId]       BIGINT         NOT NULL,
    [ConsultDateTime]              DATETIME2 (7)  NOT NULL,
    [OrganizationUserId]           BIGINT         NULL,
    [DurationInMinutes]            INT            NOT NULL,
    [HealthcareConsultType]        TINYINT        NOT NULL,
    [CodelistSettingId]            BIGINT         NULL,
    [Removed]                      BIT            NOT NULL,
    [CreatedBy]                    NVARCHAR (50)  NULL,
    [Created]                      DATETIME2 (7)  NOT NULL,
    [LastModifiedBy]               NVARCHAR (50)  NULL,
    [LastModified]                 DATETIME2 (7)  NULL,
    [DurationInDays]               INT            DEFAULT ((0)) NOT NULL,
    [DurationInUnits]              INT            DEFAULT ((0)) NOT NULL,
    [OrganizationId]               BIGINT         DEFAULT (CONVERT([bigint],(0))) NOT NULL,
    [ClientgroupRegistrationId]    BIGINT         NULL,
    [ClientReportId]               BIGINT         NULL,
    [AdmissionId]                  BIGINT         NULL,
    [BillingMethod]                TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [AppointmentId]                BIGINT         NULL,
    [OrganizationalUnitId]         BIGINT         NULL,
    [ClaimType]                    TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [InterpreterType]              TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [InvoiceState]                 TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [ExternalInstitutionId]        BIGINT         NULL,
    [NotBillableReason]            TINYINT        NULL,
    [Price]                        DECIMAL (6, 2) NULL,
    [CodelistActivityId]           BIGINT         NULL,
    [HealthInsurerId]              BIGINT         NULL,
    [OrganizationRegistrationType] INT            DEFAULT ((0)) NOT NULL,
    [PlannedDuration]              INT            DEFAULT ((0)) NOT NULL,
    [RealizedDuration]             INT            NULL,
    [SequenceNumber]               TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [PendingCredit]                BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [RequestorId]                  BIGINT         NULL,
    [CaredemandDeliveryId]         BIGINT         NULL,
    CONSTRAINT [PK_HealthcareConsults] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);














GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO



GO


