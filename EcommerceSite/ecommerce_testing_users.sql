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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_type` enum('Customer','Admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Customer',
  `status` enum('Active','Inactive','Blocked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Tasmin','Tahsin','tasmin@example.com','HASH001','01710000001','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(2,'Rahim','Ahmed','rahim@example.com','HASH002','01710000002','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(3,'Nusrat','Jahan','nusrat@example.com','HASH003','01710000003','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(4,'Admin','User','admin@example.com','HASH004','01710000004','Admin','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(5,'Karim','Hasan','karim@example.com','HASH005','01710000005','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(6,'Mahia','Jannat','mahia@example.com','HASH006','01710000006','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(7,'Rahia','Akter','rahia@example.com','HASH007','01710000007','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(8,'Hasah','Sakeh','Hassah@example.com','HASH008','01710000008','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(9,'Nihal','Uddin','nihal@example.com','HASH009','01710000009','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(10,'Tonny','Begum','tonny@example.com','HASH010','01710000010','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(11,'Safin','Hasan','safin@example.com','HASH011','01710000011','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(12,'Sami','Kovir','sami@example.com','HASH012','01710000012','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(13,'Minhas','Rahman','minhas@example.com','HASH013','01710000013','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(14,'Abdullah','Antor','abdullah@example.com','HASH014','01710000014','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(15,'Kabir','Hossain','kabir@example.com','HASH015','01710000015','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(16,'Monir','Islam','monir@example.com','HASH016','01710000016','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(17,'Tamjid','Islam','tamjid@example.com','HASH017','01710000017','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(18,'Tamim','Hssas','tamim@example.com','HASH018','01710000018','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16'),(19,'Tania','Jaman','tania@example.com','HASH019','01710000019','Customer','Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(20,'Rafiq','Uddin','Rafiq@example.com','HASH020','01710000020','Customer','Inactive','2026-09-13 20:33:16','2026-09-13 20:33:16');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-13 20:39:00
