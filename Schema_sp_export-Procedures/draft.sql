SELECT o.value_datetime AS data,e.patient_id
FROM 	openmrs.encounter e
INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id AND o.person_id=e.patient_id
					 WHERE 	e.encounter_type IN (6,9) and o.concept_id IN (1113)  AND o.voided=0 AND e.voided=0 and e.encounter_datetime<=@dateFinal

					UNION

					 SELECT o.obs_datetime AS data,e.patient_id
					 FROM 	openmrs.encounter e
							INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id AND o.person_id=e.patient_id
					 WHERE 	e.encounter_type IN (6,9) AND o.concept_id IN (1268) AND o.value_coded=1256 AND o.voided=0 AND e.voided=0 and e.encounter_datetime<=@dateFinal

#data inicio
SELECT o.value_datetime AS data 
FROM openmrs.encounter e
	INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id 
WHERE e.encounter_type IN (6,9) 
  AND o.concept_id IN (1113)  
  AND o.voided=0 
  AND e.voided=0 
  AND e.encounter_datetime<=curdate()
  AND e.patient_id = ?

UNION

SELECT o.obs_datetime AS data
FROM openmrs.encounter e
	INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id 
WHERE e.encounter_type IN (6,9) 
  AND o.concept_id IN (1268) 
  AND o.value_coded=1256 
  AND o.voided=0 
  AND e.voided=0 
  AND e.encounter_datetime<=curdate()
  AND e.patient_id = ?

#data fim
SELECT p.nid,o.value_datetime as datafim
FROM openmrs.encounter e 
  INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id
WHERE e.encounter_type IN (6,9) 
  AND o.concept_id=6120 
  AND o.voided=0 
  AND e.voided=0 
  AND e.encounter_datetime<=curdate()
  AND e.patient_id = ?





SELECT o.value_datetime as datafim
FROM openmrs.encounter 
  INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id
WHERE 	e.encounter_type IN (6,9) AND o.concept_id=6120 AND o.voided=0 AND e.voided=0 and e.encounter_datetime<=@dateFinal
