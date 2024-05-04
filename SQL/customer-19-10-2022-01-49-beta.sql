-- MariaDB dump 10.19  Distrib 10.5.12-MariaDB, for Linux (x86_64)
--
-- Host: mysql.hostinger.ro    Database: u574849695_20
-- ------------------------------------------------------
-- Server version	10.5.12-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birthdate` date NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zipcode` int(11) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Daisha','Pfeffer','kstark@example.com','2010-10-07','54265 Dennis View Suite 587\nLindgrenshire, NY 27904','South Carlos',0),(2,'Pascale','Maggio','donald.jacobs@example.org','2010-10-17','06282 Ivory Mill\nRubieville, AZ 73012','West Ismael',0),(3,'Florencio','Kuhn','sid.armstrong@example.com','2015-06-08','9714 Fleta Island\nNorth Emilie, OH 42281-8542','Abbyfort',0),(4,'Selina','Crona','carey.murray@example.org','1984-11-09','133 Krystina Green\nNorth Friedrichchester, CO 37105','New Ryleeborough',0),(5,'Chaya','McCullough','zora.veum@example.org','1990-10-27','569 Kirstin Highway Suite 833\nBilliemouth, AZ 78973-2284','South Johathan',0),(6,'Dorris','Runte','klein.archibald@example.com','2009-11-07','4604 Camila Gateway Suite 284\nAllentown, NM 07090','New Leo',0),(7,'Gregory','Moen','tsipes@example.com','1981-05-01','90012 Lavonne Springs Apt. 231\nNorth Jerrold, IN 28853','Gloverborough',0),(8,'Patrick','Bednar','danyka28@example.com','2003-09-30','501 Ellen Port Suite 573\nWest Aylafurt, WY 00508','Daughertymouth',0),(9,'Kaycee','Morissette','jude95@example.com','2014-05-29','0174 Spinka Forges\nEast Niko, RI 91539-4798','Ebertside',0),(10,'Minerva','Aufderhar','angie27@example.org','1989-11-30','922 Gleason Village Apt. 606\nLeuschkemouth, MD 23612','Beattyport',0);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-19  1:49:19
