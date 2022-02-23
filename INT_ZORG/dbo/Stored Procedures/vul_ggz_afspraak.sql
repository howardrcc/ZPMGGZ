 
CREATE     proc [dbo].[vul_ggz_afspraak] AS

 


/*## 
datum		wie		wat
------------------------------------------------------------------- 
 
2022-02-07  Howard  Creatie
-------------------------------------------------------------------
##*/
 





begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_afspraak'

 
	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_afspraak',
			@pk1 = 'ggz_afspraak_ok',
            @pk2 = 'patient_id',
            @ts = 'ggz_afspraak_id'

--drop table tempdb..INT_ZORG_ggz_afspraak
 

	-- Insert alle nieuwe records in temp
--    drop table tempdb..INT_ZORG_ggz_afspraak
	INSERT INTO tempdb..INT_ZORG_ggz_afspraak (
            [ggz_afspraak_ok]
             ,patient_id
            ,duur_minuten_geplanned
            ,duur_minuten_realisatie
            ,start_afspraak_datumtijd
            ,eind_afspraak_datumtijd
            ,afspraak_nr_epic --epic
        
        )
    --select * from ZPMGGZ..Appointments

    select 
        a.AppointmentId         as afspraak_ok
        ,ISNULL(c.ClientNumber,-1)         as patient_id
        ,a.PlannedDuration      as duur_minuten_geplanned
        ,a.RealizedDuration     as duur_minuten_realisatie
        ,cast(b.StartDateTime as datetime)        as start_afspraak_datumtijd --splitten? later pas in DM-laag
        ,cast(b.EndDateTime as datetime)          as eind_afspraak_datumtijd
        ,b.AppointmentNumber    as afspraak_nr_epic --epic
    --into ggz_afspraak
    from ZPMGGZ..AppointmentClients a
    left join ZPMGGZ..Appointments b 
        on a.AppointmentId = b.Id
        and b.Removed = 0
    left join ZPMGGZ..Clients c 
        on c.Id = a.ClientId
        --AppointmentCodes evt voor videoconsulten vs familiebijeenkomst vs...
    where 1=1
        and a.Removed = 0
        --and a.AppointmentId IN(229,240)
        --and c.ClientNumber IS NULL
   
 --4581
 
 

 


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_afspraak: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_afspraak',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_afspraak',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_afspraak: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_afspraak

--select * from ggz_afspraak

  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_afspraak'

end