CREATE TABLE [dbo].[Admissions] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [OrganizationId]  BIGINT        NOT NULL,
    [ClientId]        BIGINT        NOT NULL,
    [AdmissionNumber] NVARCHAR (25) NOT NULL,
    [DepartmentId]    BIGINT        NOT NULL,
    [RoomId]          BIGINT        NULL,
    [BedId]           BIGINT        NULL,
    [StartDateTime]   DATETIME2 (7) NOT NULL,
    [EndDateTime]     DATETIME2 (7) NULL,
    [Removed]         BIT           NOT NULL,
    [CreatedBy]       NVARCHAR (50) NULL,
    [Created]         DATETIME2 (7) NOT NULL,
    [LastModifiedBy]  NVARCHAR (50) NULL,
    [LastModified]    DATETIME2 (7) NULL,
    [ClientIdOld]     BIGINT        NULL,
    CONSTRAINT [PK_Admissions] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
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


