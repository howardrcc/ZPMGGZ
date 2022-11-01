CREATE TABLE [dbo].[f_ggz_zorgprestatie] (
    [peilmaand_id]                          INT             NOT NULL,
    [ggz_zorgprestatie_id]                  INT             NOT NULL,
    [patient_id]                            INT             NOT NULL,
    [ggz_zorgprestatie_dim_id]              INT             NOT NULL,
    [zorgverlener_id]                       INT             NOT NULL,
    [datum_id]                              INT             NOT NULL,
    [tijd_id]                               INT             NOT NULL,
    [duur_minuten]                          INT             NULL,
    [duur_dagen]                            INT             NULL,
    [aantal]                                INT             NULL,
    [omzetmaxtarief]                        DECIMAL (12, 2) NULL,
    [ggz_opname_id]                         INT             NULL,
    [opname_id_epic]                        INT             NULL,
    [afspraak_id_epic]                      INT             NULL,
    [maxtarief]                             INT             NULL,
    [normtijd_indirect]                     NUMERIC (7, 3)  NOT NULL,
    [doorberekende_directe_tijd]            NUMERIC (7, 3)  NULL,
    [directe_tijd_groepsconsulten]          NUMERIC (7, 3)  NULL,
    [verzekeraar_id]                        NUMERIC (18)    NULL,
    [klinisch_jn]                           VARCHAR (1)     NULL,
    [ggz_regiebehandelaar_id_zorgprestatie] INT             NULL,
    [ggz_diagnose_zpm_id_zorgprestatie]     INT             NULL,
    [ggz_zorgprestatie_dim_id_toeslag]      INT             DEFAULT ((-1)) NULL,
    [bedrag_toeslag]                        NUMERIC (12, 2) DEFAULT ((0.00)) NOT NULL,
    [bedrag_totaal]                         NUMERIC (12, 2) NOT NULL,
    [werknemer_id]                          VARCHAR (10)    NULL,
    [ggz_dbc_id_oud]                        INT             NULL,
    [traject_ggz_zorglabel_id]              INT             NULL,
    [traject_startdatum_id]                 INT             NULL,
    [traject_einddatum_id]                  INT             NULL,
    [traject_registratiedatum_id]           INT             NULL,
    [traject_agb_verwijzer]                 VARCHAR (12)    NULL,
    [traject_agb_verwijzer_id]              INT             NULL,
    [traject_ggz_verwijstype_id]            INT             NULL,
    [traject_tariefniveau]                  INT             NULL,
    [ggz_traject_id]                        INT             NULL,
    [HuidigeDiagnoseJn]                     VARCHAR (1)     NULL,
    [HuidigeRegiebehandelaarJn]             VARCHAR (1)     NULL,
    [HuidigeFaseInTraject]                  VARCHAR (14)    NULL,
    [gc_geen_tijd_ind]                      BIT             NULL,
    [verzekeraar_tarief]                    NUMERIC (12, 2) NULL,
    [diagnose_huidige_id]                   INT             NULL,
    [regiebehandelaar_huidige_id]           INT             NULL,
    [omzet_vz]                              DECIMAL (12, 2) NULL,
    [vz_tarief_ind]                         VARCHAR (1)     NULL,
    [ggz_toeslag_id]                        INT             DEFAULT ((0)) NOT NULL,
    [ggz_verzekeraar_id]                    INT             DEFAULT ((-1)) NOT NULL,
    [factuur_foutcode]                      INT             DEFAULT ((-1)) NOT NULL,
    [factuur_statuscode]                    INT             DEFAULT ((-1)) NOT NULL,
    [factuur_methodecode]                   INT             DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_f_ggz_zorgprestatie] PRIMARY KEY CLUSTERED ([peilmaand_id] ASC, [ggz_zorgprestatie_id] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);











