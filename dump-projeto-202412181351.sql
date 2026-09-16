-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: projeto
-- ------------------------------------------------------
-- Server version	11.5.2-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ArquivoFisico`
--

DROP TABLE IF EXISTS `ArquivoFisico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ArquivoFisico` (
  `id` int(11) NOT NULL,
  `descricao` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ArquivoFisico`
--

LOCK TABLES `ArquivoFisico` WRITE;
/*!40000 ALTER TABLE `ArquivoFisico` DISABLE KEYS */;
/*!40000 ALTER TABLE `ArquivoFisico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DiretorGeral`
--

DROP TABLE IF EXISTS `DiretorGeral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DiretorGeral` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiretorGeral`
--

LOCK TABLES `DiretorGeral` WRITE;
/*!40000 ALTER TABLE `DiretorGeral` DISABLE KEYS */;
/*!40000 ALTER TABLE `DiretorGeral` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Documento`
--

DROP TABLE IF EXISTS `Documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Documento` (
  `id` int(11) NOT NULL,
  `tipoFaturacao` varchar(50) NOT NULL,
  `secretariado_id` int(11) DEFAULT NULL,
  `arquivo_fisico_id` int(11) DEFAULT NULL,
  `diretor_geral_id` int(11) DEFAULT NULL,
  `tesouraria_contabilidade_id` int(11) DEFAULT NULL,
  `superior_hierarquico_id` int(11) DEFAULT NULL,
  `unidade_organica_id` int(11) DEFAULT NULL,
  `sgd_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `secretariado_id` (`secretariado_id`),
  KEY `arquivo_fisico_id` (`arquivo_fisico_id`),
  KEY `diretor_geral_id` (`diretor_geral_id`),
  KEY `tesouraria_contabilidade_id` (`tesouraria_contabilidade_id`),
  KEY `superior_hierarquico_id` (`superior_hierarquico_id`),
  KEY `unidade_organica_id` (`unidade_organica_id`),
  KEY `sgd_id` (`sgd_id`),
  CONSTRAINT `Documento_ibfk_1` FOREIGN KEY (`secretariado_id`) REFERENCES `Secretariado` (`id`),
  CONSTRAINT `Documento_ibfk_2` FOREIGN KEY (`arquivo_fisico_id`) REFERENCES `ArquivoFisico` (`id`),
  CONSTRAINT `Documento_ibfk_3` FOREIGN KEY (`diretor_geral_id`) REFERENCES `DiretorGeral` (`id`),
  CONSTRAINT `Documento_ibfk_4` FOREIGN KEY (`tesouraria_contabilidade_id`) REFERENCES `TesourariaContabilidade` (`id`),
  CONSTRAINT `Documento_ibfk_5` FOREIGN KEY (`superior_hierarquico_id`) REFERENCES `SuperiorHierarquico` (`id`),
  CONSTRAINT `Documento_ibfk_6` FOREIGN KEY (`unidade_organica_id`) REFERENCES `UnidadesOrganicas` (`id`),
  CONSTRAINT `Documento_ibfk_7` FOREIGN KEY (`sgd_id`) REFERENCES `SGD` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Documento`
--

LOCK TABLES `Documento` WRITE;
/*!40000 ALTER TABLE `Documento` DISABLE KEYS */;
/*!40000 ALTER TABLE `Documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SGD`
--

DROP TABLE IF EXISTS `SGD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SGD` (
  `id` int(11) NOT NULL,
  `versao` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SGD`
--

LOCK TABLES `SGD` WRITE;
/*!40000 ALTER TABLE `SGD` DISABLE KEYS */;
/*!40000 ALTER TABLE `SGD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Secretariado`
--

DROP TABLE IF EXISTS `Secretariado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Secretariado` (
  `id` int(11) NOT NULL,
  `documentos` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Secretariado`
--

LOCK TABLES `Secretariado` WRITE;
/*!40000 ALTER TABLE `Secretariado` DISABLE KEYS */;
/*!40000 ALTER TABLE `Secretariado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SuperiorHierarquico`
--

DROP TABLE IF EXISTS `SuperiorHierarquico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SuperiorHierarquico` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SuperiorHierarquico`
--

LOCK TABLES `SuperiorHierarquico` WRITE;
/*!40000 ALTER TABLE `SuperiorHierarquico` DISABLE KEYS */;
/*!40000 ALTER TABLE `SuperiorHierarquico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TesourariaContabilidade`
--

DROP TABLE IF EXISTS `TesourariaContabilidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TesourariaContabilidade` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TesourariaContabilidade`
--

LOCK TABLES `TesourariaContabilidade` WRITE;
/*!40000 ALTER TABLE `TesourariaContabilidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `TesourariaContabilidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UnidadesOrganicas`
--

DROP TABLE IF EXISTS `UnidadesOrganicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UnidadesOrganicas` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UnidadesOrganicas`
--

LOCK TABLES `UnidadesOrganicas` WRITE;
/*!40000 ALTER TABLE `UnidadesOrganicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `UnidadesOrganicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'projeto'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-18 13:51:02
