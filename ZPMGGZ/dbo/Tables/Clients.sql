CREATE TABLE [dbo].[Clients] (
    [Id]                                BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreatedBy]                         NVARCHAR (50)  NULL,
    [Created]                           DATETIME2 (7)  NOT NULL,
    [LastModifiedBy]                    NVARCHAR (50)  NULL,
    [LastModified]                      DATETIME2 (7)  NULL,
    [ClientNumber]                      NVARCHAR (20)  DEFAULT (N'') NOT NULL,
    [NationalIdentifier]                INT            NULL,
    [BirthName]                         NVARCHAR (25)  NULL,
    [Initials]                          NVARCHAR (6)   NULL,
    [FirstName]                         NVARCHAR (50)  NULL,
    [PartnerName]                       NVARCHAR (25)  NULL,
    [PrefixPartnerName]                 NVARCHAR (10)  NULL,
    [Street]                            NVARCHAR (100) NULL,
    [HouseNumber]                       INT            NULL,
    [HouseNumberAddition]               NVARCHAR (6)   NULL,
    [PostalCode]                        NVARCHAR (10)  NULL,
    [City]                              NVARCHAR (50)  NULL,
    [Gender]                            TINYINT        NOT NULL,
    [DateOfBirth]                       DATETIME2 (7)  NULL,
    [PhoneNumber]                       NVARCHAR (20)  NULL,
    [Deceased]                          BIT            NOT NULL,
    [Removed]                           BIT            NOT NULL,
    [OrganizationId]                    BIGINT         DEFAULT (CONVERT([bigint],(0))) NOT NULL,
    [CorrespondenceStreet]              NVARCHAR (100) NULL,
    [CorrespondenceCity]                NVARCHAR (50)  NULL,
    [CorrespondenceCountryId]           INT            NULL,
    [CorrespondencePostalCode]          NVARCHAR (10)  NULL,
    [CorresponenceAttentionOf]          NVARCHAR (50)  NULL,
    [CountryId]                         INT            NULL,
    [Email]                             NVARCHAR (100) NULL,
    [PhoneNumberMobile]                 NVARCHAR (20)  NULL,
    [ValidationError]                   BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [PhoneNumberWork]                   NVARCHAR (20)  NULL,
    [PrefixBirthName]                   NVARCHAR (10)  NULL,
    [Title]                             TINYINT        DEFAULT (CONVERT([tinyint],(0))) NOT NULL,
    [DateOfDeath]                       DATETIME2 (7)  NULL,
    [UseDifferentCorrespondenceAddress] BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [CorrespondenceHouseNumber]         INT            NULL,
    [CorrespondenceHouseNumberAddition] NVARCHAR (6)   NULL,
    [FullName]                          NVARCHAR (73)  NULL,
    [ExternalId]                        BIGINT         NULL,
    [LegalStatus]                       TINYINT        NULL,
    [MaritalStatus]                     TINYINT        NULL,
    [ClientReportId]                    BIGINT         NULL,
    CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);












GO



GO



GO



GO



GO


