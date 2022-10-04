CREATE TABLE [dbo].[d_ggz_traject] (
    [ggz_traject_id]      INT          NOT NULL,
    [ggz_traject_ok]      INT          NOT NULL,
    [ggz_dbc_id_oud]      INT          NULL,
    [patient_id]          INT          NOT NULL,
    [ggz_zorglabel_id]    INT          NOT NULL,
    [ggz_verwijstype_id]  INT          NOT NULL,
    [startdatum_id]       INT          NOT NULL,
    [einddatum_id]        INT          NOT NULL,
    [registratiedatum_id] INT          NOT NULL,
    [agb_verwijzer]       VARCHAR (12) NULL,
    [tariefniveau]        INT          NULL,
    [creatie_datum]       DATETIME     NOT NULL,
    [mutatie_datum]       DATETIME     NOT NULL,
    [verwijderd_datum]    DATETIME     NULL,
    [agb_verwijzer_id]    INT          NULL,
    CONSTRAINT [PK_d_ggz_traject] PRIMARY KEY CLUSTERED ([ggz_traject_id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);



