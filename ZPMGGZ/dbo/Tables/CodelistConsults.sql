CREATE TABLE [dbo].[CodelistConsults] (
    [Id]                     BIGINT        NOT NULL,
    [StartDate]              DATETIME2 (7) NOT NULL,
    [EndDate]                DATETIME2 (7) NULL,
    [ActivityCode]           NVARCHAR (10) NOT NULL,
    [ConsultType]            TINYINT       NOT NULL,
    [DurationInMinutesFrom]  INT           NOT NULL,
    [SettingCode]            NVARCHAR (10) NULL,
    [ProfessionCategoryCode] NVARCHAR (10) NULL,
    [Removed]                BIT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [Created]                DATETIME2 (7) NOT NULL,
    [LastModifiedBy]         NVARCHAR (50) NULL,
    [LastModified]           DATETIME2 (7) NULL,
    [FinanceStream]          TINYINT       NOT NULL,
    [TariffLevel]            TINYINT       NULL
)
WITH (DATA_COMPRESSION = PAGE);

