CREATE TABLE [dbo].[CodelistReferrerTypes] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [StartDate]       DATETIME2 (7)  NOT NULL,
    [EndDate]         DATETIME2 (7)  NULL,
    [Code]            NVARCHAR (10)  NOT NULL,
    [Name]            NVARCHAR (200) NOT NULL,
    [FinanceStream]   TINYINT        NOT NULL,
    [AgbCodeRequired] BIT            NOT NULL,
    [Removed]         BIT            NOT NULL,
    [CreatedBy]       NVARCHAR (50)  NULL,
    [Created]         DATETIME2 (7)  NOT NULL,
    [LastModifiedBy]  NVARCHAR (50)  NULL,
    [LastModified]    DATETIME2 (7)  NULL,
    CONSTRAINT [PK_CodelistReferrerTypes] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);







