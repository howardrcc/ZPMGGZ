CREATE TABLE [dbo].[HealthcareTrajectoryDiagnoses] (
    [Id]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [StartDate]              DATETIME2 (7) NOT NULL,
    [EndDate]                DATETIME2 (7) NULL,
    [DiagnosisId]            BIGINT        DEFAULT (CONVERT([bigint],(0))) NOT NULL,
    [HealthcareTrajectoryId] BIGINT        NOT NULL,
    [Removed]                BIT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [Created]                DATETIME2 (7) NOT NULL,
    [LastModifiedBy]         NVARCHAR (50) NULL,
    [LastModified]           DATETIME2 (7) NULL,
    [VerificationStatus]     TINYINT       NULL,
    CONSTRAINT [PK_HealthcareTrajectoryDiagnoses] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);










GO



GO



GO


