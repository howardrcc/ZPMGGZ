CREATE TABLE [dbo].[d_ggz_zorgprestatie] (
    [ggz_zorgprestatie_id]           INT           NOT NULL,
    [ggz_zorgprestatie_ok]           INT           NOT NULL,
    [zorgprestatie_code]             VARCHAR (10)  NOT NULL,
    [zorgprestatie_oms]              VARCHAR (200) NOT NULL,
    [zorgprestatiegroep_code]        VARCHAR (10)  NOT NULL,
    [zorgprestatiegroep_oms]         VARCHAR (64)  NOT NULL,
    [consult_type]                   VARCHAR (200) NOT NULL,
    [startdatum]                     DATETIME      NULL,
    [einddatum]                      DATETIME      NOT NULL,
    [tarief]                         INT           NOT NULL,
    [tarief_niveau]                  INT           NULL,
    [geldstroom]                     INT           NOT NULL,
    [setting_code]                   VARCHAR (10)  NULL,
    [beroepscategorie_code]          VARCHAR (10)  NULL,
    [duur_verrichting_minuten_vanaf] INT           NULL,
    [groeps_grootte]                 INT           NULL,
    [verblijf_niveau_zorg]           VARCHAR (40)  NULL,
    [verblijf_niveau_beveiliging]    INT           NULL,
    [creatie_datum]                  DATETIME      NOT NULL,
    [mutatie_datum]                  DATETIME      NOT NULL,
    [verwijderd_datum]               DATETIME      NULL
)
WITH (DATA_COMPRESSION = PAGE);

