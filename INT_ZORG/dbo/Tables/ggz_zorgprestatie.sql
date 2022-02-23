CREATE TABLE [dbo].[ggz_zorgprestatie] (
    [ggz_zorgprestatie_id]       INT           IDENTITY (1, 1) NOT NULL,
    [ggz_zorgprestatie_ok]       INT           NOT NULL,
    [ggz_traject_id]             INT           NOT NULL,
    [ggz_zorgprestatie_dim_id]   INT           NULL,
    [uitvoerder_zorgverlener_id] INT           NULL,
    [uitvoer_datumtijd]          SMALLDATETIME NULL,
    [duur_minuten]               INT           NULL,
    [duur_dagen]                 INT           NULL,
    [aantal]                     INT           NULL,
    [ggz_opname_id]              INT           NULL,
    [opname_nr]                  INT           NULL,
    [afspraak_nr]                INT           NULL,
    [duur_minuten_afspraak]      INT           NULL,
    [verzekeraar_id]             NUMERIC (18)  NULL,
    [creatie_datum]              DATETIME      NOT NULL,
    [mutatie_datum]              DATETIME      NOT NULL,
    [verwijderd_datum]           DATETIME      NULL,
    CONSTRAINT [PK_ggz_zorgprestatie_id] PRIMARY KEY CLUSTERED ([ggz_zorgprestatie_ok] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);

