CREATE TABLE [dbo].[OrganizationUserProfessions] (
    [Id]                 BIGINT        NOT NULL,
    [OrganizationUserId] BIGINT        NOT NULL,
    [ProfessionId]       BIGINT        NOT NULL,
    [StartDate]          DATETIME2 (7) NOT NULL,
    [EndDate]            DATETIME2 (7) NULL,
    [Removed]            BIT           NOT NULL,
    [CreatedBy]          NVARCHAR (50) NULL,
    [Created]            DATETIME2 (7) NOT NULL,
    [LastModifiedBy]     NVARCHAR (50) NULL,
    [LastModified]       DATETIME2 (7) NULL
)
WITH (DATA_COMPRESSION = PAGE);

