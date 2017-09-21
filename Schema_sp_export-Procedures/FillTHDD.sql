--
-- Definition of procedure `FillTHDD`
--

DROP PROCEDURE IF EXISTS `FillTHDD`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTHDD`()
    READS SQL DATA
BEGIN

truncate table t_hdd;
SELECT county_district INTO @distrito FROM openmrs.location l WHERE l.location_id = (select DISTINCT location_id from openmrs.obs);
SELECT property_value INTO @hfc FROM openmrs.global_property WHERE property = 'esaudemetadata.hfc';
SELECT DISTINCT location_id INTO @loc FROM openmrs.obs;

insert into t_hdd(hdd,designacao,local,distrito,provincia,location_id)
select location_id,name,address2,county_district,state_province,location_id
from openmrs.location l
where county_district=@distrito;

update t_hdd set t_hdd.hdd=@hfc WHERE t_hdd.hdd=@loc;

delete from t_hdd where length(hdd)<=4;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;