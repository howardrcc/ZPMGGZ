CREATE TABLE [dbo].[OrganizationUsers] (
    [Id]                          BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreatedBy]                   NVARCHAR (50)  NULL,
    [Created]                     DATETIME2 (7)  NOT NULL,
    [LastModifiedBy]              NVARCHAR (50)  NULL,
    [LastModified]                DATETIME2 (7)  NULL,
    [OrganizationId]              BIGINT         DEFAULT (CONVERT([bigint],(0))) NOT NULL,
    [StartDate]                   DATETIME2 (7)  DEFAULT ('0001-01-01T00:00:00.0000000') NOT NULL,
    [EndDate]                     DATETIME2 (7)  NULL,
    [Removed]                     BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [ApplicationUserId]           NVARCHAR (450) NULL,
    [ZorgMailAccountNumber]       INT            NULL,
    [ZorgMailUserName]            NVARCHAR (50)  NULL,
    [ZorgMailPassword]            NVARCHAR (50)  COLLATE Latin1_General_BIN2 NULL,
    [Gender]                      TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [HealthcareProviderBigNumber] BIGINT         NULL,
    [HealthcareProviderCode]      NVARCHAR (50)  NULL,
    [IsHealthcareProvider]        BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [FullName]                    NVARCHAR (50)  DEFAULT (N'') NOT NULL,
    [PhoneNumber]                 NVARCHAR (20)  NULL,
    [PhoneNumberMobile]           NVARCHAR (20)  NULL,
    [WorkEmail]                   NVARCHAR (100) NULL,
    [ExternalId]                  BIGINT         NULL,
    [PersonalAccessTokenHash]     NVARCHAR (256) NULL,
    [Specialty]                   TINYINT        NULL,
    [Type]                        TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    CONSTRAINT [PK_OrganizationUsers] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);










GO



GO



GO


