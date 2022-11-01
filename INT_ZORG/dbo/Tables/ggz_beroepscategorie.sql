CREATE TABLE [dbo].[ggz_beroepscategorie] (
    [ggz_beroepscategorie_id]   INT            IDENTITY (1, 1) NOT NULL,
    [ggz_beroepscategorie_ok]   BIGINT         NOT NULL,
    [ggz_beroepscategorie_code] NVARCHAR (10)  NOT NULL,
    [ggz_beroepscategorie_oms]  NVARCHAR (200) NOT NULL,
    [creatie_datum]             DATETIME       NOT NULL,
    [mutatie_datum]             DATETIME       NOT NULL,
    [verwijderd_datum]          DATETIME       NULL,
    CONSTRAINT [PK_ggz_ggz_beroepscategorie_id] PRIMARY KEY CLUSTERED ([ggz_beroepscategorie_ok] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);

