CREATE TABLE [dbo].[CodelistCareLabelHealthcareConsults] (
    [CodelistCareLabelsId] BIGINT NOT NULL,
    [HealthcareConsultsId] BIGINT NOT NULL,
    CONSTRAINT [PK_CodelistCareLabelHealthcareConsults] PRIMARY KEY CLUSTERED ([CodelistCareLabelsId] ASC, [HealthcareConsultsId] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);










GO


