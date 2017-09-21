--
-- Definition of procedure `FillAconselhamentoTable`
--

DROP PROCEDURE IF EXISTS `FillAconselhamentoTable`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillAconselhamentoTable`()
    READS SQL DATA
BEGIN

truncate table t_aconselhamento;
truncate table t_actividadeaconselhamento;
SELECT property_value INTO @dateFinal FROM openmrs.global_property WHERE property='esaudemetadata.dateToImportTo';

/*Acrescentar a coluna encounter_id na tabela t_aconselhamento*/
INSERT INTO t_aconselhamento (nid,encounter_id)
SELECT 	nid,encounter_id
FROM 	t_paciente p
		inner join openmrs.encounter e on p.patient_id=e.patient_id
WHERE 	nid IS NOT NULL and e.encounter_type in (19,29) and e.voided=0 and e.encounter_datetime<=@dateFinal;



UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then 'SIM'
					when 1066 then 'NAO'
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1248 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.criteriosmedicos=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;

UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1729 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.conceitos=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;

UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1736 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.interessado=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;

UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1739 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.confidente=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;


UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1743 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.apareceregularmente=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;


UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1749 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.riscopobreaderencia=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;


UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1752 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.regimetratamento=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;

UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				case o.value_coded
					when 1065 then true
					when 1066 then false
				end as fieldUpdate,
				case o.value_coded
					when 1065 then o.obs_datetime
				else null end as datapronto
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1756 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.prontotarv=updateTable.fieldUpdate,
	t_aconselhamento.datapronto=updateTable.datapronto
where t_aconselhamento.encounter_id=updateTable.encounter_id;

UPDATE t_aconselhamento,
	(	SELECT 	o.person_id,
				e.encounter_id,
				o.value_text as fieldUpdate
		FROM 	openmrs.encounter e
				inner join openmrs.obs o on e.encounter_id=o.encounter_id
		WHERE 	e.encounter_type in (19,29) and o.concept_id=1757 and o.voided=0 and e.voided=0
    ) updateTable
set t_aconselhamento.obs=updateTable.fieldUpdate
where t_aconselhamento.encounter_id=updateTable.encounter_id;

INSERT INTO t_actividadeaconselhamento (idaconselhamento, nid, data)
select idaconselhamento,nid,encounter_datetime
from 	t_aconselhamento ta
		inner join openmrs.encounter e on ta.encounter_id=e.encounter_id;

update t_actividadeaconselhamento,
(
	SELECT 	o.person_id,
			o.encounter_id,
			ta.idaconselhamento,
			o.value_numeric as fieldUpdate
	FROM 	openmrs.encounter e
			inner join openmrs.obs o on e.encounter_id=o.encounter_id
			inner join t_aconselhamento ta on ta.encounter_id=e.encounter_id
	WHERE 	e.encounter_type in (19,29) and o.concept_id= 1724 and o.voided=0 and e.voided=0

)updateTable
set t_actividadeaconselhamento.nrsessao=updateTable.fieldUpdate
where t_actividadeaconselhamento.idaconselhamento=updateTable.idaconselhamento;

update t_actividadeaconselhamento,
(
	SELECT 	o.person_id,
			o.encounter_id,
			ta.idaconselhamento,
			case o.value_coded
				when 1725 then 'GRUPO'
				when 1726 then 'INDIVIDUAL'
			end as fieldUpdate
	FROM 	openmrs.encounter e
			inner join openmrs.obs o on e.encounter_id=o.encounter_id
			inner join t_aconselhamento ta on ta.encounter_id=e.encounter_id
	WHERE 	e.encounter_type in (19,29) and o.concept_id= 1727 and o.voided=0 and e.voided=0

)updateTable
set t_actividadeaconselhamento.tipoactividade=updateTable.fieldUpdate
where t_actividadeaconselhamento.idaconselhamento=updateTable.idaconselhamento;


update t_actividadeaconselhamento,
(
	SELECT 	o.person_id,
			o.encounter_id,
			ta.idaconselhamento,
			case o.value_coded
				when 1065 then true
				when 1066 then false
			end as fieldUpdate
	FROM 	openmrs.encounter e
			inner join openmrs.obs o on e.encounter_id=o.encounter_id
			inner join t_aconselhamento ta on ta.encounter_id=e.encounter_id
	WHERE 	e.encounter_type in (19,29) and o.concept_id= 1728 and o.voided=0 and e.voided=0

)updateTable
set t_actividadeaconselhamento.apresentouconfidente=updateTable.fieldUpdate
where t_actividadeaconselhamento.idaconselhamento=updateTable.idaconselhamento;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;