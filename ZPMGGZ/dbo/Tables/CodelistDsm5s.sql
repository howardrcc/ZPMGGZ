CREATE TABLE [dbo].[CodelistDsm5s] (
    [Id]                 BIGINT         NOT NULL,
    [StartDate]          DATETIME2 (7)  NOT NULL,
    [EndDate]            DATETIME2 (7)  NULL,
    [DiagnosisCode]      NVARCHAR (30)  NOT NULL,
    [DiagnosisgroupCode] NVARCHAR (30)  NOT NULL,
    [Description]        NVARCHAR (200) NOT NULL,
    [HierarchyLevel]     TINYINT        NOT NULL,
    [Selectable]         TINYINT        NOT NULL,
    [RefCodeIcd9cm]      NVARCHAR (8)   NULL,
    [RefCodeIcd10]       NVARCHAR (8)   NULL,
    [ClaimType]          TINYINT        NOT NULL,
    [Removed]            BIT            NOT NULL,
    [CreatedBy]          NVARCHAR (50)  NULL,
    [Created]            DATETIME2 (7)  NOT NULL,
    [LastModifiedBy]     NVARCHAR (50)  NULL,
    [LastModified]       DATETIME2 (7)  NULL,
    [SnomedCode]         NVARCHAR (20)  NOT NULL
)
WITH (DATA_COMPRESSION = PAGE);

