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
    [OrganizationId]             BIGINT           DEFAULT (CONVERT([bigint],(0))) NOT NULL,
    [Privacy]                    BIT              DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [ExternalInstitutionId]      BIGINT           NULL,
    [FinanceType]                TINYINT          DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [CodelistGbGgzProfileId]     BIGINT           NULL,
    [CodelistReferrerTypeId]     BIGINT           NULL,
    [ReferrerAgbCode]            INT              NULL,
    [ClientIdOld]                BIGINT           NULL,
    [TariffLevel]                TINYINT          DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [ExternalTrajectoryId]       BIGINT           NULL,
    [MunicipalityId]             BIGINT           NULL,
    CONSTRAINT [PK_HealthcareTrajectories] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
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


