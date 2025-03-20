-- -------------------------------------------------------------
-- TablePlus 6.3.2(586)
--
-- https://tableplus.com/
--
-- Database: inverter_db
-- Generation Time: 2025-03-20 15:48:24.8050
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `inverter_data`;
CREATE TABLE `inverter_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `device_serial` varchar(50) DEFAULT NULL,
  `ap` int DEFAULT NULL,
  `firmware_version` int DEFAULT NULL,
  `voltage` float DEFAULT NULL,
  `frequency` float DEFAULT NULL,
  `active_power` float DEFAULT NULL,
  `current` float DEFAULT NULL,
  `power_factor` float DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `warning_number` int DEFAULT NULL,
  `dtu_daily_energy` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pv_data`;
CREATE TABLE `pv_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `inverter_id` int DEFAULT NULL,
  `serial_number` varchar(50) DEFAULT NULL,
  `port_number` int DEFAULT NULL,
  `voltage` float DEFAULT NULL,
  `current` float DEFAULT NULL,
  `power` float DEFAULT NULL,
  `energy_total` float DEFAULT NULL,
  `energy_daily` float DEFAULT NULL,
  `error_code` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inverter_id` (`inverter_id`),
  CONSTRAINT `pv_data_ibfk_1` FOREIGN KEY (`inverter_id`) REFERENCES `inverter_data` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;