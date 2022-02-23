CREATE TABLE [dbo].[ggz_opname] (
    [ggz_opname_id]    INT           IDENTITY (1, 1) NOT NULL,
    [ggz_opname_ok]    INT           NOT NULL,
    [opname_nr]        INT           NULL,
    [patient_nr]       VARCHAR (20)  NULL,
    [department_id]    INT           NULL,
    [kamer]            VARCHAR (50)  NULL,
    [bed]              VARCHAR (50)  NULL,
    [start_datumtijd]  SMALLDATETIME NULL,
    [eind_datumtijd]   SMALLDATETIME NULL,
    [creatie_datum]    DATETIME      NOT NULL,
    [mutatie_datum]    DATETIME      NOT NULL,
    [verwijderd_datum] DATETIME      NULL,
    CONSTRAINT [PK_ggz_opname] PRIMARY KEY CLUSTERED ([ggz_opname_ok] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);

