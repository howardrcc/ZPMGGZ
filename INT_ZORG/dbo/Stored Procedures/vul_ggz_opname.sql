CREATE     proc [dbo].[vul_ggz_opname] AS

 --select cast('2022-01-12' as smalldatetime)


/*## 
datum		wie		wat
------------------------------------------------------------------- 
2022-01-10  Howard  Creatie

            opname codelist/dimensie in ggz_opname_dim

            opbouwen vanuit trajecten
            volgorderlijkheid: na dims draaien

-------------------------------------------------------------------
##*/
 

begin

    set nocount on

    print convert(varchar(20), getdate(), 120) + ' begin vul_ggz_opname'

 

	-- Maak temp tabel
	EXEC	INT_ZORG..make_temp_tab
			@db  = 'INT_ZORG',
			@tab = 'ggz_opname',
			@pk1 = 'ggz_opname_ok',
            @ts = 'ggz_opname_id'

--drop table tempdb..INT_ZORG_ggz_opname

 
	-- Insert alle nieuwe records in temp
	INSERT INTO tempdb..INT_ZORG_ggz_opname (        
        ggz_opname_ok
        ,opname_nr
        ,patient_nr
        ,department_id
        ,kamer
        ,bed
        ,start_datumtijd
        ,eind_datumtijd
    )
     --drop table ggz_zorgpresatatie
    SELECT  
        a.Id                                             as ggz_opname_ok
        ,[AdmissionNumber]                               as opname_nr
        ,c.ClientNumber                                  as patient_nr
        ,dep.dep_id                                      as department_id
        ,r.Name                                          as kamer
        ,b.Name                                          as bed
        ,cast([StartDateTime] as smalldatetime)          as start_datumtijd
        ,cast([EndDateTime] as smalldatetime)            as eind_datumtijd
    --into ggz_opname
    from ZPMGGZ..Admissions a
    left join ZPMGGZ..Clients c 
        on a.ClientId = c.Id
    left join ZPMGGZ..Departments d 
        on a.DepartmentId = d.Id
    left join ZPMGGZ..Rooms r 
        on r.Id = a.RoomId
    left join ZPMGGZ..Beds   b 
        on b.Id = a.BedId
    left join department dep 
        on upper(dep.dep_naam) = upper(d.[Name]) COLLATE database_default
    --dep bed room
    where a.Removed = 0
 
--select * from INT_ZORG..zorgverlener
--select * from ZPMGGZ..OrganizationUsers org 
/*select p.patient_id, p.patient_nr, c.ClientNumber, p.patient_naam,c.FullName 
from ZPMGGZ..Clients c 
left join  patient p 
    on c.ClientNumber=p.patient_nr
    */
 

 --SELECT * FROM ggz_opname
--select * from INT_ZORG..department where dep_naam like '%PUK%'
--select * from ZPMGGZ..Departments


	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_opname: error inserting new records in temp tab',16,1)
		RETURN -1
	END

	exec	INT_ZORG..merge_int_zorg
			@inc_db  = 'tempdb',
			@inc_tab = 'INT_ZORG_ggz_opname',
			@cum_db  = 'INT_ZORG',
			@cum_tab = 'ggz_opname',
			@full = 1,
			@do_update_statistics = 1

	IF @@error <> 0
	BEGIN
		raiserror('vul_ggz_opname: Error merge tables',16,1)
		RETURN -1
	END

	drop table tempdb..INT_ZORG_ggz_opname


  PRINT convert(varchar(20), getdate(), 120) + ' eind vul_ggz_opname'

end