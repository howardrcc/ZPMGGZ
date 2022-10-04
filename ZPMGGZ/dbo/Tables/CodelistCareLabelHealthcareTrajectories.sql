CREATE TABLE [dbo].[CodelistCareLabelHealthcareTrajectories] (
    [CodelistCareLabelsId]     BIGINT NOT NULL,
    [HealthcareTrajectoriesId] BIGINT NOT NULL,
    CONSTRAINT [PK_CodelistCareLabelHealthcareTrajectories] PRIMARY KEY CLUSTERED ([CodelistCareLabelsId] ASC, [HealthcareTrajectoriesId] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);










GO


