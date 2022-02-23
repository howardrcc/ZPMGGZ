CREATE TABLE [dbo].[ggz_traject] (
    [ggz_traject_id]          INT          IDENTITY (1, 1) NOT NULL,
    [ggz_traject_ok]          INT          NOT NULL,
    [ggz_dbc_id_oud]          INT          NULL,
    [patient_nr]              INT          NOT NULL,
    [ggz_diagnose_zpm_id]     INT          NULL,
    [ggz_regiebehandelaar_id] INT          NULL,
    [ggz_zorglabel_id]        INT          NULL,
    [startdatum]              DATETIME     NULL,
    [einddatum]               DATETIME     NULL,
    [registratiedatum]        DATETIME     NOT NULL,
    [privacy]                 BIT          NOT NULL,
    [financieel_type]         SMALLINT     NOT NULL,
    [ggz_verwijstype_id]      INT          NULL,
    [agb_verwijzer]           VARCHAR (12) NULL,
    [tariefniveau]            INT          NULL,
    [creatie_datum]           DATETIME     NOT NULL,
    [mutatie_datum]           DATETIME     NOT NULL,
    [verwijderd_datum]        DATETIME     NULL,
    CONSTRAINT [PK_ggz_traject_id] PRIMARY KEY CLUSTERED ([ggz_traject_ok] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);

