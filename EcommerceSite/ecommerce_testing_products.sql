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
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `product_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
  `status` enum('Active','Inactive','Out of Stock') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `fk_products_category` (`category_id`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_product_discount` CHECK ((`discount_percent` between 0 and 100)),
  CONSTRAINT `chk_product_price` CHECK ((`price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Wireless Mouse','ELEC-001','2.4GHz wireless mouse',850.00,5.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(2,1,'Mechanical Keyboard','ELEC-002','RGB mechanical keyboard',3500.00,10.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(3,1,'USB-C Cable','ELEC-003','Fast charging USB-C cable',450.00,0.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(4,2,'Cotton T-Shirt','CLOT-001','Premium cotton t-shirt',750.00,5.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(5,2,'Denim Jeans','CLOT-002','Regular fit denim jeans',2200.00,15.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(6,3,'SQL for Beginners','BOOK-001','Database learning book',650.00,0.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(7,3,'Software Testing Guide','BOOK-002','Manual and automation testing',900.00,10.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(8,4,'Electric Kettle','HOME-001','1.5 litre electric kettle',1800.00,8.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(9,5,'Yoga Mat','SPRT-001','Non-slip exercise yoga mat',1200.00,5.00,'Active','2026-09-13 20:33:16','2026-09-13 20:33:16'),(10,5,'Football','SPRT-002','Professional size football',1100.00,0.00,'Out of Stock','2026-09-13 20:33:16','2026-09-13 20:33:16');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
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
