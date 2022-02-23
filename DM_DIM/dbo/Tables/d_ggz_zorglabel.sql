CREATE TABLE [dbo].[d_ggz_zorglabel] (
    [ggz_zorglabel_id]   INT           NOT NULL,
    [ggz_zorglabel_ok]   INT           NOT NULL,
    [ggz_zorglabel_code] VARCHAR (16)  NOT NULL,
    [ggz_zorglabel_oms]  VARCHAR (255) NOT NULL,
    [geldstroom]         SMALLINT      NULL,
    [creatie_datum]      DATETIME      NOT NULL,
    [mutatie_datum]      DATETIME      NOT NULL,
    [verwijderd_datum]   DATETIME      NULL
)
WITH (DATA_COMPRESSION = PAGE);

