CREATE TABLE [dbo].[ggz_zorglabel] (
    [ggz_zorglabel_id]   INT           IDENTITY (1, 1) NOT NULL,
    [ggz_zorglabel_ok]   INT           NOT NULL,
    [ggz_zorglabel_code] VARCHAR (16)  NOT NULL,
    [ggz_zorglabel_oms]  VARCHAR (200) NOT NULL,
    [startdatum]         DATETIME      NOT NULL,
    [einddatum]          DATETIME      NULL,
    [geldstroom]         TINYINT       NOT NULL,
    [creatie_datum]      DATETIME      NOT NULL,
    [mutatie_datum]      DATETIME      NOT NULL,
    [verwijderd_datum]   DATETIME      NULL
)
WITH (DATA_COMPRESSION = PAGE);

