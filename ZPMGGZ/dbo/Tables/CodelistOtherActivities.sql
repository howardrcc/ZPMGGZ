CREATE TABLE [dbo].[CodelistOtherActivities] (
    [Id]                     BIGINT        NOT NULL,
    [StartDate]              DATETIME2 (7) NOT NULL,
    [EndDate]                DATETIME2 (7) NULL,
    [ActivityCode]           NVARCHAR (10) NOT NULL,
    [FinanceStream]          TINYINT       NOT NULL,
    [Removed]                BIT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [Created]                DATETIME2 (7) NOT NULL,
    [LastModifiedBy]         NVARCHAR (50) NULL,
    [LastModified]           DATETIME2 (7) NULL,
    [DurationInMinutesFrom]  INT           NOT NULL,
    [ProfessionCategoryCode] NVARCHAR (10) NULL
)
WITH (DATA_COMPRESSION = PAGE);

