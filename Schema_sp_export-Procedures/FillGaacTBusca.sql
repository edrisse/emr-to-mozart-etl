--
-- Definition of procedure `FillGaacTBusca`
--

DROP PROCEDURE IF EXISTS `FillGaacTBusca`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillGaacTBusca`()
    READS SQL DATA
begin


set foreign_key_checks=0;

truncate table t_gaac_actividades;
truncate table t_gaac;
truncate table t_afinidade;
truncate table t_buscaactiva;

set foreign_key_checks=1;
SELECT property_value INTO @dateFinal FROM openmrs.global_property WHERE property='esaudemetadata.dateToImportTo';

/*Inserir afinidade e t_gaac*/

insert into t_afinidade select name from openmrs.gaac_affinity_type;

/*Inserir t_gaac*/
insert into t_gaac(numGAAC,datainicio,afinidade,datadesintegracao,nidpontofocal)
select gaac_id, start_date, af.name, date_crumbled,nid
from  	openmrs.gaac
		inner join openmrs.gaac_affinity_type af on affinity_type=gaac_affinity_type_id
		left join t_paciente p on p.patient_id=focal_patient_id
where 	gaac.voided=0 and gaac.start_date<=@dateFinal;


/*Inserir t_gaac_actividades*/
insert into t_gaac_actividades(nid,dataInscricao,dataSaida,motivo,numGAAC,observacao)
select 	nid, gm.start_date, gm.end_date,rl.name,t_gaac.numgaac,gm.description
from 	t_paciente p
		inner  join openmrs.gaac_member gm on p.patient_id=gm.member_id
		inner join t_gaac on t_gaac.numgaac=gm.gaac_id
		left join openmrs.gaac_reason_leaving_type rl on gaac_reason_leaving_type_id=reason_leaving_type
where gm.voided=0 and gm.start_date<=@dateFinal;

/*ACTUALIZAR HDD*/
update t_gaac,t_hdd,openmrs.gaac
set t_gaac.hdd=t_hdd.HdD
where t_gaac.numGAAC=gaac.gaac_id and gaac.location_id=t_hdd.location_id;

/*
1. Acrescentar o campo encounter_id,patient_id na tabela t_buscaactiva
Inserir t_buscaactiva*/

insert into t_buscaactiva(nid,datacomecoufaltar,patient_id)
select distinct	p.nid,e.encounter_datetime,e.patient_id
from 	t_paciente p
		inner join openmrs.encounter e on p.patient_id=e.patient_id
where 	e.voided=0 and e.encounter_type=21 and e.encounter_datetime<=@dateFinal;

/*ACTUALIZAR ENCOUNTER_ID*/
update 	t_buscaactiva,openmrs.encounter
set 	t_buscaactiva.encounter_id=encounter.encounter_id
where 	t_buscaactiva.patient_id=encounter.patient_id and t_buscaactiva.datacomecoufaltar=encounter.encounter_datetime and encounter_type=21;

/*Actualizar data primeira tentativa*/
update t_buscaactiva
set t_buscaactiva.dataprimeiratentativa=t_buscaactiva.datacomecoufaltar;

/*Actualizar real data que paciente comecou a faltar
update t_buscaactiva,
		(	SELECT 	o.person_id,e.encounter_id,o.value_datetime as fieldupdate
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2004 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.datacomecoufaltar=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;*/


/*Update Data Entrega Activista*/
update t_buscaactiva,
		(	SELECT 	o.person_id,e.encounter_id,o.value_datetime as dataentregaactivista
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2173 and o.voided=0 and e.voided=0
        ) dataentregaactivista
set 	t_buscaactiva.dataentregaactivista=dataentregaactivista.dataentregaactivista
where 	t_buscaactiva.encounter_id=dataentregaactivista.encounter_id;


/*Actualizar Paciente localizado*/
update t_buscaactiva,
		(	SELECT 	o.person_id,e.encounter_id,
					if(o.value_coded=1065,o.obs_datetime,null) as fieldupdate,
					case o.value_coded
						when 1065 then 'SIM'
						when 1066 then 'NAO'
					else null end as fieldupdate1
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2003 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.pacientelocalizado=updateTable.fieldupdate1,
		t_buscaactiva.datalocalizacao=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*COD MOTIVO ABANDONO*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					case o.value_coded
						when 2005 then 'ESQUECEU A DATA'
						when 2006 then 'ESTA ACAMADO EM CASA'
						when 2007 then 'DISTANCIA/DINHEIRO TRANSPORTE'
						when 2008 then 'PROBLEMAS DE ALIMENTACAO'
						when 2009 then 'PROBLEMAS FAMILIARES'
						when 2010 then 'INSATISFACCAO COM SERVICO NO HDD'
						when 2011 then 'VIAJOU'
						when 2012 then 'DESMOTIVACAO'
						when 2013 then 'TRATAMENTO TRADICIONAL'
						when 2014 then 'TRABALHO'
						when 2015 then 'EFEITOS SECUNDARIOS ARV'
						when 2017 then 'OUTRO'
					else o.value_coded end as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2016 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.codmotivoabandono=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*ENCAMINHAMENTO*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					case o.value_coded
						when 1797 then 'Encaminhado para a US'
						when 1977 then 'Encaminhado para os grupos de apoio'
						when 5488 then 'Orientado sobre a toma correcta dos ARV'
						when 2159 then 'Familiar foi referido para a US'
					else 'OUTRO' end as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=1272 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.codreferencia=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*CONVITE*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					if(o.value_datetime is not null,'SIM','NAO') as fieldupdate1,
					o.value_datetime as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2179 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.entregueconvite=updateTable.fieldupdate1,
		t_buscaactiva.dataentregaconvite=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;

/*CONFIDENTE IDENTIFICADO*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					case o.value_coded
						when 1065 then 'SIM'
						when 1066 then 'NAO'
					else null end as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=1739 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.confidenteidentificado=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*INFORMACAO DADA POR*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					case o.value_coded
						when 2034 then 'Vizinho'
						when 2033 then 'Confidente'
						when 2035 then 'Familiar'
						when 2036 then 'Secretário do Bairro'
					else 'OUTRO' end as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2037 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.codinformacaodadapor=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*SERVICO QUE REFERE*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					case o.value_coded
						when 2175 then 'TARV Adulto'
						when 2174 then 'TARV Pediatrico'
						when 1414 then 'PNCT'
						when 1598 then 'PTV'
					else 'OUTRO' end as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2176 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.Codservicoquerefere=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;

/*Data Segunda Tentativa*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					o.value_datetime as fieldupdate
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=6254 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.datasegundatentativa=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;

/*Data terceira Tentativa*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					o.value_datetime as fieldupdate
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=6255 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.dataterceiratentativa=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;

/*TIPO DE VISITA*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					case o.value_coded
						when 2160 then 'Visita de busca'
						when 2161 then 'Visita de apoio'
					else 'OUTRO' end as fieldupdate
			FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=1981 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.tipovisita=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*Observacao*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					o.value_text as fieldupdate
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2041 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.observacao=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*MOTIVO FALTA*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					if(value_coded=2005,true,null) as esqueceudata,
					if(value_coded=2006,true,null) as estadecama,
					if(value_coded=2007,true,null) as problemadetransporte,
					if(value_coded=2008,true,null) as faltaalimentacao,
					if(value_coded=2010,true,null) as mauatendimento,
					if(value_coded=2015,true,null) as busca_efeitossecundarios,
					if(value_coded=2013,true,null) as tratamentotradicional,
					if(value_coded=2017,true,null) as desistiu
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2016 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.esqueceudata=updateTable.esqueceudata,
		t_buscaactiva.estadecama=updateTable.estadecama,
		t_buscaactiva.problemadetransporte=updateTable.problemadetransporte,
		t_buscaactiva.faltaalimentacao=updateTable.faltaalimentacao,
		t_buscaactiva.mauatendimento=updateTable.mauatendimento,
		t_buscaactiva.busca_efeitossecundarios=updateTable.busca_efeitossecundarios,
		t_buscaactiva.tratamentotradicional=updateTable.tratamentotradicional,
		t_buscaactiva.desistiu=updateTable.desistiu
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;

/*OUTRO MOTIVO*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					o.value_text as fieldupdate
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2017 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.outromotivo=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*RELATORIO DE VISITA*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					if(value_coded=1383,true,null) as estabem,
					if(value_coded=2157,true,null) as dificulades,
					if(value_coded=2156,true,null) as dificuldadefamilia,
					if(value_coded=2015,true,null) as dificuldadeefeitossecundarios,
					if(value_coded=2153,true,null) as faltadeapoio,
					if(value_coded=2154,true,null) as dificuldadetomamedicamento,
					if(value_coded=2155,true,null) as naoreveloudiagnostico
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id in (2158,2157) and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.estabem=updateTable.estabem,
		t_buscaactiva.dificulades=updateTable.dificulades,
		t_buscaactiva.dificuldadefamilia=updateTable.dificuldadefamilia,
		t_buscaactiva.dificuldadeefeitossecundarios=updateTable.dificuldadeefeitossecundarios,
		t_buscaactiva.faltadeapoio=updateTable.faltadeapoio,
		t_buscaactiva.dificuldadetomamedicamento=updateTable.dificuldadetomamedicamento,
		t_buscaactiva.naoreveloudiagnostico=updateTable.naoreveloudiagnostico
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;


/*DATA ENTREGA CARTAO*/
update t_buscaactiva,
		(	SELECT 	o.person_id,
					e.encounter_id,
					o.value_datetime as fieldupdate
            FROM 	openmrs.encounter e
                	inner join openmrs.obs o on e.encounter_id=o.encounter_id and o.person_id=e.patient_id
            WHERE 	e.encounter_type=21 and o.concept_id=2180 and o.voided=0 and e.voided=0
        ) updateTable
set 	t_buscaactiva.dataentregacartao=updateTable.fieldupdate
where 	t_buscaactiva.encounter_id=updateTable.encounter_id;

end $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;