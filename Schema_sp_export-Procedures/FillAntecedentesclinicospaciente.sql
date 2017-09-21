--
-- Definition of procedure `FillAntecedentesclinicospaciente`
--

DROP PROCEDURE IF EXISTS `FillAntecedentesclinicospaciente`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillAntecedentesclinicospaciente`()
BEGIN

truncate table t_antecedentesclinicospaciente;

INSERT INTO t_antecedentesclinicospaciente (codantecendentes, nid, datadiagnostico, estado)
SELECT DISTINCT
	   cn.name AS codantecedentes,
	   p.nid,
	   o.obs_datetime AS datadiagnostico,
	   CASE o.value_coded
			WHEN 1065 THEN 'SIM'
			WHEN 1066 THEN 'NAO'
			WHEN 1457 THEN 'SEM INFORMACAO'
	   ELSE 'SIM' END AS estado
FROM t_paciente p
	   INNER JOIN openmrs.encounter e ON p.patient_id = e.patient_id
	   INNER JOIN openmrs.obs o ON o.encounter_id = e.encounter_id
			AND e.patient_id = o.person_id
	   INNER JOIN openmrs.concept_name cn ON cn.concept_id = o.concept_id
			AND cn.locale = 'pt' AND cn.concept_name_type = 'FULLY_SPECIFIED'
WHERE e.encounter_type IN (5,7)
			AND o.concept_id in (42, 5042, 836, 5334, 5340, 507,1379, 1380, 1381, 5018, 5339, 5027, 1429,5030,5965,5050,204,1215)
			AND cn.voided = 0
			AND o.voided = 0
			AND e.voided = 0
			AND p.datanasc IS NOT NULL
			AND p.nid IS NOT NULL
			AND e.encounter_datetime = p.dataabertura
group by p.nid,cn.name;
end $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;