set global max_allowed_packet=512*1024*1024;

insert into global_property (property, property_value, uuid) values ('esaudemetadata.hfc', '92001', '52128fe7-0aaa-4452-9c01-124bd5cd6517');
insert into global_property (property, property_value, uuid) values ('esaudemetadata.dateToImportTo', '2017-02-10', '66536be7-3c3b-407d-97cd-d39d5253ff87');

update person set person.voided = true where person.birthdate is null;
update patient_program set voided = true where patient_program.patient_program_id = 19173;
update patient_program set voided = true where patient_program.patient_program_id = 19174;
update patient_program set voided = true where patient_program.patient_program_id = 19195;
update patient_program set voided = true where patient_program.patient_id in (10407, 10417, 10438, 10446, 10459, 10458);
update person set voided = true where person.person_id = 7634;
update person set voided = true where person.person_id in (3386, 5021, 10160, 10278, 10440, 10488);
update encounter set encounter.voided = true where encounter.encounter_id in (369280, 383732, 387915);

update encounter set encounter.voided = true where encounter.encounter_id in (
select id from (select min(e.encounter_id) id from encounter e
  where e.voided = false
    and e.encounter_type = 18
  group by e.patient_id, e.encounter_datetime
  having count(*) > 1) t);
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

