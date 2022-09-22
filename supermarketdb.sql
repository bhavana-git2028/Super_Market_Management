-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 16, 2021 at 06:41 AM
-- Server version: 5.7.31
-- PHP Version: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `supermarketdb`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `totalAmount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `totalAmount` (IN `billno` INT(9) UNSIGNED)  SELECT SUM(amount) FROM cart WHERE bill_no = billno$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
CREATE TABLE IF NOT EXISTS `address` (
  `zipcode` int(6) NOT NULL,
  `state` varchar(255) NOT NULL,
  `district` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  PRIMARY KEY (`zipcode`),
  UNIQUE KEY `zipcode` (`zipcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `billing_counter`
--

DROP TABLE IF EXISTS `billing_counter`;
CREATE TABLE IF NOT EXISTS `billing_counter` (
  `bill_no` int(9) NOT NULL AUTO_INCREMENT,
  `customer_id` int(4) NOT NULL,
  `employee_id` int(3) NOT NULL,
  `bdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bill_no`),
  UNIQUE KEY `bill_no` (`bill_no`),
  KEY `fk_bcid` (`customer_id`),
  KEY `fk_beid` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE IF NOT EXISTS `cart` (
  `cart_id` int(4) NOT NULL AUTO_INCREMENT,
  `model_id` int(5) NOT NULL,
  `quantity` int(3) NOT NULL,
  `amount` int(8) NOT NULL,
  `bill_no` int(9) NOT NULL,
  PRIMARY KEY (`cart_id`),
  KEY `fk_cbno` (`bill_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `cart`
--
DROP TRIGGER IF EXISTS `amounts`;
DELIMITER $$
CREATE TRIGGER `amounts` BEFORE INSERT ON `cart` FOR EACH ROW BEGIN
UPDATE p_name,product
SET p_name.quantity=p_name.quantity-NEW.QUANTITY
WHERE NEW.MODEL_ID=product.model_id AND
product.name_id=p_name.name_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `customer_id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_no` bigint(10) NOT NULL,
  `zipcode` int(6) NOT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `fk_zipcode` (`zipcode`)
) ENGINE=InnoDB AUTO_INCREMENT=2231 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `employee_id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_no` bigint(10) NOT NULL,
  `role` varchar(255) NOT NULL,
  `zipcode` int(6) NOT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `fk_ezip` (`zipcode`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
CREATE TABLE IF NOT EXISTS `payment` (
  `payment_id` int(8) NOT NULL AUTO_INCREMENT,
  `customer_id` int(4) NOT NULL,
  `pdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` int(8) NOT NULL,
  `mode` varchar(255) NOT NULL,
  `bill_no` int(9) NOT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `fk_pbno` (`bill_no`),
  KEY `fk_pcid` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `model_id` int(5) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `name_id` int(5) NOT NULL,
  PRIMARY KEY (`model_id`),
  KEY `fk_pnid` (`name_id`),
  KEY `fk_ptype` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=12124 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`model_id`, `type`, `name_id`) VALUES
(12111, 'Tea Powder', 1),
(12122, 'Toothpaste', 14),
(12123, 'Mobile', 15);

-- --------------------------------------------------------

--
-- Table structure for table `product_shelves`
--

DROP TABLE IF EXISTS `product_shelves`;
CREATE TABLE IF NOT EXISTS `product_shelves` (
  `shelf_id` int(2) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  PRIMARY KEY (`shelf_id`,`type`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product_shelves`
--

INSERT INTO `product_shelves` (`shelf_id`, `type`, `category`) VALUES
(1, 'Tea Powder', 'Daily Needs'),
(10, 'Toothpaste', 'Daily Needs'),
(18, 'Perfumes', 'Daily needs'),
(19, 'Mobile', 'Electronics');

-- --------------------------------------------------------

--
-- Table structure for table `p_name`
--

DROP TABLE IF EXISTS `p_name`;
CREATE TABLE IF NOT EXISTS `p_name` (
  `name_id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(8) NOT NULL,
  `quantity` int(3) NOT NULL,
  PRIMARY KEY (`name_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `p_name`
--

INSERT INTO `p_name` (`name_id`, `name`, `price`, `quantity`) VALUES
(1, 'Red Label Natural Care 500g', 228, 183),
(14, 'Colgate', 50, 199),
(15, 'Redmi Note8 Pro 6GB and 64GB', 14999, 200);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `name`) VALUES
(2, 'admin', 'admin', 'admin'),
(3, 'user', 'user', 'user');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing_counter`
--
ALTER TABLE `billing_counter`
  ADD CONSTRAINT `fk_bcid` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_beid` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `fk_cbno` FOREIGN KEY (`bill_no`) REFERENCES `billing_counter` (`bill_no`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `fk_zipcode` FOREIGN KEY (`zipcode`) REFERENCES `address` (`zipcode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `fk_ezip` FOREIGN KEY (`zipcode`) REFERENCES `address` (`zipcode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `fk_pbno` FOREIGN KEY (`bill_no`) REFERENCES `billing_counter` (`bill_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pcid` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_pnid` FOREIGN KEY (`name_id`) REFERENCES `p_name` (`name_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ptype` FOREIGN KEY (`type`) REFERENCES `product_shelves` (`type`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
