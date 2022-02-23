CREATE TABLE [dbo].[d_ggz_verwijstype] (
    [ggz_verwijstype_id] INT           IDENTITY (1, 1) NOT NULL,
    [verwijstype_code]   VARCHAR (10)  NOT NULL,
    [verwijstype_oms]    VARCHAR (255) NOT NULL,
    [startdatum]         DATE          NOT NULL,
    [einddatum]          DATE          NOT NULL,
    [agb_verplicht_jn]   CHAR (1)      NOT NULL,
    [bron]               VARCHAR (32)  NOT NULL,
    [creatie_datum]      DATETIME      NOT NULL,
    [mutatie_datum]      DATETIME      NOT NULL,
    [verwijderd_datum]   DATETIME      NULL,
    CONSTRAINT [PK_d_ggz_verwijstype] PRIMARY KEY CLUSTERED ([startdatum] ASC, [bron] ASC, [verwijstype_code] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE),
    CONSTRAINT [CK_d_ggz_verwijstype_startdatum_einddatum] CHECK ([startdatum]<=[einddatum])
);

