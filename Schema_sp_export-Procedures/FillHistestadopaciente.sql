--
-- Definition of procedure `FillHistestadopaciente`
--

DROP PROCEDURE IF EXISTS `FillHistestadopaciente`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHistestadopaciente`()
    READS SQL DATA
BEGIN

truncate table t_histestadopaciente;
SELECT property_value INTO @dateFinal FROM openmrs.global_property WHERE property='esaudemetadata.dateToImportTo';

insert into t_histestadopaciente (nid, codestado, dataestado, destinopaciente)
select	p.nid,
		case    o.value_coded
				when 1707 then 'Abandono'
				when 1706 then 'Transferido para'
				when 1366 then 'Morte'
				when 1704 then 'HIV Negativo'
				when 1709 then 'Suspender Tarv'
				else 'Outro' end as codestado,
		e.encounter_datetime as dataestado,
		destino.destinopaciente
from	t_paciente p
		inner join openmrs.encounter e on p.patient_id=e.patient_id
		inner join openmrs.obs o on o.encounter_id=e.encounter_id
		left join	(
						select	e.encounter_id,
								o.value_text as destinopaciente
						from	openmrs.encounter e
								inner join openmrs.obs o on e.encounter_id=o.encounter_id
						where	e.voided=0 and o.voided=0 and e.encounter_type=18 and o.concept_id=2059 and e.encounter_datetime<=@dateFinal
					) destino on e.encounter_id=destino.encounter_id
where	e.encounter_type in (18,6,9) and o.concept_id in (1708,6138) and o.voided=0 and e.voided=0 and p.nid is not null and o.value_coded<>6269 and
		e.encounter_datetime<=@dateFinal;

insert into t_histestadopaciente (nid, codestado, dataestado)
select 	nid,
		case ps.state
			when 7 then 'Transferido para'
			when 8 then 'Suspender Tarv'
			when 9 then 'Abandono'
			when 10 then 'Morte'
		else 'OUTRO' end as estado,
		ps.start_date
from 	t_paciente p
		inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
		inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
where 	pg.voided=0 and ps.voided=0 and
		pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is not null and ps.start_date<=@dateFinal;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;