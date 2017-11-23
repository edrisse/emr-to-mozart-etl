--#t_paciente
select count(*) from patient where patient.voided = false;

--#t_seguimento
select (select count(*) from encounter
join obs on (obs.encounter_id = encounter.encounter_id)
join patient on (patient.patient_id = encounter.patient_id)
where encounter.voided = false
  and encounter.encounter_type in (6,9)
  and obs.voided = false
  and obs.concept_id = 5356
  and patient.voided = false) + (select count(*) from encounter
where encounter.voided = false
  and encounter.encounter_type in (34,24)
  and encounter.form_id = 132)

--#t_tarv
select count(*) from encounter
join patient on (patient.patient_id = encounter.patient_id)
where encounter.voided = false
  and encounter.encounter_type = 18
  and patient.voided = false

--#t_resultadoslaboratorio
select 
(select count(*)
FROM	encounter
join	obs on (obs.encounter_id = encounter.encounter_id)
join patient on (patient.patient_id = encounter.patient_id)
where encounter.encounter_type in (6,9,13)
  and obs.voided = false
  and encounter.voided = false 
  and obs.concept_id in (730,5497,1695,653,654,1694,1693,1021,952,1691,1022,1690,1330,1024,1332,1025,1333,1023,1331,1017,
						851,21,1692,1018,678,679,1015,729,1016,1307,1011,857,790,848,655,887,12971299,855,856,1006,1007,
						1008,785,2077,1014,1012,1013,717,1009,1134,1133,1132,1520)
  and patient.voided = false) +
(select count(*)
from	encounter
join	obs on obs.encounter_id = encounter.encounter_id
join patient on (patient.patient_id = encounter.patient_id)
where encounter.encounter_type in (6,9,13) 
  and obs.voided = 0 
  and encounter.voided = 0 
  and obs.concept_id in (300,1655,299,307,1030,45)
  and patient.voided = false)

