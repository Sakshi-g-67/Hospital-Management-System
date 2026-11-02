-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hospital_management
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `admissions`
--

DROP TABLE IF EXISTS `admissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admissions` (
  `Admission_ID` int NOT NULL,
  `Patient_ID` int DEFAULT NULL,
  `Room_ID` int DEFAULT NULL,
  `Admission_Date` date DEFAULT NULL,
  `Discharge_Date` date DEFAULT NULL,
  PRIMARY KEY (`Admission_ID`),
  KEY `Patient_ID` (`Patient_ID`),
  KEY `Room_ID` (`Room_ID`),
  CONSTRAINT `admissions_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patien` (`Patient_ID`),
  CONSTRAINT `admissions_ibfk_2` FOREIGN KEY (`Room_ID`) REFERENCES `rooms` (`Room_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admissions`
--

LOCK TABLES `admissions` WRITE;
/*!40000 ALTER TABLE `admissions` DISABLE KEYS */;
INSERT INTO `admissions` VALUES (801,301,402,'2026-08-20','2026-08-25'),(802,302,404,'2026-08-21','2026-08-24'),(803,303,406,'2026-08-22','2026-08-29'),(804,304,408,'2026-08-23','2026-08-26'),(805,305,410,'2026-08-24','2026-09-01'),(806,306,402,'2026-08-25','2026-08-28'),(807,307,404,'2026-08-26','2026-08-30'),(808,308,406,'2026-08-27','2026-09-02'),(809,309,408,'2026-08-28','2026-09-01'),(810,310,410,'2026-08-29','2026-09-03');
/*!40000 ALTER TABLE `admissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `Appointment_ID` int NOT NULL,
  `Patient_ID` int DEFAULT NULL,
  `Doctor_id` int DEFAULT NULL,
  `Appointment_Date` date DEFAULT NULL,
  `Appointment_Time` time DEFAULT NULL,
  `Status` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`Appointment_ID`),
  KEY `Patient_ID` (`Patient_ID`),
  KEY `Doctor_id` (`Doctor_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patien` (`Patient_ID`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`Doctor_id`) REFERENCES `doctor` (`Doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,1,1,'2026-11-01',NULL,NULL),(701,301,201,'2026-09-01','09:00:00','Completed'),(702,302,202,'2026-09-01','10:00:00','Completed'),(703,303,203,'2026-09-02','11:00:00','Completed'),(704,304,204,'2026-09-02','12:00:00','Scheduled'),(705,305,205,'2026-09-03','09:30:00','Completed'),(706,306,206,'2026-09-03','10:30:00','Scheduled'),(707,307,207,'2026-09-04','11:30:00','Scheduled'),(708,308,208,'2026-09-04','14:00:00','Completed');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `Bill_ID` int NOT NULL,
  `Patient_ID` int DEFAULT NULL,
  `Bill_Date` date DEFAULT NULL,
  `Consultation_Fee` decimal(10,2) DEFAULT NULL,
  `Room_Charges` decimal(10,2) DEFAULT NULL,
  `Medicine_Charges` decimal(10,2) DEFAULT NULL,
  `Total_Amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Bill_ID`),
  KEY `Patient_ID` (`Patient_ID`),
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patien` (`Patient_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1001,301,'2026-09-01',800.00,7500.00,500.00,8800.00),(1002,302,'2026-09-01',700.00,7500.00,350.00,8550.00),(1003,303,'2026-09-02',900.00,28000.00,800.00,29700.00),(1004,304,'2026-09-02',600.00,18000.00,250.00,18850.00),(1005,305,'2026-09-03',1000.00,64000.00,1200.00,66200.00),(1006,306,'2026-09-03',750.00,4500.00,400.00,5650.00),(1007,307,'2026-09-04',650.00,10000.00,600.00,11250.00),(1008,308,'2026-09-04',850.00,28000.00,900.00,29750.00),(1009,309,'2026-09-05',700.00,30000.00,450.00,31150.00),(1010,310,'2026-09-05',800.00,40000.00,500.00,41300.00);
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `Department_id` int NOT NULL,
  `Department_name` varchar(100) NOT NULL,
  `Location` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (101,'Cardiology','New Block A'),(102,'Neurology','Block B'),(103,'Orthopedics','Block C'),(104,'Pediatrics','Block D'),(105,'General Medicine','Block E'),(106,'Dermatology','Block F'),(107,'ENT','Block G'),(108,'Gynecology','Block H'),(109,'Ophthalmology','Block I'),(110,'Dental','Block J');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `Doctor_id` int NOT NULL,
  `Doctor_name` varchar(100) NOT NULL,
  `Specialization` varchar(100) DEFAULT NULL,
  `Phone_Num` varchar(100) DEFAULT NULL,
  `Department_id` int DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Doctor_id`),
  KEY `Department_id` (`Department_id`),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`Department_id`) REFERENCES `department` (`Department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'Dr. Mehta',NULL,NULL,NULL,NULL),(201,'Sakshi','Senior Cardiologist','9876543210',101,NULL),(202,'Dr. Priya Mehta','Neurologist','9876543211',102,NULL),(203,'Dr. Amit Patil','Orthopedic Surgeon','9876543212',103,NULL),(204,'Dr. Neha Joshi','Pediatrician','9876543213',104,NULL),(205,'Dr. Rahul Deshmukh','General Physician','9876543214',105,NULL),(206,'Dr. Sneha Kulkarni','Dermatologist','9876543215',106,NULL),(207,'Dr. Akash More','ENT Specialist','9876543216',107,NULL),(208,'Dr. Pooja Shah','Gynecologist','9876543217',108,NULL),(209,'Dr. Vikram Rao','Ophthalmologist','9876543218',109,NULL),(210,'Dr. Kavita Singh','Dentist','9876543219',110,NULL);
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicines`
--

DROP TABLE IF EXISTS `medicines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicines` (
  `Medicine_ID` int NOT NULL,
  `Medicine_Name` varchar(100) NOT NULL,
  `Manufacturer` varchar(100) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `Stock_Quantity` int DEFAULT NULL,
  PRIMARY KEY (`Medicine_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicines`
--

LOCK TABLES `medicines` WRITE;
/*!40000 ALTER TABLE `medicines` DISABLE KEYS */;
INSERT INTO `medicines` VALUES (501,'Paracetamol','Cipla',25.00,500),(502,'Amoxicillin','Sun Pharma',80.00,300),(503,'Azithromycin','Zydus',120.00,250),(504,'Ibuprofen','Abbott',45.00,400),(505,'Cetirizine','Dr. Reddy\'s',30.00,350),(506,'Omeprazole','Lupin',55.00,280),(507,'Metformin','Cipla',70.00,200),(508,'Amlodipine','Sun Pharma',65.00,220),(509,'Pantoprazole','Alkem',50.00,300),(510,'Diclofenac','Novartis',40.00,180);
/*!40000 ALTER TABLE `medicines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patien`
--

DROP TABLE IF EXISTS `patien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patien` (
  `Patient_ID` int NOT NULL,
  `Patient_Name` varchar(100) NOT NULL,
  `Gender` varchar(10) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  `Address` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`Patient_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patien`
--

LOCK TABLES `patien` WRITE;
/*!40000 ALTER TABLE `patien` DISABLE KEYS */;
INSERT INTO `patien` VALUES (1,'Test','Male',30,'9876543210','Pune'),(104,'Sneha Patil','Female',28,NULL,'Pune'),(301,'Aarav Kulkarni','Male',35,'9999999999','Mumbai'),(302,'Sneha Patil','Female',28,'9876500002','Mumbai'),(303,'Rohan Shah','Male',45,'9876500003','Nashik'),(304,'Ananya Desai','Female',12,'9876500004','Pune'),(305,'Vikram Joshi','Male',60,'9876500005','Nagpur'),(306,'Kiran More','Female',32,'9876500006','Satara'),(307,'Aditya Rao','Male',25,'9876500007','Kolhapur'),(308,'Meera Nair','Female',50,'9876500008','Pune'),(309,'Sahil Verma','Male',18,'9876500009','Mumbai'),(310,'Isha Gupta','Female',40,'9876500010','Nashik'),(9997,'Trigger Test','Male',25,'9999999999','Pune'),(9999,'Test Patient','Male',5,'9999999999','Pune');
/*!40000 ALTER TABLE `patien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_audit`
--

DROP TABLE IF EXISTS `patient_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_audit` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT NULL,
  `action_type` varchar(20) DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_audit`
--

LOCK TABLES `patient_audit` WRITE;
/*!40000 ALTER TABLE `patient_audit` DISABLE KEYS */;
INSERT INTO `patient_audit` VALUES (1,9997,'INSERT','2026-10-22 14:16:24');
/*!40000 ALTER TABLE `patient_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_update_log`
--

DROP TABLE IF EXISTS `patient_update_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_update_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `message` varchar(100) DEFAULT NULL,
  `log_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_update_log`
--

LOCK TABLES `patient_update_log` WRITE;
/*!40000 ALTER TABLE `patient_update_log` DISABLE KEYS */;
INSERT INTO `patient_update_log` VALUES (1,'Patient update statement executed','2026-10-22 14:20:00');
/*!40000 ALTER TABLE `patient_update_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescriptions`
--

DROP TABLE IF EXISTS `prescriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescriptions` (
  `Prescription_ID` int NOT NULL,
  `Patient_ID` int DEFAULT NULL,
  `Doctor_id` int DEFAULT NULL,
  `Medicine_ID` int DEFAULT NULL,
  `Dosage` varchar(100) DEFAULT NULL,
  `Prescription_Date` date DEFAULT NULL,
  PRIMARY KEY (`Prescription_ID`),
  KEY `Patient_ID` (`Patient_ID`),
  KEY `Doctor_id` (`Doctor_id`),
  KEY `Medicine_ID` (`Medicine_ID`),
  CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patien` (`Patient_ID`),
  CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`Doctor_id`) REFERENCES `doctor` (`Doctor_id`),
  CONSTRAINT `prescriptions_ibfk_3` FOREIGN KEY (`Medicine_ID`) REFERENCES `medicines` (`Medicine_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescriptions`
--

LOCK TABLES `prescriptions` WRITE;
/*!40000 ALTER TABLE `prescriptions` DISABLE KEYS */;
INSERT INTO `prescriptions` VALUES (901,301,201,508,'1 tablet twice daily','2026-09-01'),(902,302,202,501,'1 tablet after meal','2026-09-01'),(903,303,203,510,'1 tablet twice daily','2026-09-02'),(904,304,204,501,'1 tablet once daily','2026-09-02'),(905,305,205,507,'1 tablet twice daily','2026-09-03'),(906,306,206,505,'1 tablet at night','2026-09-03'),(907,307,207,503,'1 tablet once daily','2026-09-04'),(908,308,208,506,'1 capsule before meal','2026-09-04'),(909,309,209,509,'1 tablet once daily','2026-09-05'),(910,310,210,504,'1 tablet twice daily','2026-09-05');
/*!40000 ALTER TABLE `prescriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `Room_ID` int NOT NULL,
  `Room_Number` varchar(20) DEFAULT NULL,
  `Room_Type` varchar(50) DEFAULT NULL,
  `Charges_Per_Day` decimal(10,2) DEFAULT NULL,
  `Availability` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Room_ID`),
  UNIQUE KEY `Room_Number` (`Room_Number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (401,'A101','General',1500.00,'Available'),(402,'A102','General',1500.00,'Occupied'),(403,'A103','Semi-Private',2500.00,'Available'),(404,'A104','Semi-Private',2500.00,'Occupied'),(405,'B201','Private',4000.00,'Available'),(406,'B202','Private',4000.00,'Occupied'),(407,'B203','Deluxe',6000.00,'Available'),(408,'B204','Deluxe',6000.00,'Occupied'),(409,'C301','ICU',8000.00,'Available'),(410,'C302','ICU',8000.00,'Occupied');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_appointment_details`
--

DROP TABLE IF EXISTS `v_appointment_details`;
/*!50001 DROP VIEW IF EXISTS `v_appointment_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_appointment_details` AS SELECT 
 1 AS `Appointment_ID`,
 1 AS `Patient_ID`,
 1 AS `Patient_Name`,
 1 AS `Doctor_Name`,
 1 AS `Appointment_Date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_gender_count`
--

DROP TABLE IF EXISTS `v_gender_count`;
/*!50001 DROP VIEW IF EXISTS `v_gender_count`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_gender_count` AS SELECT 
 1 AS `Gender`,
 1 AS `total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_patient_basic`
--

DROP TABLE IF EXISTS `v_patient_basic`;
/*!50001 DROP VIEW IF EXISTS `v_patient_basic`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_patient_basic` AS SELECT 
 1 AS `Patient_ID`,
 1 AS `Patient_Name`,
 1 AS `Age`,
 1 AS `Gender`,
 1 AS `Address`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_patient_calc`
--

DROP TABLE IF EXISTS `v_patient_calc`;
/*!50001 DROP VIEW IF EXISTS `v_patient_calc`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_patient_calc` AS SELECT 
 1 AS `Patient_ID`,
 1 AS `Patient_Name`,
 1 AS `Age`,
 1 AS `age_after_5`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_pune_patients`
--

DROP TABLE IF EXISTS `v_pune_patients`;
/*!50001 DROP VIEW IF EXISTS `v_pune_patients`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_pune_patients` AS SELECT 
 1 AS `Patient_ID`,
 1 AS `Patient_Name`,
 1 AS `Age`,
 1 AS `Gender`,
 1 AS `Address`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_appointment_details`
--

/*!50001 DROP VIEW IF EXISTS `v_appointment_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_appointment_details` AS select `a`.`Appointment_ID` AS `Appointment_ID`,`p`.`Patient_ID` AS `Patient_ID`,`p`.`Patient_Name` AS `Patient_Name`,`d`.`Doctor_name` AS `Doctor_Name`,`a`.`Appointment_Date` AS `Appointment_Date` from ((`appointments` `a` join `patien` `p` on((`a`.`Patient_ID` = `p`.`Patient_ID`))) join `doctor` `d` on((`a`.`Doctor_id` = `d`.`Doctor_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_gender_count`
--

/*!50001 DROP VIEW IF EXISTS `v_gender_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_gender_count` AS select `patien`.`Gender` AS `Gender`,count(0) AS `total` from `patien` group by `patien`.`Gender` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_patient_basic`
--

/*!50001 DROP VIEW IF EXISTS `v_patient_basic`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_patient_basic` AS select `patien`.`Patient_ID` AS `Patient_ID`,`patien`.`Patient_Name` AS `Patient_Name`,`patien`.`Age` AS `Age`,`patien`.`Gender` AS `Gender`,`patien`.`Address` AS `Address` from `patien` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_patient_calc`
--

/*!50001 DROP VIEW IF EXISTS `v_patient_calc`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_patient_calc` AS select `patien`.`Patient_ID` AS `Patient_ID`,`patien`.`Patient_Name` AS `Patient_Name`,`patien`.`Age` AS `Age`,(`patien`.`Age` + 5) AS `age_after_5` from `patien` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_pune_patients`
--

/*!50001 DROP VIEW IF EXISTS `v_pune_patients`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_pune_patients` AS select `patien`.`Patient_ID` AS `Patient_ID`,`patien`.`Patient_Name` AS `Patient_Name`,`patien`.`Age` AS `Age`,`patien`.`Gender` AS `Gender`,`patien`.`Address` AS `Address` from `patien` where (`patien`.`Address` = 'Pune') */
/*!50002 WITH CASCADED CHECK OPTION */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-02 19:25:19
