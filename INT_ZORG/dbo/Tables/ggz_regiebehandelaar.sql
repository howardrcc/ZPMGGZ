CREATE TABLE [dbo].[ggz_regiebehandelaar] (
    [ggz_regiebehandelaar_id]   INT           IDENTITY (1, 1) NOT NULL,
    [ggz_regiebehandelaar_ok]   INT           NOT NULL,
    [ggz_regiebehandelaar_code] VARCHAR (16)  NULL,
    [ggz_regiebehandelaar_agb]  VARCHAR (16)  NULL,
    [ggz_regiebehandelaar_naam] VARCHAR (255) NULL,
    [beroep_code]               VARCHAR (20)  NULL,
    [beroep_oms]                VARCHAR (255) NULL,
    [beroepscategorie_code]     VARCHAR (20)  NULL,
    [beroepscategorie_oms]      VARCHAR (255) NULL,
    [startdatum]                DATETIME      NOT NULL,
    [einddatum]                 DATETIME      NOT NULL,
    [creatie_datum]             DATETIME      NOT NULL,
    [mutatie_datum]             DATETIME      NOT NULL,
    [verwijderd_datum]          DATETIME      NULL
)
WITH (DATA_COMPRESSION = PAGE);

