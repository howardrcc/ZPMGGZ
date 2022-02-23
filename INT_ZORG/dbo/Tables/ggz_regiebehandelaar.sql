CREATE TABLE [dbo].[ggz_regiebehandelaar] (
    [ggz_regiebehandelaar_id]   INT           IDENTITY (1, 1) NOT NULL,
    [ggz_regiebehandelaar_ok]   INT           NOT NULL,
    [ggz_regiebehandelaar_code] VARCHAR (16)  NULL,
    [ggz_regiebehandelaar_agb]  VARCHAR (16)  NULL,
    [ggz_regiebehandelaar_naam] VARCHAR (255) NULL,
    [creatie_datum]             DATETIME      NOT NULL,
    [mutatie_datum]             DATETIME      NOT NULL,
    [verwijderd_datum]          DATETIME      NULL
)
WITH (DATA_COMPRESSION = PAGE);

