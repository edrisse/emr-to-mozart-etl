--
-- Definition of procedure `FillTPacienteTable`
--

DROP PROCEDURE IF EXISTS `FillTPacienteTable`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTPacienteTable`()
    READS SQL DATA
begin

truncate table t_paciente;
SELECT property_value INTO @dateFinal FROM openmrs.global_property WHERE property='esaudemetadata.dateToImportTo';

/*Inscricao*/
	insert into export_db.t_paciente(patient_id,sexo,datanasc)
	select 	p.patient_id,pe.gender,pe.birthdate
	from 	openmrs.patient p
			inner join openmrs.person pe on p.patient_id=pe.person_id
	where 	p.voided=0 and pe.voided=0;

/*Update data abertura*/
update 	export_db.t_paciente,
		(	Select 	p.patient_id,min(encounter_datetime) data_abertura,if(e.encounter_type=5,'Adulto','Crianca') tipopaciente,e.location_id
			from 	openmrs.patient p
					inner join openmrs.encounter e on e.patient_id=p.patient_id
			where 	p.voided=0 and e.encounter_type in (5,7) and e.voided=0 and e.encounter_datetime<=@dateFinal
			group by patient_id
		) abertura
set t_paciente.dataabertura=abertura.data_abertura,
	t_paciente.tipopaciente=abertura.tipopaciente,
	t_paciente.location_id=abertura.location_id
where t_paciente.patient_id=abertura.patient_id;

/*Update data abertura com a data de inscricao no programa: Para quem nao tem processo clinico preenchido*/
update export_db.t_paciente,openmrs.patient_program
set 	t_paciente.dataabertura =patient_program.date_enrolled,
		t_paciente.location_id =patient_program.location_id
where 	t_paciente.patient_id=patient_program.patient_id and patient_program.voided=0 and
		patient_program.program_id=1 and t_paciente.dataabertura is null;


/*Eliminar pacientes sem data de abertura*/
delete from t_paciente where dataabertura is null;

/*Actualizar pacientes com mesmo NID*/
update openmrs.patient_identifier,
	(select max(patient_id) patient_id,nid
	from
		(	select patient_id,nid
			from openmrs.patient_identifier,
				(	select identifier nid
					from 	openmrs.patient_identifier
					where 	voided=0 and identifier_type=2
					group by identifier
					having count(*)>=2
				) nid
			where patient_identifier.identifier=nid.nid
		) nid2
	group by nid
	) nid3
set identifier=concat(identifier,'D')
where patient_identifier.identifier=nid3.nid and patient_identifier.patient_id=nid3.patient_id;


/*Update NID*/
update export_db.t_paciente,
		(	select 	distinct patient_id,identifier
			from 	openmrs.patient_identifier
			where 	identifier_type=2 and voided=0
		) nid
set t_paciente.nid=nid.identifier
where nid.patient_id=t_paciente.patient_id;

/*@Euclides: Didn't understand why this next script is necessary!*/
update export_db.t_paciente,openmrs.patient_identifier
set t_paciente.nid=patient_identifier.identifier
where t_paciente.patient_id=patient_identifier.patient_id and t_paciente.nid is null and voided=0;

/*Update hdd*/
update export_db.t_paciente, export_db.t_hdd
set t_paciente.hdd=t_hdd.hdd,
	t_paciente.coddistrito=t_hdd.Distrito
where t_paciente.location_id=t_hdd.location_id;



/*Apagar pacientes sem local de abertura correcto*/
/*delete from export_db.t_paciente where hdd is null;*/

/*Update Idade*/
update t_paciente
set idade=round(datediff(dataabertura,datanasc)/365)
where dataabertura is not null;

/*Actualizar tipo de paciente para quem não tem*/
update export_db.t_paciente
set tipopaciente=if(idade<15,'Crianca','Adulto')
where tipopaciente is null;


update t_paciente
set meses=round(datediff(dataabertura,datanasc)/30)
where dataabertura is not null and idade<2;

/*Update CodProveniencia*/
update t_paciente,
		(Select 	p.patient_id,
				case o.value_coded
				when 1595 then 'ENF'
				when 1596 then 'C.ext'
				when 1414 then 'PNCTL'
				when 1597 then 'ATS/UATS'
				when 1987 then 'SAAJ'
				when 1598 then 'PTV'
				when 1872 then 'CCR'
				when 1275 then 'CS'
				when 1984 then 'HG/HR'
				when 1599 then 'CP'
				when 1932 then 'Referido por 1 PS'
				when 1387 then 'Laboratorio'
				when 1386 then 'Clinica Movel'
				when 1044 then 'ENF. PEDIATRIA'
				when 6304 then 'ATIP'
				when 1986 then 'SEGUNDO SITIO'
				when 6245 then 'ATSC'
				when 1699 then 'CD'
				when 2160 then 'Busca Consentida'
				when 6288 then 'SMI'
				when 5484 then 'Apoio Alimentar'
				when 6155 then 'PMT'
				when 6303 then 'VBG'
				when 6305 then 'OBC'
				else 'Outro' end as codProv
		from 	t_paciente p
				inner join openmrs.encounter e on e.patient_id=p.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	o.voided=0 and o.concept_id=1594 and e.encounter_type in (5,7) and e.voided=0
		) proveniencia
set t_paciente.codproveniencia=proveniencia.codProv
where proveniencia.patient_id=t_paciente.patient_id;

/*Update LocalProveniencia*/
update t_paciente,
		(Select 	p.patient_id,
					o.value_text
		from 	t_paciente p
				inner join openmrs.encounter e on e.patient_id=p.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	o.voided=0 and o.concept_id=1626 and e.encounter_type in (5,7) and e.voided=0
		) desprov
set t_paciente.designacaoprov=desprov.value_text
where desprov.patient_id=t_paciente.patient_id;

/*Update CodigoProveniencia*/
update t_paciente,
		(Select 	p.patient_id,
					o.value_text
		from 	t_paciente p
				inner join openmrs.encounter e on e.patient_id=p.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	o.voided=0 and o.concept_id=1627 and e.encounter_type in (5,7) and e.voided=0
		) desprov
set t_paciente.codigoproveniencia=desprov.value_text
where desprov.patient_id=t_paciente.patient_id;



/*Inicio TARV*/
update t_paciente,
	(select patient_id,min(data_inicio) data_inicio
		from
		(
			Select 	p.patient_id,min(e.encounter_datetime) data_inicio
			from 	openmrs.patient p
					inner join openmrs.encounter e on p.patient_id=e.patient_id
					inner join openmrs.obs o on o.encounter_id=e.encounter_id
			where 	e.voided=0 and o.voided=0 and p.voided=0 and
					e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and
					e.encounter_datetime<=@dateFinal
			group by p.patient_id

			union

			Select p.patient_id,min(value_datetime) data_inicio
			from 	openmrs.patient p
					inner join openmrs.encounter e on p.patient_id=e.patient_id
					inner join openmrs.obs o on e.encounter_id=o.encounter_id
			where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and
					o.concept_id=1190 and o.value_datetime is not null and
					o.value_datetime<=@dateFinal
			group by p.patient_id

			union

			select 	pg.patient_id,date_enrolled as data_inicio
			from 	openmrs.patient p inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
			where 	pg.voided=0 and p.voided=0 and program_id=2 and
					pg.date_enrolled<=@dateFinal
		) inicio
		group by patient_id
	)inicio_real

set t_paciente.emtarv=true,
	t_paciente.datainiciotarv=inicio_real.data_inicio
where t_paciente.patient_id=inicio_real.patient_id;



/*Estado Actual TARV*/
update t_paciente,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRANSFERIDO PARA'
					when 8 then 'SUSPENDER'
					when 9 then 'ABANDONO'
					when 10 then 'OBITO'
				else null end as codeestado
		from 	t_paciente p
				inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
				inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and
				ps.start_date<=@dateFinal
		) saida
set 	t_paciente.codestado=saida.codeestado,
		t_paciente.datasaidatarv=saida.start_date
where saida.patient_id=t_paciente.patient_id;


/*Estado Actual NAO TARV*/
update t_paciente,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 2 then 'ABANDONO'
					when 3 then 'TRANSFERIDO PARA'
					when 5 then 'OBITO'
				else 'OUTRO' end as codeestado
		from 	t_paciente p
				inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
				inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and
				pg.program_id=1 and ps.state in (2,3,5) and ps.end_date is null and
				ps.start_date<=@dateFinal
		) saida
set 	t_paciente.codestado=saida.codeestado,
		t_paciente.datasaidatarv=saida.start_date
where saida.patient_id=t_paciente.patient_id and t_paciente.datainiciotarv is null;

/*Estado Actual - Obito Demografico*/
update t_paciente,openmrs.person
set 	t_paciente.codestado='OBITO',
		t_paciente.datasaidatarv=person.death_date
where person.person_id=t_paciente.patient_id and codestado is null and dead=1;

/*Data de Diagnostico*/
update t_paciente,
	(	Select 	p.patient_id,
				o.value_datetime
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and
				e.encounter_type in (5,7) and o.concept_id=6123
	) diagnostico

set 	t_paciente.datadiagnostico=diagnostico.value_datetime
where 	t_paciente.patient_id=diagnostico.patient_id;

/*Aconselhado*/
update t_paciente,
	(	Select 	p.patient_id
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and
				e.encounter_type in (5,7) and o.concept_id=1463 and o.value_coded=1065
	) aconselhado
set 	t_paciente.aconselhado=true
where 	t_paciente.patient_id=aconselhado.patient_id;

/*Aceita busca*/
update t_paciente, openmrs.encounter
set 	t_paciente.aceitabuscaactiva=true,
		t_paciente.dataaceitabuscaactiva=encounter_datetime
where encounter.patient_id=t_paciente.patient_id and encounter_type=30 and encounter_datetime<=@dateFinal;


/*Update Regime*/
update t_paciente,
(
			select 	ultimo_lev.patient_id,
					case o.value_coded
						when 1651 then 'AZT+3TC+NVP'
						when 6324 then 'TDF+3TC+EFV'
						when 1703 then 'AZT+3TC+EFV'
						when 6243 then 'TDF+3TC+NVP'
						when 6103 then 'D4T+3TC+LPV/r'
						when 792 then 'D4T+3TC+NVP'
						when 1827 then 'D4T+3TC+EFV'
						when 6102 then 'D4T+3TC+ABC'
						when 6116 then 'AZT+3TC+ABC'
						when 6108 then 'TDF+3TC+LPV/r(2ª Linha)'
						when 6100 then 'AZT+3TC+LPV/r(2ª Linha)'
						when 6329 then 'TDF+3TC+RAL+DRV/r (3ª Linha)'
						when 6330 then 'AZT+3TC+RAL+DRV/r (3ª Linha)'
						when 6105 then 'ABC+3TC+NVP'
						when 6102 then 'D4T+3TC+ABC'
						when 6325 then 'D4T+3TC+ABC+LPV/r (2ª Linha)'
						when 6326 then 'AZT+3TC+ABC+LPV/r (2ª Linha)'
						when 6327 then 'D4T+3TC+ABC+EFV (2ª Linha)'
						when 6328 then 'AZT+3TC+ABC+EFV (2ª Linha)'
						when 6109 then 'AZT+DDI+LPV/r (2ª Linha)'
						when 6329 then 'TDF+3TC+RAL+DRV/r (3ª Linha)'
						when 6110 then 'D4T20+3TC+NVP'
						when 1702 then 'AZT+3TC+NFV'
						when 817  then 'AZT+3TC+ABC'
						when 6104 then 'ABC+3TC+EFV'
						when 6106 then 'ABC+3TC+LPV/r'
						when 6244 then 'AZT+3TC+RTV'
						when 1700 then 'AZT+DDl+NFV'
						when 633  then 'EFV'
						when 625  then 'D4T'
						when 631  then 'NVP'
						when 628  then '3TC'
						when 6107 then 'TDF+AZT+3TC+LPV/r'
						when 6236 then 'D4T+DDI+RTV-IP'
						when 1701 then 'ABC+DDI+NFV'
					else 'OUTRO' end as ultimo_regime,
					ultimo_lev.encounter_datetime data_regime
			from 	openmrs.obs o,
					(	select p.patient_id,max(encounter_datetime) as encounter_datetime
						from 	t_paciente p
								inner join openmrs.encounter e on p.patient_id=e.patient_id
						where 	encounter_type=18 and e.voided=0 and
								encounter_datetime <=@dateFinal
						group by patient_id
					) ultimo_lev
			where 	o.person_id=ultimo_lev.patient_id and o.obs_datetime=ultimo_lev.encounter_datetime and o.voided=0 and
					o.concept_id=1088
		) regime
set		t_paciente.codregime=regime.ultimo_regime
where	t_paciente.patient_id=regime.patient_id;

/*Update Estadio OMS*/
update t_paciente,
	(	select estadio1.patient_id,
				case obs.value_coded
				when 1204 then 'I'
				when 1205 then 'II'
				when 1206 then 'III'
				when 1207 then 'IV'
				else 'OUTRO' end as nome

		from
		(Select p.patient_id,
				min(e.encounter_datetime) data_tarv
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and
				e.encounter_type in (6,9) and o.concept_id=5356
		group by p.patient_id) estadio1
		inner join openmrs.encounter e on e.patient_id=estadio1.patient_id
		inner join openmrs.obs on obs.encounter_id=e.encounter_id

		where	estadio1.data_tarv=obs.obs_datetime and obs.concept_id=5356 and obs.voided=0 and
				e.encounter_type in (6,9) and e.voided=0 and e.encounter_datetime<=@dateFinal

	) estadio

set		t_paciente.estadiooms=estadio.nome
where	t_paciente.patient_id=estadio.patient_id;

/*Tratamento de TB*/
update t_paciente,
		(select 	pg.patient_id
		from 	t_paciente p inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
		where 	pg.voided=0 and program_id=5 and date_enrolled<=@dateFinal
		) tratamentotb
set 	t_paciente.emtratamentotb=true
where tratamentotb.patient_id=t_paciente.patient_id;


/*CUIDADOS DOMICILIARIOS*/
update t_paciente,
	(	Select 	p.patient_id,
				o.obs_datetime
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and e.encounter_datetime<=@dateFinal and
				e.encounter_type in (6,9) and o.concept_id in (6287,1272) and o.value_coded=1699
	) referCD
set 	t_paciente.referidocd=true,
		t_paciente.DataCD=referCD.obs_datetime
where 	t_paciente.patient_id=referCD.patient_id;

/*EDUCAO e PREVENCAO*/
update t_paciente,
	(	Select 	p.patient_id,
				o.obs_datetime,
				if(o.value_coded=1065,'SIM','NAO') valorEd
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and e.encounter_datetime<=@dateFinal and
				e.encounter_type in (6,9) and o.concept_id=1714
	) educacao
set 	t_paciente.Educacaoprevencao=valorEd
where 	t_paciente.patient_id=educacao.patient_id;

/*TRANSFERIDO DE PRE-TARV*/
update t_paciente,
		(select 	pg.patient_id
		from 	t_paciente p
				inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
				inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and
				pg.program_id=1 and ps.state=28 and ps.start_date<=@dateFinal
		) transf
set 	t_paciente.transfOutraUs='SIM'
where 	t_paciente.patient_id=transf.patient_id;

/*TRANSFERIDO DE TARV*/
update t_paciente,
		(select 	pg.patient_id
		from 	t_paciente p
				inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
				inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and
				pg.program_id=2 and ps.state=29 and ps.start_date<=@dateFinal
		) transf
set 	t_paciente.transfOutraUs='SIM'
where 	t_paciente.patient_id=transf.patient_id;


/*DATA ELEGIBILIDADE*/
update t_paciente,
	(	Select 	p.patient_id,
				o.value_datetime
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and e.encounter_datetime<=@dateFinal and
				e.encounter_type in (6,9) and o.concept_id=6278
	) elegivel
set 	t_paciente.dataElegibilidadeInicioTarv=value_datetime
where 	t_paciente.patient_id=elegivel.patient_id;


/*APSS DISPONIVEL*/
update t_paciente,
	(	Select 	p.patient_id
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
		where 	e.voided=0 and e.encounter_datetime<=@dateFinal and
				e.encounter_type in (34,24,19) and e.form_id in (131,132)
	) apss
set 	t_paciente.apssDisponivel='SIM'
where 	t_paciente.patient_id=apss.patient_id;


/*APSS FORMA CONTACTO*/
update t_paciente,
	(	Select 	p.patient_id,
				if(o.value_coded=6307,'CONTACTO TELEFONICO','VISITA DOMICILIARIA') tipo
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and e.encounter_datetime<=@dateFinal and o.voided=0 and
				e.encounter_type in (34,24,19) and e.form_id in (131,132) and o.concept_id=6309
	) apss
set 	t_paciente.apssFormaContacto=tipo
where 	t_paciente.patient_id=apss.patient_id;


/*APSS INFORMOU ESTADO*/
update t_paciente,
	(	Select 	p.patient_id,
				if(o.value_coded=1065,'SIM','NAO') tipo
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and e.encounter_datetime<=@dateFinal and o.voided=0 and
				e.encounter_type in (34,24,19) and e.form_id in (131,132) and o.concept_id=1048
	) apss
set 	t_paciente.apssQuemInformouSeroestado=tipo
where 	t_paciente.patient_id=apss.patient_id;

/*APSS ESTADO PARCEIRO*/
update t_paciente,
	(	Select 	p.patient_id,
				if(o.value_coded=703,'POSITIVO',if(o.value_coded=664,'NEGATIVO','NAO SABE')) tipo
		from 	t_paciente p
				inner join openmrs.encounter e on p.patient_id=e.patient_id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and e.encounter_datetime<=@dateFinal and o.voided=0 and
				e.encounter_type in (34,24,19) and e.form_id in (131,132) and o.concept_id=2074
	) apss
set 	t_paciente.apssconheceestadoparceiro=tipo
where 	t_paciente.patient_id=apss.patient_id;


end $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;