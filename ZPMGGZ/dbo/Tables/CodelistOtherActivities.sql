CREATE TABLE [dbo].[CodelistOtherActivities] (
    [Id]                     BIGINT        IDENTITY (1, 1) NOT NULL,
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
    [ProfessionCategoryCode] NVARCHAR (10) NULL,
    CONSTRAINT [PK_CodelistOtherActivities] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);









