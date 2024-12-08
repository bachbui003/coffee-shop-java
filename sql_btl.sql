-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: baitaplon
-- ------------------------------------------------------
-- Server version	8.0.37

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
-- Table structure for table `cafe`
--

DROP TABLE IF EXISTS `cafe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cafe` (
  `id_cafe` int NOT NULL,
  `ten_cafe` varchar(45) NOT NULL,
  `giatien` varchar(45) NOT NULL,
  PRIMARY KEY (`id_cafe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cafe`
--

LOCK TABLES `cafe` WRITE;
/*!40000 ALTER TABLE `cafe` DISABLE KEYS */;
INSERT INTO `cafe` VALUES (1,'capu','5000'),(2,'me','12000'),(3,'mè','5000'),(5,'á','10000');
/*!40000 ALTER TABLE `cafe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doan`
--

DROP TABLE IF EXISTS `doan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doan` (
  `id_doan` int NOT NULL,
  `ten_doan` varchar(45) NOT NULL,
  `giatien` varchar(45) NOT NULL,
  PRIMARY KEY (`id_doan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doan`
--

LOCK TABLES `doan` WRITE;
/*!40000 ALTER TABLE `doan` DISABLE KEYS */;
INSERT INTO `doan` VALUES (1,'bánh','12000'),(2,'gà','12000'),(3,'cá','5000');
/*!40000 ALTER TABLE `doan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gio_hang`
--

DROP TABLE IF EXISTS `gio_hang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gio_hang` (
  `hoten` varchar(100) NOT NULL,
  `sdt` varchar(45) NOT NULL,
  `tenmh` varchar(45) NOT NULL,
  `soluong` varchar(45) NOT NULL,
  PRIMARY KEY (`hoten`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gio_hang`
--

LOCK TABLES `gio_hang` WRITE;
/*!40000 ALTER TABLE `gio_hang` DISABLE KEYS */;
/*!40000 ALTER TABLE `gio_hang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoidung`
--

DROP TABLE IF EXISTS `nguoidung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoidung` (
  `email` varchar(100) NOT NULL,
  `sdt` varchar(20) NOT NULL,
  `matkhau` varchar(45) NOT NULL,
  `hoten` varchar(100) NOT NULL,
  PRIMARY KEY (`sdt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoidung`
--

LOCK TABLES `nguoidung` WRITE;
/*!40000 ALTER TABLE `nguoidung` DISABLE KEYS */;
INSERT INTO `nguoidung` VALUES ('123bach@gmail.com','00000000','1234','bÃ¡ch'),('bach1234@gmail.com','010020201','12345','BÃ¡ch BÃ¹i'),('son123@gmail.com','111123213','123','SÆ¡n'),('minh123@gmail.com','123456789','1234','Minh');
/*!40000 ALTER TABLE `nguoidung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thongtinnv`
--

DROP TABLE IF EXISTS `thongtinnv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thongtinnv` (
  `idNhanVien` int NOT NULL AUTO_INCREMENT,
  `HoTenNV` varchar(100) NOT NULL,
  `NamSingNV` int NOT NULL,
  `GioiTinhNV` varchar(45) NOT NULL,
  `sdt` varchar(45) NOT NULL,
  PRIMARY KEY (`idNhanVien`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thongtinnv`
--

LOCK TABLES `thongtinnv` WRITE;
/*!40000 ALTER TABLE `thongtinnv` DISABLE KEYS */;
INSERT INTO `thongtinnv` VALUES (1,'Dương 3',2003,'nam','0123012012');
/*!40000 ALTER TABLE `thongtinnv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tk_admin`
--

DROP TABLE IF EXISTS `tk_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tk_admin` (
  `tentkadmin` varchar(45) NOT NULL,
  `mkadmin` varchar(45) NOT NULL,
  PRIMARY KEY (`tentkadmin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tk_admin`
--

LOCK TABLES `tk_admin` WRITE;
/*!40000 ALTER TABLE `tk_admin` DISABLE KEYS */;
INSERT INTO `tk_admin` VALUES ('duong','1234');
/*!40000 ALTER TABLE `tk_admin` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-01 10:04:31
