CREATE TABLE [dbo].[OrganizationUsers] (
    [Id]                          BIGINT          NOT NULL,
    [CreatedBy]                   NVARCHAR (50)   NULL,
    [Created]                     DATETIME2 (7)   NOT NULL,
    [LastModifiedBy]              NVARCHAR (50)   NULL,
    [LastModified]                DATETIME2 (7)   NULL,
    [OrganizationId]              BIGINT          NOT NULL,
    [StartDate]                   DATETIME2 (7)   NOT NULL,
    [EndDate]                     DATETIME2 (7)   NULL,
    [Removed]                     BIT             NOT NULL,
    [ApplicationUserId]           NVARCHAR (450)  NULL,
    [ZorgMailAccountNumber]       NVARCHAR (50)   NULL,
    [ZorgMailUserName]            NVARCHAR (50)   NULL,
    [ZorgMailPassword]            VARBINARY (161) NULL,
    [Gender]                      TINYINT         NOT NULL,
    [HealthcareProviderAgbCode]   INT             NULL,
    [HealthcareProviderBigNumber] BIGINT          NULL,
    [HealthcareProviderCode]      NVARCHAR (50)   NULL,
    [IsHealthcareProvider]        BIT             NOT NULL,
    [FullName]                    NVARCHAR (50)   NOT NULL,
    [PhoneNumber]                 NVARCHAR (20)   NULL,
    [PhoneNumberMobile]           NVARCHAR (20)   NULL,
    [WorkEmail]                   NVARCHAR (100)  NULL,
    [ExternalId]                  NVARCHAR (50)   NULL
)
WITH (DATA_COMPRESSION = PAGE);

