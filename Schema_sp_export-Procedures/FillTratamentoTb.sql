--
-- Definition of procedure `FillTratamentoTb`
--

DROP PROCEDURE IF EXISTS `FillTratamentoTb`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTratamentoTb`()
    READS SQL DATA
BEGIN

DECLARE no_info INT;
DECLARE piidentifier VARCHAR(30);
DECLARE ppdate_enrolled DATETIME;
DECLARE ppdate_completed DATETIME;
DECLARE contagem INT DEFAULT 0;


DECLARE cur_tb CURSOR FOR
		SELECT DISTINCT tp.nid,
			   pp.date_enrolled,pp.date_completed
		FROM openmrs.patient_program pp
				INNER JOIN t_paciente tp
                ON pp.patient_id = tp.patient_id
		WHERE pp.program_id = 5 AND pp.voided = 0 and pp.date_completed<=(SELECT property_value FROM openmrs.global_property WHERE property='esaudemetadata.dateToImportTo');

DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_info=1;

TRUNCATE TABLE t_tratamentotb;
SELECT property_value INTO @dateFinal FROM openmrs.global_property WHERE property='esaudemetadata.dateToImportTo';

INSERT INTO t_tratamentotb (nid, data)
SELECT DISTINCT p.nid,dataInicio.data
FROM t_paciente p
	INNER JOIN (	 SELECT o.value_datetime AS data,e.patient_id
					 FROM 	openmrs.encounter e
							INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id AND o.person_id=e.patient_id
					 WHERE 	e.encounter_type IN (6,9) and o.concept_id IN (1113)  AND o.voided=0 AND e.voided=0 and e.encounter_datetime<=@dateFinal

					UNION

					 SELECT o.obs_datetime AS data,e.patient_id
					 FROM 	openmrs.encounter e
							INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id AND o.person_id=e.patient_id
					 WHERE 	e.encounter_type IN (6,9) AND o.concept_id IN (1268) AND o.value_coded=1256 AND o.voided=0 AND e.voided=0 and e.encounter_datetime<=@dateFinal

			) dataInicio ON dataInicio.patient_id=p.patient_id;


	update t_tratamentotb,
			(	SELECT 	p.nid,o.value_datetime as datafim
				FROM 	t_paciente p
						inner join openmrs.encounter e on p.patient_id=e.patient_id
						INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id
				WHERE 	e.encounter_type IN (6,9) AND o.concept_id=6120 AND o.voided=0 AND e.voided=0 and e.encounter_datetime<=@dateFinal
			) datafim
	set t_tratamentotb.datafim=datafim.datafim
	where datafim.nid=t_tratamentotb.nid;


SET no_info = 0;
OPEN cur_tb;
cur_loop:WHILE(no_info = 0) DO

    FETCH cur_tb INTO piidentifier, ppdate_enrolled,ppdate_completed;

    IF no_info = 1 THEN
		LEAVE cur_loop;
	END IF;

		SELECT COUNT(*) INTO contagem
        from t_tratamentotb
        WHERE nid = piidentifier AND data = ppdate_enrolled;

    IF contagem = 0 THEN
		INSERT INTO t_tratamentotb (nid, data, datafim) values(piidentifier,ppdate_enrolled,ppdate_completed);
	END IF;

SET contagem = 0;

END WHILE cur_loop;
CLOSE cur_tb;
SET no_info = 0;
end $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;