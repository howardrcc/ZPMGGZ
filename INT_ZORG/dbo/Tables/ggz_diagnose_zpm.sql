﻿CREATE TABLE [dbo].[ggz_diagnose_zpm] (
    [ggz_diagnose_zpm_id] INT           IDENTITY (1, 1) NOT NULL,
    [ggz_diagnose_zpm_ok] INT           NOT NULL,
    [startdatum]          DATETIME      NULL,
    [einddatum]           DATETIME      NULL,
    [diagnose_code]       VARCHAR (30)  NULL,
    [diagnosegroep_code]  VARCHAR (30)  NULL,
    [diagnose_oms]        VARCHAR (200) NULL,
    [hierarchie]          SMALLINT      NULL,
    [icd9]                VARCHAR (8)   NULL,
    [icd10]               VARCHAR (8)   NULL,
    [niv1_diagnose_code]  VARCHAR (30)  NOT NULL,
    [niv1_diagnose_oms]   VARCHAR (200) NOT NULL,
    [niv2_diagnose_code]  VARCHAR (30)  NULL,
    [niv2_diagnose_oms]   VARCHAR (200) NULL,
    [niv3_diagnose_code]  VARCHAR (30)  NULL,
    [niv3_diagnose_oms]   VARCHAR (200) NULL,
    [niv4_diagnose_code]  VARCHAR (30)  NULL,
    [niv4_diagnose_oms]   VARCHAR (200) NULL,
    [niv5_diagnose_code]  VARCHAR (30)  NULL,
    [niv5_diagnose_oms]   VARCHAR (200) NULL,
    [niv6_diagnose_code]  VARCHAR (30)  NULL,
    [niv6_diagnose_oms]   VARCHAR (200) NULL,
    [creatie_datum]       DATETIME      NOT NULL,
    [mutatie_datum]       DATETIME      NOT NULL,
    [verwijderd_datum]    DATETIME      NULL,
    CONSTRAINT [pk_ggz_diagnose_zpm] PRIMARY KEY CLUSTERED ([ggz_diagnose_zpm_ok] ASC) WITH (FILLFACTOR = 90, DATA_COMPRESSION = PAGE)
);
