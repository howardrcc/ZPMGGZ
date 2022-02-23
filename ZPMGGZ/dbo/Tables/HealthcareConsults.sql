CREATE TABLE [dbo].[HealthcareConsults] (
    [Id]                        BIGINT        IDENTITY (1, 1) NOT NULL,
    [HealthcareTrajectoryId]    BIGINT        NOT NULL,
    [ConsultDateTime]           DATETIME2 (7) NOT NULL,
    [OrganizationUserId]        BIGINT        NULL,
    [DurationInMinutes]         INT           NOT NULL,
    [HealthcareConsultType]     TINYINT       NOT NULL,
    [CodelistSettingId]         BIGINT        NULL,
    [Removed]                   BIT           NOT NULL,
    [CreatedBy]                 NVARCHAR (50) NULL,
    [Created]                   DATETIME2 (7) NOT NULL,
    [LastModifiedBy]            NVARCHAR (50) NULL,
    [LastModified]              DATETIME2 (7) NULL,
    [DurationInDays]            INT           NOT NULL,
    [DurationInUnits]           INT           NOT NULL,
    [OrganizationId]            BIGINT        NOT NULL,
    [ActivityCode]              NVARCHAR (10) NULL,
    [ClientgroupRegistrationId] BIGINT        NULL,
    [ClientReportId]            BIGINT        NULL,
    [AdmissionId]               BIGINT        NULL,
    [BillingMethod]             TINYINT       NOT NULL,
    [AppointmentId]             BIGINT        NULL,
    [OrganizationalUnitId]      BIGINT        NULL,
    [ClaimType]                 TINYINT       NOT NULL,
    [InterpreterType]           TINYINT       NOT NULL
)
WITH (DATA_COMPRESSION = PAGE);

