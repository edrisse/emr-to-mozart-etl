
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `t_aconselhamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_aconselhamento` (
  `idaconselhamento` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(50) DEFAULT NULL,
  `criteriosmedicos` varchar(50) DEFAULT NULL,
  `conceitos` tinyint(1) DEFAULT NULL,
  `interessado` tinyint(1) DEFAULT NULL,
  `confidente` tinyint(1) DEFAULT NULL,
  `apareceregularmente` tinyint(1) DEFAULT NULL,
  `riscopobreaderencia` tinyint(1) DEFAULT NULL,
  `regimetratamento` tinyint(1) DEFAULT NULL,
  `prontotarv` tinyint(1) DEFAULT NULL,
  `datapronto` datetime DEFAULT NULL,
  `obs` text,
  `encounter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`idaconselhamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_actividadeaconselhamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_actividadeaconselhamento` (
  `idaconselhamento` int(11) DEFAULT NULL,
  `nid` varchar(50) DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  `nrsessao` int(11) DEFAULT NULL,
  `tipoactividade` varchar(50) DEFAULT NULL,
  `apresentouconfidente` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_adulto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_adulto` (
  `nid` varchar(50) NOT NULL,
  `codprofissao` varchar(50) DEFAULT NULL,
  `codnivel` varchar(50) DEFAULT NULL,
  `nrconviventes` varchar(50) DEFAULT NULL,
  `codestadocivil` varchar(50) DEFAULT NULL,
  `nrconjuges` varchar(50) DEFAULT NULL,
  `serologiaHivconjuge` varchar(50) DEFAULT NULL,
  `Nrprocesso` varchar(50) DEFAULT NULL,
  `outrosparceiros` varchar(50) DEFAULT NULL,
  `nrfilhos` int(11) DEFAULT NULL,
  `nrfilhostestados` int(11) DEFAULT NULL,
  `nrfilhoshiv` int(11) DEFAULT NULL,
  `tabaco` tinyint(4) DEFAULT NULL,
  `alcool` tinyint(4) DEFAULT NULL,
  `droga` tinyint(4) DEFAULT NULL,
  `nrparceiros` int(11) DEFAULT NULL,
  `antecedentesgenelogicos` longtext,
  `datamestruacao` datetime DEFAULT NULL,
  `aborto` tinyint(4) DEFAULT NULL,
  `ptv` tinyint(4) DEFAULT NULL,
  `ptvquais` varchar(50) DEFAULT NULL,
  `gravida` tinyint(4) DEFAULT NULL,
  `semanagravidez` int(11) DEFAULT NULL,
  `dataprevistoparto` datetime DEFAULT NULL,
  `puerpera` tinyint(4) DEFAULT NULL,
  `dataparto` varchar(50) DEFAULT NULL,
  `tipoaleitamento` varchar(50) DEFAULT NULL,
  `Alergiamedicamentos` varchar(50) DEFAULT NULL,
  `Alergiasquais` longtext,
  `Antecedentestarv` tinyint(4) DEFAULT NULL,
  `antecedentesquais` longtext,
  `exposicaoacidental` varchar(30) DEFAULT NULL,
  `tipoacidente` longtext,
  `historiaactual` longtext,
  `hipotesedediagnostico` longtext,
  `codkarnosfsky` int(11) DEFAULT NULL,
  `geleira` tinyint(4) DEFAULT NULL,
  `electricidade` tinyint(4) DEFAULT NULL,
  `sexualidade` varchar(50) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`nid`),
  KEY `codestadocivil` (`codestadocivil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_afinidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_afinidade` (
  `afinidade` varchar(255) NOT NULL,
  PRIMARY KEY (`afinidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_antecedentesclinicospaciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_antecedentesclinicospaciente` (
  `codantecendentes` varchar(50) NOT NULL,
  `nid` varchar(50) NOT NULL,
  `datadiagnostico` datetime DEFAULT NULL,
  `observacao` varchar(50) DEFAULT NULL,
  `Estado` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`codantecendentes`,`nid`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_buscaactiva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_buscaactiva` (
  `nid` varchar(50) NOT NULL,
  `datacomecoufaltar` datetime NOT NULL,
  `dataentregaactivista` datetime DEFAULT NULL,
  `pacientelocalizado` varchar(50) DEFAULT NULL,
  `datalocalizacao` datetime DEFAULT NULL,
  `codmotivoabandono` varchar(50) DEFAULT NULL,
  `codreferencia` varchar(50) DEFAULT NULL,
  `entregueconvite` varchar(50) DEFAULT NULL,
  `parceiroenvolvido` varchar(50) DEFAULT NULL,
  `familiaenvolvida` varchar(50) DEFAULT NULL,
  `parceiroemtratamento` varchar(50) DEFAULT NULL,
  `confidenteidentificado` varchar(50) DEFAULT NULL,
  `Codinformacaodadapor` varchar(50) DEFAULT NULL,
  `Codservicoquerefere` varchar(50) DEFAULT NULL,
  `dataprimeiratentativa` datetime DEFAULT NULL,
  `datasegundatentativa` datetime DEFAULT NULL,
  `dataterceiratentativa` datetime DEFAULT NULL,
  `Observacao` longtext,
  `codprofissional` int(11) DEFAULT NULL,
  `tipovisita` varchar(255) DEFAULT NULL,
  `esqueceudata` tinyint(4) DEFAULT NULL,
  `estadecama` tinyint(4) DEFAULT NULL,
  `problemadetransporte` tinyint(4) DEFAULT NULL,
  `faltaalimentacao` tinyint(4) DEFAULT NULL,
  `ausenciadoprofissional` tinyint(4) DEFAULT NULL,
  `mauatendimento` tinyint(4) DEFAULT NULL,
  `busca_efeitossecundarios` tinyint(4) DEFAULT NULL,
  `tratamentotradicional` tinyint(4) DEFAULT NULL,
  `desistiu` tinyint(4) DEFAULT NULL,
  `outromotivo` varchar(255) DEFAULT NULL,
  `estabem` tinyint(4) DEFAULT NULL,
  `dificulades` tinyint(4) DEFAULT NULL,
  `dificuldadefamilia` tinyint(4) DEFAULT NULL,
  `dificuldadeefeitossecundarios` tinyint(4) DEFAULT NULL,
  `faltadeapoio` tinyint(4) DEFAULT NULL,
  `dificuldadetomamedicamento` tinyint(4) DEFAULT NULL,
  `naoreveloudiagnostico` tinyint(4) DEFAULT NULL,
  `naoencontradopor` varchar(255) DEFAULT NULL,
  `outromotivonaoencontrado` varchar(255) DEFAULT NULL,
  `outroencaminhamento` varchar(255) DEFAULT NULL,
  `dataentregacartao` datetime DEFAULT NULL,
  `dataentregaconvite` datetime DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`nid`,`datacomecoufaltar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_contacto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_contacto` (
  `idcontacto` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idcontacto`),
  KEY `idcontacto` (`idcontacto`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB AUTO_INCREMENT=2218 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_crianca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_crianca` (
  `nid` varchar(50) NOT NULL,
  `tipoparto` varchar(50) DEFAULT NULL,
  `local` varchar(50) DEFAULT NULL,
  `termo` varchar(30) DEFAULT NULL,
  `pesonascimento` varchar(50) DEFAULT NULL,
  `exposicaotarvmae` varchar(30) DEFAULT NULL,
  `exposicaotarvnascenca` varchar(30) DEFAULT NULL,
  `patologianeonatal` varchar(50) DEFAULT NULL,
  `injeccoes` varchar(30) DEFAULT NULL,
  `escarificacoes` varchar(30) DEFAULT NULL,
  `extracoesdentarias` varchar(30) DEFAULT NULL,
  `aleitamentomaterno` varchar(30) DEFAULT NULL,
  `aleitamentoexclusivo` varchar(30) DEFAULT NULL,
  `idadedesmame` int(11) DEFAULT NULL,
  `pavcompleto` varchar(30) DEFAULT NULL,
  `idadecronologica` varchar(50) DEFAULT NULL,
  `bailey` varchar(50) DEFAULT NULL,
  `idmae` int(11) DEFAULT NULL,
  `idpai` int(11) DEFAULT NULL,
  `observacao` longtext,
  `patient_id` int(11) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`nid`),
  KEY `idadecronologica` (`idadecronologica`),
  KEY `idadedesmame` (`idadedesmame`),
  KEY `idmae` (`idmae`),
  KEY `idpai` (`idpai`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_diagnosticoseguimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_diagnosticoseguimento` (
  `idseguimento` int(11) NOT NULL,
  `coddiagnostico` varchar(50) NOT NULL,
  `observacao` longtext,
  `Nid` varchar(255) DEFAULT NULL,
  `Data` datetime DEFAULT NULL,
  PRIMARY KEY (`idseguimento`,`coddiagnostico`),
  KEY `coddiagnostico` (`coddiagnostico`),
  KEY `data` (`Data`),
  KEY `idseguimento` (`idseguimento`),
  KEY `t_diagnosticoseguimentonid` (`Nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_esposicaotarvmae`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_esposicaotarvmae` (
  `nid` varchar(50) DEFAULT NULL,
  `tarv` varchar(50) DEFAULT NULL,
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_esposicaotarvnascenca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_esposicaotarvnascenca` (
  `nid` varchar(50) DEFAULT NULL,
  `tarv` varchar(50) DEFAULT NULL,
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_estadopaciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_estadopaciente` (
  `codestado` varchar(50) NOT NULL,
  `designacao` varchar(50) DEFAULT NULL,
  `Activo` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`codestado`),
  KEY `codestado` (`codestado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_gaac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_gaac` (
  `hdd` varchar(50) DEFAULT NULL,
  `numGAAC` int(11) NOT NULL,
  `datainicio` datetime DEFAULT NULL,
  `afinidade` varchar(255) DEFAULT NULL,
  `dataDesintegracao` datetime DEFAULT NULL,
  `nidPontoFocal` varchar(255) DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`numGAAC`),
  KEY `{74AD1F0E-011B-482D-A4CC-8F3380B3CC13}` (`afinidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_gaac_actividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_gaac_actividades` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(255) DEFAULT NULL,
  `dataInscricao` datetime DEFAULT NULL,
  `dataSaida` datetime DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `numGAAC` int(11) DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `{4EDA4D29-DD1B-47BA-9B79-C3D8F8FEDC29}` (`numGAAC`),
  KEY `nid` (`nid`),
  KEY `numGAAC` (`numGAAC`)
) ENGINE=InnoDB AUTO_INCREMENT=474 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_hdd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_hdd` (
  `HdD` varchar(50) NOT NULL,
  `designacao` varchar(50) DEFAULT NULL,
  `local` varchar(50) DEFAULT NULL,
  `Provincia` varchar(50) DEFAULT NULL,
  `Distrito` varchar(50) DEFAULT NULL,
  `dataabertura` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`HdD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_histestadopaciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_histestadopaciente` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(50) DEFAULT NULL,
  `codestado` varchar(50) DEFAULT NULL,
  `dataestado` datetime DEFAULT NULL,
  `destinopaciente` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `codestado` (`codestado`),
  KEY `dataestado` (`dataestado`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_infeccoesoportunisticaseguimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_infeccoesoportunisticaseguimento` (
  `idseguimento` int(11) NOT NULL,
  `estadiooms` varchar(50) NOT NULL,
  `codigoio` varchar(50) NOT NULL,
  `Nid` varchar(255) DEFAULT NULL,
  `Data` datetime DEFAULT NULL,
  PRIMARY KEY (`idseguimento`,`estadiooms`,`codigoio`),
  KEY `idseguimento` (`idseguimento`),
  KEY `Nid` (`Nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_mae`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_mae` (
  `idmae` int(11) NOT NULL AUTO_INCREMENT,
  `idade` varchar(50) DEFAULT NULL,
  `vivo` varchar(50) DEFAULT NULL,
  `doente` varchar(50) DEFAULT NULL,
  `doenca` varchar(50) DEFAULT NULL,
  `codprofissao` varchar(50) DEFAULT NULL,
  `resultadohiv` varchar(50) DEFAULT NULL,
  `emtarv` varchar(50) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`idmae`),
  KEY `idade` (`idade`),
  KEY `nid` (`idmae`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_observacaopaciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_observacaopaciente` (
  `idobservacao` int(11) NOT NULL AUTO_INCREMENT,
  `codobservacao` varchar(50) DEFAULT NULL,
  `codestado` varchar(50) DEFAULT NULL,
  `valor` varchar(50) DEFAULT NULL,
  `nid` varchar(50) DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  `medico` int(11) DEFAULT NULL,
  `Observacao` longtext,
  PRIMARY KEY (`idobservacao`),
  UNIQUE KEY `idobservacao` (`idobservacao`),
  KEY `codestado` (`codestado`),
  KEY `codobservacao` (`codobservacao`),
  KEY `data` (`data`),
  KEY `medico` (`medico`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_paciente` (
  `hdd` varchar(50) DEFAULT NULL,
  `dataabertura` datetime DEFAULT NULL,
  `nid` varchar(50) DEFAULT NULL,
  `sexo` varchar(50) DEFAULT NULL,
  `datanasc` datetime DEFAULT NULL,
  `idade` double DEFAULT NULL,
  `meses` int(11) DEFAULT NULL,
  `coddistrito` varchar(50) DEFAULT NULL,
  `codproveniencia` varchar(50) DEFAULT NULL,
  `designacaoprov` varchar(50) DEFAULT NULL,
  `Codigoproveniencia` varchar(255) DEFAULT NULL,
  `emtarv` tinyint(4) DEFAULT NULL,
  `datainiciotarv` datetime DEFAULT NULL,
  `codregime` varchar(50) DEFAULT NULL,
  `codestado` varchar(50) DEFAULT NULL,
  `destinopaciente` varchar(100) DEFAULT NULL,
  `datasaidatarv` datetime DEFAULT NULL,
  `datadiagnostico` datetime DEFAULT NULL,
  `aconselhado` tinyint(4) DEFAULT NULL,
  `referidocd` tinyint(4) DEFAULT NULL,
  `estadiooms` varchar(255) DEFAULT NULL,
  `emtratamentotb` tinyint(4) DEFAULT NULL,
  `DataCD` datetime DEFAULT NULL,
  `referidohdd` varchar(255) DEFAULT NULL,
  `datareferidohdd` datetime DEFAULT NULL,
  `aceitabuscaactiva` varchar(50) DEFAULT NULL,
  `dataaceitabuscaactiva` datetime DEFAULT NULL,
  `referidobuscaactiva` varchar(50) DEFAULT NULL,
  `datareferenciabuscaactiva` datetime DEFAULT NULL,
  `situacaohiv` varchar(50) DEFAULT NULL,
  `observacao` longtext,
  `Educacaoprevencao` varchar(255) DEFAULT NULL,
  `transfOutraUs` varchar(255) DEFAULT NULL,
  `dataElegibilidadeInicioTarv` datetime DEFAULT NULL,
  `apssDisponivel` varchar(255) DEFAULT NULL,
  `apssFormaContacto` varchar(255) DEFAULT NULL,
  `apssQuemInformouSeroestado` varchar(255) DEFAULT NULL,
  `apssconheceestadoparceiro` varchar(255) DEFAULT NULL,
  `PatientID` varchar(255) DEFAULT NULL,
  `patient_id` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(11) DEFAULT NULL,
  `tipopaciente` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nid` (`nid`) USING BTREE,
  KEY `codestado` (`codestado`),
  KEY `dataabertura` (`dataabertura`),
  KEY `datainiciotarv` (`datainiciotarv`),
  KEY `idade` (`idade`),
  KEY `PatientID` (`PatientID`)
) ENGINE=InnoDB AUTO_INCREMENT=9509 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_pai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_pai` (
  `idpai` int(11) NOT NULL AUTO_INCREMENT,
  `idade` varchar(50) DEFAULT NULL,
  `vivo` varchar(50) DEFAULT NULL,
  `doente` varchar(50) DEFAULT NULL,
  `doenca` varchar(50) DEFAULT NULL,
  `codprofissao` varchar(50) DEFAULT NULL,
  `resultadohiv` varchar(50) DEFAULT NULL,
  `emtarv` varchar(50) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`idpai`),
  KEY `idade` (`idade`),
  KEY `nid` (`idpai`)
) ENGINE=InnoDB AUTO_INCREMENT=456 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_questionariotb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_questionariotb` (
  `codopcao` varchar(255) NOT NULL,
  `estadoopcao` tinyint(4) DEFAULT NULL,
  `nid` varchar(255) NOT NULL,
  `data` datetime NOT NULL,
  `Observacao` longtext,
  PRIMARY KEY (`codopcao`,`nid`,`data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_resultadoslaboratorio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_resultadoslaboratorio` (
  `idresultado` int(11) NOT NULL AUTO_INCREMENT,
  `codexame` varchar(50) DEFAULT NULL,
  `nid` varchar(50) DEFAULT NULL,
  `dataresultado` datetime DEFAULT NULL,
  `codparametro` varchar(50) DEFAULT NULL,
  `resultado` double DEFAULT NULL,
  `obs` longtext,
  `datapedido` datetime DEFAULT NULL,
  `notificoufamilia` varchar(255) DEFAULT NULL,
  `dataProximoControlCd4` datetime DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`idresultado`),
  KEY `codexame` (`codexame`),
  KEY `dataresultado` (`dataresultado`),
  KEY `idresultado` (`idresultado`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB AUTO_INCREMENT=39480 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_seguimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_seguimento` (
  `idseguimento` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(50) DEFAULT NULL,
  `idade` double DEFAULT NULL,
  `meses` double DEFAULT NULL,
  `estadohiv` varchar(50) DEFAULT NULL,
  `dataseguimento` datetime DEFAULT NULL,
  `estadiooms` varchar(50) DEFAULT NULL,
  `dataproximaconsulta` datetime DEFAULT NULL,
  `aleitamentomaterno` varchar(255) DEFAULT NULL,
  `idadedesmame` int(11) DEFAULT NULL,
  `Gravidez` int(11) DEFAULT NULL,
  `screeningtb` varchar(30) DEFAULT NULL,
  `Observacao` longtext,
  `screeningIts` varchar(255) DEFAULT NULL,
  `aconselhado` varchar(255) DEFAULT NULL,
  `referidoSectorClinico` varchar(255) DEFAULT NULL,
  `gravida` varchar(255) DEFAULT NULL,
  `dum` varchar(255) DEFAULT NULL,
  `dpp` varchar(255) DEFAULT NULL,
  `PTV_TARV` varchar(255) DEFAULT NULL,
  `sintomasTb` varchar(255) DEFAULT NULL,
  `dataParto` datetime DEFAULT NULL,
  `sexoseguimento` varchar(255) DEFAULT NULL,
  `apssdatavisita` datetime DEFAULT NULL,
  `pp1` tinyint(4) DEFAULT NULL,
  `pp2` tinyint(4) DEFAULT NULL,
  `pp3` tinyint(4) DEFAULT NULL,
  `pp4` tinyint(4) DEFAULT NULL,
  `pp5` tinyint(4) DEFAULT NULL,
  `pp6` tinyint(4) DEFAULT NULL,
  `pp7` tinyint(4) DEFAULT NULL,
  `apssTipovisita` varchar(255) DEFAULT NULL,
  `apssAdesao` varchar(255) DEFAULT NULL,
  `apssActividade` varchar(255) DEFAULT NULL,
  `apssproximavisita` datetime DEFAULT NULL,
  `lactante` tinyint(4) DEFAULT NULL,
  `localSeguimento` varchar(255) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`idseguimento`),
  KEY `dataproximaconsulta` (`dataproximaconsulta`),
  KEY `dataseguimento` (`dataseguimento`),
  KEY `estadohiv` (`estadohiv`),
  KEY `idade` (`idade`),
  KEY `idadedesmame` (`idadedesmame`),
  KEY `idseguimento` (`idseguimento`),
  KEY `nid` (`nid`),
  KEY `screeningtb` (`screeningtb`)
) ENGINE=InnoDB AUTO_INCREMENT=159108 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_tarv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_tarv` (
  `idtarv` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(50) DEFAULT NULL,
  `datatarv` datetime DEFAULT NULL,
  `codregime` varchar(50) DEFAULT NULL,
  `dias` int(11) DEFAULT NULL,
  `tipotarv` varchar(50) DEFAULT NULL,
  `codmudanca` varchar(50) DEFAULT NULL,
  `dataproxima` datetime DEFAULT NULL,
  `observacao` longtext,
  `QtdComp` int(11) DEFAULT NULL,
  `QtdSaldo` int(11) DEFAULT NULL,
  `dataoutroservico` datetime DEFAULT NULL,
  `embalageensaviadas` int(11) DEFAULT NULL,
  `saldoembalagens` int(11) DEFAULT NULL,
  `efeitosSecundarios` varchar(255) DEFAULT NULL,
  `dataexpirareceita` varchar(255) DEFAULT NULL,
  `idade` int(11) DEFAULT NULL,
  `compromido` varchar(255) DEFAULT NULL,
  `compromido1` varchar(255) DEFAULT NULL,
  `compromido2` varchar(255) DEFAULT NULL,
  `dose` varchar(255) DEFAULT NULL,
  `dose1` varchar(255) DEFAULT NULL,
  `dose2` varchar(255) DEFAULT NULL,
  `motivoInicioTarv` varchar(255) DEFAULT NULL,
  `linhaTerapeutica` varchar(255) DEFAULT NULL,
  `encounter_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`idtarv`),
  UNIQUE KEY `idtarv` (`idtarv`),
  UNIQUE KEY `unique_key` (`nid`,`datatarv`,`codregime`),
  KEY `codregime` (`codregime`),
  KEY `datatarv` (`datatarv`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB AUTO_INCREMENT=183142 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_tratamentoseguimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_tratamentoseguimento` (
  `idseguimento` int(11) DEFAULT NULL,
  `codtratamento` varchar(50) DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  `nid` varchar(50) DEFAULT NULL,
  `observacao` longtext,
  `datafimtratamento` datetime DEFAULT NULL,
  `servico` varchar(255) DEFAULT NULL,
  KEY `codtratamento` (`codtratamento`),
  KEY `data` (`data`),
  KEY `datafimtratamento` (`datafimtratamento`),
  KEY `idseguimento` (`idseguimento`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_tratamentotb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_tratamentotb` (
  `nid` varchar(50) NOT NULL,
  `data` datetime NOT NULL,
  `Observacao` longtext,
  `datafim` datetime DEFAULT NULL,
  `servico` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`nid`,`data`),
  KEY `data` (`data`),
  KEY `datafim` (`datafim`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `t_void_duplo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_void_duplo` (
  `encounter_id` int(11) NOT NULL,
  PRIMARY KEY (`encounter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

