--resolver erro ao importar bases de dados muito grandes
set global max_allowed_packet=512*1024*1024;

--definir o codigo da unidade sanitária
insert into global_property (property, property_value, uuid) values ('esaudemetadata.hfc', '92001', '52128fe7-0aaa-4452-9c01-124bd5cd6517');

--todos registos da obs devem apontar para a unidade sanitaria com mais registos
update obs set obs.location_id = (select * from (select location_id from obs group by location_id order by count(*) desc limit 1) t);

--inactivar todos pacientes sem data de nascimento
update patient set patient.voided = true where patient.patient_id in (
select * from (select patient.patient_id from patient
join person on (person.person_id = patient.patient_id)
where person.voided = false
  and patient.voided = false
  and person.birthdate is null) t);

--inactivar pacientes que nasceram depois da primeira consulta
update patient set patient.voided = true where patient.patient_id in (
select * from (select distinct patient.patient_id from patient
join person on (person.person_id = patient.patient_id)
join encounter on (encounter.patient_id = patient.patient_id)
where patient.voided = false
  and person.voided = false
  and encounter.voided = false
  and person.birthdate >= encounter.encounter_datetime) t);

--inactivar pacientes sem NID
update patient set patient.voided = true where patient.patient_id in (
select * from (select patient.patient_id from patient
where patient.voided = false
  and not exists (select * from patient_identifier
where patient_identifier.identifier_type = 2
  and patient_identifier.voided = false
  and patient_identifier.patient_id = patient.patient_id)) t);

update patient set patient.voided = true where patient.patient_id in (
select * from (select distinct patient_program.patient_id from patient_program
join person on (person.person_id = patient_program.patient_id)
where patient_program.program_id = 1
  and patient_program.voided = false
  and person.voided = false
  and patient_program.voided = false
  and person.birthdate >= patient_program.date_enrolled) t);

--executar ate trazer 0 registos actualizados cada uma das instrucoes abaixo
update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (select min(encounter.encounter_id) id from encounter
where encounter.voided = false
  and encounter.encounter_type in (5, 7)
group by encounter.patient_id, encounter.encounter_datetime
having count(*) > 1
) t);

update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (select min(encounter.encounter_id) id from encounter
where encounter.voided = false
  and encounter.encounter_type in (6, 9)
group by encounter.patient_id, encounter.encounter_datetime
having count(*) > 1
) t);

update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (SELECT min(e.encounter_id) id
FROM openmrs.encounter e
	INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id 
WHERE e.encounter_type IN (6,9) 
  AND o.concept_id in (1113)  
  AND o.voided=0
  and e.voided = false 
group by e.patient_id, o.value_datetime
having count(*) > 1
) t);

update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (SELECT min(e.encounter_id) id
FROM openmrs.encounter e 
  INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id
WHERE e.encounter_type IN (6,9) 
  AND o.concept_id=6120 
  AND o.voided=0 
  AND e.voided=0 
group by e.patient_id
having count(*) > 1
) t);

update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (select min(e.encounter_id) id from encounter e
  where e.voided = false
    and e.encounter_type = 18
  group by e.patient_id, e.encounter_datetime
  having count(*) > 1) t);

update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (select distinct encounter.encounter_id id from encounter
join obs on (obs.encounter_id = encounter.encounter_id)
where encounter.voided = false
  and obs.voided = false
  and encounter.encounter_type = 18
  and obs.concept_id = 5096
  and encounter.encounter_datetime >= obs.value_datetime
) t);


