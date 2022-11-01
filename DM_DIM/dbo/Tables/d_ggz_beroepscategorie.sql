CREATE TABLE [dbo].[d_ggz_beroepscategorie] (
    [ggz_beroepscategorie_id]   INT           NOT NULL,
    [ggz_beroepscategorie_ok]   INT           NOT NULL,
    [ggz_beroepscategorie_code] VARCHAR (16)  NOT NULL,
    [ggz_beroepscategorie_oms]  VARCHAR (255) NOT NULL,
    [creatie_datum]             DATETIME      NOT NULL,
    [mutatie_datum]             DATETIME      NOT NULL,
    [verwijderd_datum]          DATETIME      NULL
)
WITH (DATA_COMPRESSION = PAGE);

