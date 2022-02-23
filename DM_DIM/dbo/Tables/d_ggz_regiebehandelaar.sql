CREATE TABLE [dbo].[d_ggz_regiebehandelaar] (
    [ggz_regiebehandelaar_id]   INT           NOT NULL,
    [ggz_regiebehandelaar_ok]   INT           NOT NULL,
    [ggz_regiebehandelaar_code] VARCHAR (16)  NULL,
    [ggz_regiebehandelaar_agb]  VARCHAR (16)  NULL,
    [ggz_regiebehandelaar_naam] VARCHAR (255) NULL,
    [creatie_datum]             DATETIME      NOT NULL,
    [mutatie_datum]             DATETIME      NOT NULL,
    [verwijderd_datum]          DATETIME      NULL,
    CONSTRAINT [PK_d_ggz_regiebehandelaar] PRIMARY KEY CLUSTERED ([ggz_regiebehandelaar_id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);

