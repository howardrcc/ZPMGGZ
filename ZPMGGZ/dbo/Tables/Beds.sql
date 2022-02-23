CREATE TABLE [dbo].[Beds] (
    [Id]             BIGINT        NOT NULL,
    [Code]           NVARCHAR (25) NOT NULL,
    [Name]           NVARCHAR (50) NOT NULL,
    [RoomId]         BIGINT        NOT NULL,
    [Removed]        BIT           NOT NULL,
    [CreatedBy]      NVARCHAR (50) NULL,
    [Created]        DATETIME2 (7) NOT NULL,
    [LastModifiedBy] NVARCHAR (50) NULL,
    [LastModified]   DATETIME2 (7) NULL,
    [SettingCode]    NVARCHAR (10) NULL
)
WITH (DATA_COMPRESSION = PAGE);

