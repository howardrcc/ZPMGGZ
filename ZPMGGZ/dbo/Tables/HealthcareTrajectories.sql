CREATE TABLE [dbo].[HealthcareTrajectories] (
    [Id]                         BIGINT           IDENTITY (1, 1) NOT NULL,
    [ClientId]                   BIGINT           NOT NULL,
    [RegistrationDate]           DATETIME2 (7)    NOT NULL,
    [StartDate]                  DATETIME2 (7)    NULL,
    [EndDate]                    DATETIME2 (7)    NULL,
    [HealthcareTrajectoryNumber] UNIQUEIDENTIFIER NOT NULL,
    [Removed]                    BIT              NOT NULL,
    [CreatedBy]                  NVARCHAR (50)    NULL,
    [Created]                    DATETIME2 (7)    NOT NULL,
    [LastModifiedBy]             NVARCHAR (50)    NULL,
    [LastModified]               DATETIME2 (7)    NULL,
    [OrganizationId]             BIGINT           NOT NULL,
    [Privacy]                    BIT              NOT NULL,
    [ExternalInstitutionId]      BIGINT           NULL,
    [FinanceType]                TINYINT          NOT NULL,
    [CodelistGbGgzProfileId]     BIGINT           NULL,
    [CodelistReferrerTypeId]     BIGINT           NULL,
    [ReferrerAgbCode]            VARCHAR (12)     NULL,
    [ClientIdOld]                BIGINT           NULL,
    [TariffLevel]                INT              NULL,
    [ExternalTrajectoryId]       BIGINT           NULL
)
WITH (DATA_COMPRESSION = PAGE);

