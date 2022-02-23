CREATE TABLE [dbo].[ggz_afspraak] (
    [ggz_afspraak_id]          INT          IDENTITY (1, 1) NOT NULL,
    [ggz_afspraak_ok]          INT          NOT NULL,
    [patient_id]               VARCHAR (18) NOT NULL,
    [duur_minuten_geplanned]   INT          NOT NULL,
    [duur_minuten_realisatie]  INT          NULL,
    [start_afspraak_datumtijd] DATETIME     NULL,
    [eind_afspraak_datumtijd]  DATETIME     NULL,
    [afspraak_nr_epic]         INT          NULL,
    [creatie_datum]            DATETIME     NOT NULL,
    [mutatie_datum]            DATETIME     NOT NULL,
    [verwijderd_datum]         DATETIME     NULL,
    CONSTRAINT [PK_ggz_afspraak_id] PRIMARY KEY CLUSTERED ([ggz_afspraak_ok] ASC, [patient_id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);

