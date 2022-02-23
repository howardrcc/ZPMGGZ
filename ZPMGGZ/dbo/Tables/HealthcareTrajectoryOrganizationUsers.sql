CREATE TABLE [dbo].[HealthcareTrajectoryOrganizationUsers] (
    [Id]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [HealthcareTrajectoryId] BIGINT        NOT NULL,
    [OrganizationUserId]     BIGINT        NOT NULL,
    [StartDate]              DATETIME2 (7) NOT NULL,
    [EndDate]                DATETIME2 (7) NULL,
    [Removed]                BIT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [Created]                DATETIME2 (7) NOT NULL,
    [LastModifiedBy]         NVARCHAR (50) NULL,
    [LastModified]           DATETIME2 (7) NULL
)
WITH (DATA_COMPRESSION = PAGE);

