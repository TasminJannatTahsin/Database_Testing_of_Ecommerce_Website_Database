-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_testing
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `address_type` enum('Billing','Shipping','Both') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Shipping',
  `address_line` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postal_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Bangladesh',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `fk_addresses_user` (`user_id`),
  CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,1,'Both','House 11/B, Road 5','Dhaka','Dhaka','1207','Bangladesh',1,'2026-09-13 20:33:16'),(2,2,'Shipping','House 22, Road 10','Chittagong','Chattogram','4000','Bangladesh',1,'2026-09-13 20:33:16'),(3,3,'Both','House 33, Road 3','Sylhet','Sylhet','3100','Bangladesh',1,'2026-09-13 20:33:16'),(4,4,'Both','Office 10','Dhaka','Dhaka','1212','Bangladesh',1,'2026-09-13 20:33:16'),(5,5,'Shipping','House 55','Rajshahi','Rajshahi','6000','Bangladesh',1,'2026-09-13 20:33:16'),(6,6,'Both','House 12/A, Road 6','KHULNA','KHULNA','1207','Bangladesh',1,'2026-09-13 20:33:16'),(7,7,'Shipping','House 12, Road 10','Chittagong','Chattogram','4000','Bangladesh',1,'2026-09-13 20:33:16'),(8,8,'Both','House 23, Road 3','Sylhet','Sylhet','3100','Bangladesh',1,'2026-09-13 20:33:16'),(9,9,'Both','Office 11','Dhaka','Dhaka','1212','Bangladesh',1,'2026-09-13 20:33:16'),(10,10,'Shipping','House 75','Rajshahi','Rajshahi','6000','Bangladesh',1,'2026-09-13 20:33:16'),(11,11,'Both','House 18/B, Road 8','Dhaka','Dhaka','1207','Bangladesh',1,'2026-09-13 20:33:16'),(12,12,'Shipping','House 12, Road 10','Chittagong','Chattogram','4000','Bangladesh',1,'2026-09-13 20:33:16'),(13,13,'Both','House 73, Road 13','Sylhet','Sylhet','3100','Bangladesh',1,'2026-09-13 20:33:16'),(14,14,'Both','Office 110','Dhaka','Dhaka','1212','Bangladesh',1,'2026-09-13 20:33:16'),(15,15,'Shipping','House 515','Rajshahi','Rajshahi','6000','Bangladesh',1,'2026-09-13 20:33:16'),(16,16,'Both','House 111/B, Road 51','Dhaka','Dhaka','1207','Bangladesh',1,'2026-09-13 20:33:16'),(17,17,'Shipping','House 212, Road 110','Chittagong','Chattogram','4000','Bangladesh',1,'2026-09-13 20:33:16'),(18,18,'Both','House 313, Road 31','Sylhet','Sylhet','3100','Bangladesh',1,'2026-09-13 20:33:16'),(19,19,'Both','Office 180','Dhaka','Dhaka','1212','Bangladesh',1,'2026-09-13 20:33:16'),(20,20,'Shipping','House 155','Rajshahi','Rajshahi','6000','Bangladesh',1,'2026-09-13 20:33:16');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-13 20:39:01
