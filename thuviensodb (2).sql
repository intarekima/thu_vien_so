-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mysql1003.site4now.net
-- Generation Time: Jul 20, 2025 at 09:25 PM
-- Server version: 8.4.5
-- PHP Version: 8.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_abbaca_thso`
--

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `Id` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`Id`, `Name`, `Description`) VALUES
(21, 'Donald E. Knuth', '                        Author of The Art of Computer Programming, a pioneer in algorithm analysis.\r\n                    '),
(22, 'Linus Torvalds', '                        Creator of the Linux kernel, influential in open-source systems.\r\n\r\n                    '),
(23, 'Brian W. Kernighan	', '                        \r\n                    Co-author of The C Programming Language, foundational to software dev.\r\n'),
(24, 'Bjarne Stroustrup	', '                        \r\n                    Creator of the C++ programming language.\r\n'),
(25, 'Guido van Rossum	', '                        Creator of the Python programming language.\r\n\r\n                    '),
(26, 'Dennis Ritchie	', '                        Creator of the C language, co-creator of Unix.\r\n\r\n                    '),
(27, 'Andrew S. Tanenbaum	', '                        Known for textbooks on OS, networks, and distributed systems.\r\n\r\n                    '),
(28, 'Robert C. Martin	', '                        \r\n                    Author of Clean Code, advocate of software craftsmanship.\r\n'),
(29, 'Martin Fowler	', '                        Expert in software architecture and refactoring.\r\n\r\n                    '),
(30, 'Steve McConnell	', '                        Author of Code Complete, essential reading in software engineering.\r\n\r\n                    '),
(31, 'Eric S. Raymond	', '                        Open source advocate, author of The Cathedral and the Bazaar.\r\n\r\n                    '),
(32, 'Richard Stallman	', '                      Founder of the Free Software Foundation, key figure in GNU Project.\r\n\r\n  \r\n                    ');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `Id` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `ParentId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`Id`, `Name`, `Description`, `ParentId`) VALUES
(1, 'Programming', 'Topics related to programming languages and software development.', NULL),
(2, 'Web Development', 'Technologies for building web applications.', NULL),
(3, 'Cybersecurity', 'Protecting systems, networks, and data.', NULL),
(4, 'Cloud Computing', 'Internet-based computing and platforms.', NULL),
(5, 'Python', 'High-level programming language for general use.', 1),
(6, 'C/C++', 'Performance-oriented programming languages.', 1),
(7, 'Frontend', 'Client-side development with HTML/CSS/JS.', 2),
(8, 'Backend', 'Server-side logic and APIs.', 2),
(9, 'Ethical Hacking', 'Penetration testing and security analysis.', 3),
(10, 'Cryptography', 'Secure communication and data encryption.', 3),
(11, 'AWS', 'Amazon Web Services for cloud deployment.', 4),
(12, 'Azure', 'Microsoft Azure cloud ecosystem.', 4),
(39, 'Flask', 'Python web framework for lightweight apps.', 5),
(40, 'React.js', 'Frontend JavaScript library for building UIs.', 7),
(41, 'API Security', 'Protecting endpoints and authentication.', 9),
(42, 'Serverless', 'Function-based cloud architecture on AWS/Azure.', 11);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `Id` int NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(12) NOT NULL,
  `Subject` varchar(200) NOT NULL,
  `Message` text NOT NULL,
  `IsHandled` tinyint(1) NOT NULL DEFAULT '0',
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`Id`, `Name`, `Email`, `Phone`, `Subject`, `Message`, `IsHandled`, `CreatedAt`) VALUES
(16, 'dat', 'nomodo234@gmail.com', '0792170719', 'Tieu de', 'can hoi dap', 0, '2025-07-14 00:34:27'),
(17, 'Ngô Minh Đạt', 'intarekima@gmail.com', '0123456788', 'toi hoi', 'hoi dap', 0, '2025-07-15 04:46:33'),
(18, 'datdat', 'intarekima@gmail.com', '0123456799', 'hoi', 'can hoi dap', 0, '2025-07-15 04:47:03'),
(19, 'dat', 'sas@gmail.com', '0793456789', 'aaaa', 'addd', 0, '2025-07-16 23:51:01'),
(20, 'thu1', 'nomodo234@gmail.com', '0792170819', 'aaa', 'aaaaa', 0, '2025-07-16 23:52:00');

-- --------------------------------------------------------

--
-- Table structure for table `documentauthors`
--

CREATE TABLE `documentauthors` (
  `Id` int NOT NULL,
  `DocumentId` int NOT NULL,
  `AuthorId` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `documentauthors`
--

INSERT INTO `documentauthors` (`Id`, `DocumentId`, `AuthorId`) VALUES
(766, 122, 27),
(767, 122, 32),
(768, 121, 27),
(769, 120, 24),
(770, 120, 32),
(771, 119, 23),
(772, 119, 24),
(773, 118, 21),
(774, 118, 32),
(775, 117, 27),
(776, 117, 29),
(777, 116, 22),
(778, 115, 25),
(779, 115, 26),
(780, 114, 21),
(781, 114, 26),
(782, 113, 21),
(783, 112, 32),
(786, 110, 21),
(787, 110, 27),
(788, 109, 26),
(789, 109, 31),
(790, 108, 25),
(791, 107, 23),
(792, 107, 25),
(793, 106, 28),
(794, 106, 30),
(795, 105, 23),
(796, 104, 22),
(797, 104, 28),
(798, 103, 22),
(799, 103, 30),
(800, 102, 26),
(801, 102, 30),
(802, 101, 32),
(803, 100, 29),
(806, 98, 31),
(807, 97, 30),
(808, 97, 32),
(809, 96, 21),
(810, 96, 26),
(811, 95, 26),
(812, 94, 24),
(813, 93, 26),
(814, 93, 30),
(815, 92, 25),
(816, 92, 27),
(817, 91, 25),
(818, 90, 23),
(823, 89, 25),
(824, 89, 32),
(825, 131, 27),
(826, 131, 29),
(827, 130, 21),
(828, 130, 30),
(829, 129, 22),
(830, 129, 29),
(831, 128, 29),
(832, 127, 32),
(833, 126, 26),
(834, 126, 29),
(835, 125, 23),
(836, 125, 31),
(837, 124, 30),
(838, 124, 31),
(839, 123, 22),
(840, 123, 27),
(843, 99, 21),
(844, 99, 25),
(845, 111, 21),
(846, 111, 30),
(847, 132, 28);

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `Id` int NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `FileUrl` varchar(500) DEFAULT NULL,
  `PreviewFileUrl` varchar(500) DEFAULT NULL,
  `Thumb` varchar(255) DEFAULT NULL,
  `CategoryId` int DEFAULT NULL,
  `PublisherId` int DEFAULT NULL,
  `IsFree` tinyint(1) NOT NULL,
  `Price` decimal(18,2) DEFAULT NULL,
  `View` int DEFAULT NULL,
  `Purchase` int DEFAULT NULL,
  `Download` int DEFAULT NULL,
  `PublicDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ReprintDate` datetime DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`Id`, `Title`, `Description`, `FileUrl`, `PreviewFileUrl`, `Thumb`, `CategoryId`, `PublisherId`, `IsFree`, `Price`, `View`, `Purchase`, `Download`, `PublicDate`, `ReprintDate`, `CreatedAt`, `UpdatedAt`) VALUES
(89, 'Advanced Java Concepts', 'This is a technical guide on Topic 1 for developers and IT professionals.', '/documents/document-89/9328ec94-b67e-4807-ab6a-935d19d105a9.pdf', '/documents/document-89/preview_9328ec94-b67e-4807-ab6a-935d19d105a9.pdf', '/documents/document-89/thumb.jpg', 39, 15, 0, 7000.00, 112, 0, 72, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 09:05:18'),
(90, 'Learning C++ Step by Step', 'This is a technical guide on Topic 2 for developers and IT professionals.', '/documents/document-90/a341e16b-b1de-40b4-9232-8437e3af9e9b.pdf', '/documents/document-90/preview_a341e16b-b1de-40b4-9232-8437e3af9e9b.pdf', '/documents/document-90/thumb.jpg', 11, 14, 0, 10000.00, 68, 0, 30, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 08:01:22'),
(91, 'Deep Learning with TensorFlow', 'This is a technical guide on Topic 3 for developers and IT professionals.', '/documents/document-91/50e7623a-50cb-4fd6-9911-4c5cf3bf2629.pdf', '/documents/document-91/preview_50e7623a-50cb-4fd6-9911-4c5cf3bf2629.pdf', '/documents/document-91/thumb.jpg', 41, 7, 0, 12000.00, 70, 1, 18, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 08:59:50'),
(92, 'Visual Studio Code Productivity Tips', 'This is a technical guide on Topic 4 for developers and IT professionals.', '/documents/document-92/e43e5bda-ff83-409a-a1fa-9068fb17180c.pdf', '/documents/document-92/preview_e43e5bda-ff83-409a-a1fa-9068fb17180c.pdf', '/documents/document-92/thumb.jpg', 5, 6, 1, 19000.00, 96, 0, 13, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 06:51:12'),
(93, 'System Design Interviews Explained', 'This is a technical guide on Topic 5 for developers and IT professionals.', '/documents/document-93/1c371217-4573-440e-9cb7-6028c2b9b49e.pdf', '/documents/document-93/preview_1c371217-4573-440e-9cb7-6028c2b9b49e.pdf', '/documents/document-93/thumb.jpg', 1, 8, 0, 13000.00, 72, 0, 69, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:40:27'),
(94, 'Excel for Data Analysis', 'This is a technical guide on Topic 6 for developers and IT professionals.', '/documents/document-94/24078151-c378-4e9d-94e7-f60dbf587c0c.pdf', '/documents/document-94/preview_24078151-c378-4e9d-94e7-f60dbf587c0c.pdf', '/documents/document-94/thumb.jpg', 10, 13, 1, 5000.00, 20, 0, 1, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:40:25'),
(95, 'Linux Command Line Essentials', 'This is a technical guide on Topic 7 for developers and IT professionals.', '/documents/document-95/03c6b0b1-1292-4b44-8532-66c0c30968cd.pdf', '/documents/document-95/preview_03c6b0b1-1292-4b44-8532-66c0c30968cd.pdf', '/documents/document-95/thumb.jpg', 6, 14, 0, 20000.00, 26, 0, 1, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:40:22'),
(96, 'Spark for Data Engineers', 'This is a technical guide on Topic 8 for developers and IT professionals.', '/documents/document-96/2dda3843-ddf2-4e51-8e13-31162906664a.pdf', '/documents/document-96/preview_2dda3843-ddf2-4e51-8e13-31162906664a.pdf', '/documents/document-96/thumb.jpg', 9, 6, 0, 15000.00, 88, 1, 73, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 10:07:21'),
(97, 'Digital Forensics Essentials', 'This is a technical guide on Topic 9 for developers and IT professionals.', '/documents/document-97/65d55d3d-5802-4827-b0b9-21f98c431e1d.pdf', '/documents/document-97/preview_65d55d3d-5802-4827-b0b9-21f98c431e1d.pdf', '/documents/document-97/thumb.jpg', 4, 12, 0, 16000.00, 102, 0, 9, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 08:53:38'),
(98, 'Frontend Development with React', 'This is a technical guide on Topic 10 for developers and IT professionals.', '/documents/document-98/daa57e89-c00e-4c3b-9855-c81b73a9af67.pdf', '/documents/document-98/preview_daa57e89-c00e-4c3b-9855-c81b73a9af67.pdf', '/documents/document-98/thumb.jpg', 40, 6, 1, 17000.00, 103, 0, 95, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-16 09:03:01'),
(99, 'Mastering Python for Data Science', 'This is a technical guide on Topic 11 for developers and IT professionals.', '/documents/document-99/c90bfab0-0397-4079-97b6-f264b23a6f68.pdf', '/documents/document-99/preview_c90bfab0-0397-4079-97b6-f264b23a6f68.pdf', '/documents/document-99/thumb.jpg', 40, 14, 0, 12000.00, 101, 1, 85, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 07:55:14'),
(100, 'Building Microservices with Spring Boot', 'This is a technical guide on Topic 12 for developers and IT professionals.', '/documents/document-100/0bc283f1-17ce-43fe-8363-d0e28ea1c983.pdf', '/documents/document-100/preview_0bc283f1-17ce-43fe-8363-d0e28ea1c983.pdf', '/documents/document-100/thumb.jpg', 4, 16, 0, 13000.00, 38, 0, 32, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-16 09:00:49'),
(101, 'SaaS Development Lifecycle', 'This is a technical guide on Topic 13 for developers and IT professionals.', '/documents/document-101/77b2b50c-b615-4902-8a97-83faa6821132.pdf', '/documents/document-101/preview_77b2b50c-b615-4902-8a97-83faa6821132.pdf', '/documents/document-101/thumb.jpg', 41, 7, 0, 20000.00, 41, 0, 32, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:40:01'),
(102, 'Introduction to Programming', 'This is a technical guide on Topic 14 for developers and IT professionals.', '/documents/document-102/d3b9f0d4-4af9-411e-ae4f-78eb862fd1db.pdf', '/documents/document-102/preview_d3b9f0d4-4af9-411e-ae4f-78eb862fd1db.pdf', '/documents/document-102/thumb.jpg', 3, 17, 0, 11000.00, 55, 0, 50, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:58'),
(103, 'Penetration Testing Basics', 'This is a technical guide on Topic 15 for developers and IT professionals.', '/documents/document-103/8dbb1cff-433b-4dfe-be48-21c588689063.pdf', '/documents/document-103/preview_8dbb1cff-433b-4dfe-be48-21c588689063.pdf', '/documents/document-103/thumb.jpg', 7, 16, 0, 18000.00, 40, 0, 6, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:54'),
(104, 'Time Series Analysis with Python', 'This is a technical guide on Topic 16 for developers and IT professionals.', '/documents/document-104/3dc30cd7-8433-4d9e-9564-19e15b2ba687.pdf', '/documents/document-104/preview_3dc30cd7-8433-4d9e-9564-19e15b2ba687.pdf', '/documents/document-104/thumb.jpg', 7, 14, 1, 18000.00, 64, 0, 63, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:52'),
(105, 'Security Best Practices for Developers', 'This is a technical guide on Topic 17 for developers and IT professionals.', '/documents/document-105/e0284931-4ba8-43cb-ad02-760ca988c153.pdf', '/documents/document-105/preview_e0284931-4ba8-43cb-ad02-760ca988c153.pdf', '/documents/document-105/thumb.jpg', 6, 7, 0, 12000.00, 72, 0, 22, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:49'),
(106, 'Operating Systems: Concepts and Design', 'This is a technical guide on Topic 18 for developers and IT professionals.', '/documents/document-106/27f14cc5-4aee-4be3-a9ba-c1156ebc4ed9.pdf', '/documents/document-106/preview_27f14cc5-4aee-4be3-a9ba-c1156ebc4ed9.pdf', '/documents/document-106/thumb.jpg', 6, 14, 0, 5000.00, 25, 0, 17, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:44'),
(107, 'Technical Writing for Developers', 'This is a technical guide on Topic 19 for developers and IT professionals.', '/documents/document-107/c1f12e87-e1f5-417c-86e4-8422d2b1450a.pdf', '/documents/document-107/preview_c1f12e87-e1f5-417c-86e4-8422d2b1450a.pdf', '/documents/document-107/thumb.jpg', 11, 11, 0, 3000.00, 28, 0, 23, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:41'),
(108, 'Practical Git and Version Control', 'This is a technical guide on Topic 20 for developers and IT professionals.', '/documents/document-108/85f278ed-70d9-4c13-95c7-2387e2fdce5f.pdf', '/documents/document-108/preview_85f278ed-70d9-4c13-95c7-2387e2fdce5f.pdf', '/documents/document-108/thumb.jpg', 4, 6, 0, 20000.00, 63, 0, 34, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:38'),
(109, 'Vue.js Crash Course', 'This is a technical guide on Topic 21 for developers and IT professionals.', '/documents/document-109/a0227b5b-b52a-44e8-b8a0-2822ef7acc3b.pdf', '/documents/document-109/preview_a0227b5b-b52a-44e8-b8a0-2822ef7acc3b.pdf', '/documents/document-109/thumb.jpg', 3, 15, 1, 3000.00, 21, 0, 8, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:35'),
(110, 'Python for Automation', 'This is a technical guide on Topic 22 for developers and IT professionals.', '/documents/document-110/9c903722-733b-48d6-b670-7bad5a4a2feb.pdf', '/documents/document-110/preview_9c903722-733b-48d6-b670-7bad5a4a2feb.pdf', '/documents/document-110/thumb.jpg', 39, 9, 1, 9000.00, 84, 0, 81, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:31'),
(111, 'Cybersecurity Fundamentals', 'This is a technical guide on Topic 23 for developers and IT professionals.', NULL, NULL, NULL, 7, 13, 1, 6000.00, 44, 0, 8, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-16 08:50:39'),
(112, 'Machine Learning Algorithms in Practice', 'This is a technical guide on Topic 24 for developers and IT professionals.', '/documents/document-112/baff6e56-76ab-41e3-ad08-595cd51cc7e7.pdf', '/documents/document-112/preview_baff6e56-76ab-41e3-ad08-595cd51cc7e7.pdf', '/documents/document-112/thumb.jpg', 41, 9, 1, 5000.00, 25, 0, 3, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:26'),
(113, 'CompTIA Network+ Guide', 'This is a technical guide on Topic 25 for developers and IT professionals.', '/documents/document-113/b0ecabf7-34ff-4f4d-841a-df9141ab994c.pdf', '/documents/document-113/preview_b0ecabf7-34ff-4f4d-841a-df9141ab994c.pdf', '/documents/document-113/thumb.jpg', 6, 9, 0, 9000.00, 77, 0, 48, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:23'),
(114, 'Mobile App Development with Flutter', 'This is a technical guide on Topic 26 for developers and IT professionals.', '/documents/document-114/4ec6bc45-d961-4c18-9ea9-dbf42a58f033.pdf', '/documents/document-114/preview_4ec6bc45-d961-4c18-9ea9-dbf42a58f033.pdf', '/documents/document-114/thumb.jpg', 1, 9, 0, 5000.00, 19, 0, 5, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:20'),
(115, 'Getting Started with Microsoft Azure', 'This is a technical guide on Topic 27 for developers and IT professionals.', '/documents/document-115/4225998a-69f0-4db0-8f3f-48fee277bc44.pdf', '/documents/document-115/preview_4225998a-69f0-4db0-8f3f-48fee277bc44.pdf', '/documents/document-115/thumb.jpg', 9, 10, 1, 19000.00, 71, 0, 69, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:18'),
(116, 'Hacking for Beginners', 'This is a technical guide on Topic 28 for developers and IT professionals.', '/documents/document-116/605b4cc0-21d9-42d7-bfeb-4b245f2d92ca.pdf', NULL, '/documents/document-116/thumb.jpg', 12, 14, 0, 15000.00, 82, 1, 39, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 07:43:19'),
(117, 'Cryptography Demystified', 'This is a technical guide on Topic 29 for developers and IT professionals.', '/documents/document-117/f7cb03ae-a993-472f-abbd-94d9b8076602.pdf', '/documents/document-117/preview_f7cb03ae-a993-472f-abbd-94d9b8076602.pdf', '/documents/document-117/thumb.jpg', 41, 12, 1, 13000.00, 23, 0, 20, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:11'),
(118, 'CCNA Routing and Switching', 'This is a technical guide on Topic 30 for developers and IT professionals.', '/documents/document-118/3f0e6dd6-c801-4d7b-a48d-54518dc84877.pdf', '/documents/document-118/preview_3f0e6dd6-c801-4d7b-a48d-54518dc84877.pdf', '/documents/document-118/thumb.jpg', 4, 17, 1, 16000.00, 54, 0, 35, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 08:25:45'),
(119, 'Cloud Computing Basics with AWS', 'This is a technical guide on Topic 31 for developers and IT professionals.', '/documents/document-119/10f32e85-d93e-4ffb-ab80-d00ae589d347.pdf', '/documents/document-119/preview_10f32e85-d93e-4ffb-ab80-d00ae589d347.pdf', '/documents/document-119/thumb.jpg', 6, 14, 1, 12000.00, 28, 0, 20, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:06'),
(120, 'Linux Shell Scripting', 'This is a technical guide on Topic 32 for developers and IT professionals.', '/documents/document-120/892ff4e0-7abe-4658-a6a0-195a5ad1b812.pdf', '/documents/document-120/preview_892ff4e0-7abe-4658-a6a0-195a5ad1b812.pdf', '/documents/document-120/thumb.jpg', 40, 15, 0, 7000.00, 18, 0, 2, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 09:05:14'),
(121, 'Embedded Systems Overview', 'This is a technical guide on Topic 33 for developers and IT professionals.', '/documents/document-121/fab041f7-f218-4d1f-ae5d-aba94717e121.pdf', '/documents/document-121/preview_fab041f7-f218-4d1f-ae5d-aba94717e121.pdf', '/documents/document-121/thumb.jpg', 39, 8, 0, 17000.00, 42, 0, 7, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:39:00'),
(122, 'Design Patterns in Software Engineering', 'This is a technical guide on Topic 34 for developers and IT professionals.', '/documents/document-122/2d0f4641-3c85-48e0-8eb0-397b2902081c.pdf', '/documents/document-122/preview_2d0f4641-3c85-48e0-8eb0-397b2902081c.pdf', '/documents/document-122/thumb.jpg', 9, 7, 0, 2000.00, 59, 0, 35, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 14:38:57'),
(123, 'DevOps and CI/CD with GitHub Actions', 'This is a technical guide on Topic 35 for developers and IT professionals.', '/documents/document-123/fd26197b-8df1-42c9-9b4a-a6dc417cb83a.pdf', '/documents/document-123/preview_fd26197b-8df1-42c9-9b4a-a6dc417cb83a.pdf', '/documents/document-123/thumb.jpg', 42, 17, 0, 9000.00, 35, 0, 3, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 15:07:36'),
(124, 'Clean Code Principles', 'This is a technical guide on Topic 36 for developers and IT professionals.', '/documents/document-124/35e212a1-027d-457f-8e87-3b62cc890e80.pdf', '/documents/document-124/preview_35e212a1-027d-457f-8e87-3b62cc890e80.pdf', '/documents/document-124/thumb.jpg', 40, 15, 1, 14000.00, 82, 0, 32, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 15:07:34'),
(125, 'NLP with spaCy and NLTK', 'This is a technical guide on Topic 37 for developers and IT professionals.', '/documents/document-125/861ab37d-d0da-4175-8bf2-0cd0dab17634.pdf', '/documents/document-125/preview_861ab37d-d0da-4175-8bf2-0cd0dab17634.pdf', '/documents/document-125/thumb.jpg', 4, 9, 0, 17000.00, 83, 0, 81, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 07:30:29'),
(126, 'API Development Best Practices', 'This is a technical guide on Topic 38 for developers and IT professionals.', '/documents/document-126/18363cfa-6c55-4a88-aaf9-36ca55ca7df4.pdf', '/documents/document-126/preview_18363cfa-6c55-4a88-aaf9-36ca55ca7df4.pdf', '/documents/document-126/thumb.jpg', 4, 11, 1, 2000.00, 84, 0, 67, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 15:07:30'),
(127, 'JavaScript ES6 in Depth', 'This is a technical guide on Topic 39 for developers and IT professionals.', '/documents/document-127/7f3ac22a-a047-4857-bde0-78890781c2c2.pdf', '/documents/document-127/preview_7f3ac22a-a047-4857-bde0-78890781c2c2.pdf', '/documents/document-127/thumb.jpg', 6, 9, 0, 7000.00, 66, 0, 54, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 15:07:27'),
(128, 'Internet of Things with Raspberry Pi', 'This is a technical guide on Topic 40 for developers and IT professionals.', '/documents/document-128/d4d7bbd6-dc0f-42a8-b712-22d19a4b0a33.pdf', '/documents/document-128/preview_d4d7bbd6-dc0f-42a8-b712-22d19a4b0a33.pdf', '/documents/document-128/thumb.jpg', 7, 13, 0, 18000.00, 67, 0, 43, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 15:07:25'),
(129, 'Firebase for Web Developers', 'This is a technical guide on Topic 41 for developers and IT professionals.', '/documents/document-129/24da5bab-fb1c-4282-afb9-31996c0d27ba.pdf', '/documents/document-129/preview_24da5bab-fb1c-4282-afb9-31996c0d27ba.pdf', '/documents/document-129/thumb.jpg', 5, 11, 1, 10000.00, 69, 0, 3, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-14 15:07:23'),
(130, 'Quantum Computing Introduction', 'This is a technical guide on Topic 42 for developers and IT professionals.', '/documents/document-130/61ff8e5f-0ebe-4d97-9cba-01518faa0cd1.pdf', '/documents/document-130/preview_61ff8e5f-0ebe-4d97-9cba-01518faa0cd1.pdf', '/documents/document-130/thumb.jpg', 8, 10, 1, 14000.00, 98, 0, 89, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 08:54:16'),
(131, 'Big Data Concepts with Hadoop', 'This is a technical guide on Topic 43 for developers and IT professionals.', '/documents/document-131/d29d50ea-2814-4217-afc0-0174c25797d8.pdf', '/documents/document-131/preview_d29d50ea-2814-4217-afc0-0174c25797d8.pdf', '/documents/document-131/thumb.jpg', 11, 6, 1, 2000.00, 110, 0, 12, '2025-07-17 20:51:20', NULL, '2025-06-18 16:02:13', '2025-07-17 09:14:30'),
(132, 'Data Visualization with Matplotlib', 'This is a technical guide on Topic 44 for developers and IT professionals.', '/documents/document-132/06efae8b-71a3-408e-8616-908851e6789e.pdf', '/documents/document-132/preview_06efae8b-71a3-408e-8616-908851e6789e.pdf', '/documents/document-132/thumb.jpg', 41, 8, 0, 8000.00, 41, 0, 6, '2025-07-17 00:00:00', '2026-01-18 00:00:00', '2025-06-18 16:02:13', '2025-07-18 04:00:01');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `Id` int NOT NULL,
  `UserId` int NOT NULL,
  `DocumentId` int NOT NULL,
  `PercentPaid` decimal(5,2) NOT NULL DEFAULT '0.00',
  `TotalPrice` decimal(10,2) NOT NULL,
  `PricePaid` decimal(10,2) NOT NULL,
  `PaymentStatus` enum('pending','paid','failed','canceled') NOT NULL DEFAULT 'pending',
  `OrderCode` varchar(100) NOT NULL,
  `CheckoutUrl` text,
  `QrCodeUrl` text,
  `TransactionTime` datetime DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`Id`, `UserId`, `DocumentId`, `PercentPaid`, `TotalPrice`, `PricePaid`, `PaymentStatus`, `OrderCode`, `CheckoutUrl`, `QrCodeUrl`, `TransactionTime`, `CreatedAt`, `UpdatedAt`) VALUES
(34, 13, 89, 100.00, 7000.00, 7000.00, 'pending', '1750762217', 'https://pay.payos.vn/web/f2bad8c292c94c3bb3d76a19a6453f42', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADAIJ55120208QRIBFTTA5303704540470005802VN62120808TL89%201006304E346', NULL, '2025-06-24 10:49:51.491576', '2025-06-24 10:50:18.161796'),
(36, 16, 89, 100.00, 7000.00, 7000.00, 'pending', '1752585182', 'https://pay.payos.vn/web/98b8c00071ed4117bb4a822476086bce', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADIGQ40000208QRIBFTTA5303704540470005802VN62120808TL89%2010063048F0A', NULL, '2025-07-12 06:51:53.237594', '2025-07-15 06:13:03.576465'),
(37, 16, 99, 50.00, 12000.00, 6000.00, 'paid', '1752328500', 'https://pay.payos.vn/web/3f865348065f4665b905b5a7926caa57', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADHBZ13190208QRIBFTTA5303704540460005802VN62110807TL99%2050630410B8', '2025-07-12 06:55:56', '2025-07-12 06:55:01.826692', '2025-07-12 06:55:56.491159'),
(38, 16, 90, 25.00, 10000.00, 2500.00, 'pending', '1752478924', 'https://pay.payos.vn/web/365c8a3a0b5a4593a11d65d6f1811fac', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADHSO36400208QRIBFTTA5303704540425005802VN62110807TL90%202563047483', NULL, '2025-07-14 00:42:05.686822', '2025-07-14 00:42:05.686837'),
(39, 16, 116, 100.00, 15000.00, 15000.00, 'paid', '1752479106', 'https://pay.payos.vn/web/c547ed4ac8604ccdb72db7121c16e030', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADHSO97440208QRIBFTTA53037045405150005802VN62130809TL116%201006304D4DB', '2025-07-14 00:45:23', '2025-07-14 00:45:07.923778', '2025-07-14 00:45:22.857547'),
(40, 16, 91, 100.00, 12000.00, 12000.00, 'paid', '1752585250', 'https://pay.payos.vn/web/7ea4bd6d41e640d4a6aa3ca572939da2', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADIGQ64980208QRIBFTTA53037045405120005802VN62120808TL91%201006304B1B4', '2025-07-15 06:14:28', '2025-07-15 06:14:11.697453', '2025-07-15 06:14:28.038623'),
(41, 16, 120, 50.00, 7000.00, 3500.00, 'pending', '1752735656', 'https://pay.payos.vn/web/3607736239c34847b615d8817bff67fd', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADIYI87660208QRIBFTTA5303704540435005802VN62120808TL120%2050630495D5', NULL, '2025-07-17 00:00:23.667341', '2025-07-17 00:00:58.009655'),
(42, 16, 99, 100.00, 12000.00, 12000.00, 'pending', '1752735703', 'https://pay.payos.vn/web/0d54c8f29b474bfca01e6825cc8947a2', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADIYJ03670208QRIBFTTA5303704540460005802VN62130809TL99%2050006304DD2E', NULL, '2025-07-17 00:01:44.041332', '2025-07-17 00:01:44.041333'),
(43, 16, 96, 100.00, 15000.00, 15000.00, 'paid', '1752742994', 'https://pay.payos.vn/web/5965c91b5523405f8d838a190d9721b1', 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238570010A000000727012700069704220113VQRQADIZO16160208QRIBFTTA53037045405150005802VN62120808TL96%201006304950A', '2025-07-17 02:03:32', '2025-07-17 02:02:21.322808', '2025-07-17 02:03:31.954238');

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

CREATE TABLE `publishers` (
  `Id` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `publishers`
--

INSERT INTO `publishers` (`Id`, `Name`, `Description`) VALUES
(6, 'O\'Reilly Media', 'Famous for practical and professional tech books with animal covers.'),
(7, 'Apress', 'Publisher focused on open source, programming, and IT professional books.'),
(8, 'No Starch Press', 'Known for beginner-friendly and humorous tech books.'),
(9, 'Packt Publishing', 'Practical, hands-on books for developers and sysadmins.'),
(10, 'MIT Press', 'Academic publisher for computer science, AI, and theory.'),
(11, 'Pearson', 'Global leader in education and IT certifications.'),
(12, 'Wiley', 'Publishes textbooks and tech references.'),
(13, 'Springer', 'Scientific and technical publisher including computer science.'),
(14, 'Manning Publications', 'Books on software development and best practices.'),
(15, 'CRC Press', 'Specialized in engineering, IT security, and data science.'),
(16, 'Cambridge University Press', 'Academic publisher with computing and AI texts.'),
(17, 'McGraw-Hill', 'Broad-range education publisher, includes programming and engineering.');

-- --------------------------------------------------------

--
-- Table structure for table `qrcodes`
--

CREATE TABLE `qrcodes` (
  `Id` int NOT NULL,
  `DocumentId` int NOT NULL,
  `Type` enum('view','download') NOT NULL,
  `QrUrl` varchar(500) DEFAULT NULL,
  `ScanCount` int NOT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `qrcodes`
--

INSERT INTO `qrcodes` (`Id`, `DocumentId`, `Type`, `QrUrl`, `ScanCount`, `IsActive`) VALUES
(327, 122, 'view', '/documents/document-122/qr-view.png', 0, 1),
(328, 122, 'download', '/documents/document-122/qr-download.png', 0, 1),
(329, 121, 'view', '/documents/document-121/qr-view.png', 0, 1),
(330, 121, 'download', '/documents/document-121/qr-download.png', 0, 1),
(331, 120, 'view', '/documents/document-120/qr-view.png', 0, 1),
(332, 120, 'download', '/documents/document-120/qr-download.png', 0, 1),
(333, 119, 'view', '/documents/document-119/qr-view.png', 0, 1),
(334, 119, 'download', '/documents/document-119/qr-download.png', 0, 1),
(335, 118, 'view', '/documents/document-118/qr-view.png', 0, 1),
(336, 118, 'download', '/documents/document-118/qr-download.png', 0, 1),
(337, 117, 'view', '/documents/document-117/qr-view.png', 0, 1),
(338, 117, 'download', '/documents/document-117/qr-download.png', 0, 1),
(339, 116, 'view', '/documents/document-116/qr-view.png', 0, 1),
(340, 116, 'download', '/documents/document-116/qr-download.png', 0, 1),
(341, 115, 'view', '/documents/document-115/qr-view.png', 0, 1),
(342, 115, 'download', '/documents/document-115/qr-download.png', 0, 1),
(343, 114, 'view', '/documents/document-114/qr-view.png', 0, 1),
(344, 114, 'download', '/documents/document-114/qr-download.png', 0, 1),
(345, 113, 'view', '/documents/document-113/qr-view.png', 0, 1),
(346, 113, 'download', '/documents/document-113/qr-download.png', 0, 1),
(347, 112, 'view', '/documents/document-112/qr-view.png', 0, 1),
(348, 112, 'download', '/documents/document-112/qr-download.png', 0, 1),
(351, 110, 'view', '/documents/document-110/qr-view.png', 0, 1),
(352, 110, 'download', '/documents/document-110/qr-download.png', 0, 1),
(353, 109, 'view', '/documents/document-109/qr-view.png', 0, 1),
(354, 109, 'download', '/documents/document-109/qr-download.png', 0, 1),
(355, 108, 'view', '/documents/document-108/qr-view.png', 0, 1),
(356, 108, 'download', '/documents/document-108/qr-download.png', 0, 1),
(357, 107, 'view', '/documents/document-107/qr-view.png', 0, 1),
(358, 107, 'download', '/documents/document-107/qr-download.png', 0, 1),
(359, 106, 'view', '/documents/document-106/qr-view.png', 0, 1),
(360, 106, 'download', '/documents/document-106/qr-download.png', 0, 1),
(361, 105, 'view', '/documents/document-105/qr-view.png', 0, 1),
(362, 105, 'download', '/documents/document-105/qr-download.png', 0, 1),
(363, 104, 'view', '/documents/document-104/qr-view.png', 0, 1),
(364, 104, 'download', '/documents/document-104/qr-download.png', 0, 1),
(365, 103, 'view', '/documents/document-103/qr-view.png', 0, 1),
(366, 103, 'download', '/documents/document-103/qr-download.png', 0, 1),
(367, 102, 'view', '/documents/document-102/qr-view.png', 0, 1),
(368, 102, 'download', '/documents/document-102/qr-download.png', 0, 1),
(369, 101, 'view', '/documents/document-101/qr-view.png', 0, 1),
(370, 101, 'download', '/documents/document-101/qr-download.png', 0, 1),
(371, 100, 'view', '/documents/document-100/qr-view.png', 1, 1),
(372, 100, 'download', '/documents/document-100/qr-download.png', 1, 1),
(375, 98, 'view', '/documents/document-98/qr-view.png', 2, 1),
(376, 98, 'download', '/documents/document-98/qr-download.png', 1, 1),
(377, 97, 'view', '/documents/document-97/qr-view.png', 0, 1),
(378, 97, 'download', '/documents/document-97/qr-download.png', 0, 1),
(379, 96, 'view', '/documents/document-96/qr-view.png', 1, 1),
(380, 96, 'download', '/documents/document-96/qr-download.png', 0, 1),
(381, 95, 'view', '/documents/document-95/qr-view.png', 0, 1),
(382, 95, 'download', '/documents/document-95/qr-download.png', 0, 1),
(383, 94, 'view', '/documents/document-94/qr-view.png', 0, 1),
(384, 94, 'download', '/documents/document-94/qr-download.png', 0, 1),
(385, 93, 'view', '/documents/document-93/qr-view.png', 0, 1),
(386, 93, 'download', '/documents/document-93/qr-download.png', 0, 1),
(387, 92, 'view', '/documents/document-92/qr-view.png', 4, 1),
(388, 92, 'download', '/documents/document-92/qr-download.png', 0, 1),
(389, 91, 'view', '/documents/document-91/qr-view.png', 0, 1),
(390, 91, 'download', '/documents/document-91/qr-download.png', 0, 1),
(391, 90, 'view', '/documents/document-90/qr-view.png', 1, 1),
(392, 90, 'download', '/documents/document-90/qr-download.png', 0, 1),
(399, 89, 'view', '/documents/document-89/qr-view.png', 1, 1),
(400, 89, 'download', '/documents/document-89/qr-download.png', 0, 1),
(401, 131, 'view', '/documents/document-131/qr-view.png', 1, 1),
(402, 131, 'download', '/documents/document-131/qr-download.png', 1, 1),
(403, 130, 'view', '/documents/document-130/qr-view.png', 0, 1),
(404, 130, 'download', '/documents/document-130/qr-download.png', 1, 1),
(405, 129, 'view', '/documents/document-129/qr-view.png', 0, 1),
(406, 129, 'download', '/documents/document-129/qr-download.png', 0, 1),
(407, 128, 'view', '/documents/document-128/qr-view.png', 0, 1),
(408, 128, 'download', '/documents/document-128/qr-download.png', 0, 1),
(409, 127, 'view', '/documents/document-127/qr-view.png', 0, 1),
(410, 127, 'download', '/documents/document-127/qr-download.png', 0, 1),
(411, 126, 'view', '/documents/document-126/qr-view.png', 0, 1),
(412, 126, 'download', '/documents/document-126/qr-download.png', 0, 1),
(413, 125, 'view', '/documents/document-125/qr-view.png', 0, 1),
(414, 125, 'download', '/documents/document-125/qr-download.png', 0, 1),
(415, 124, 'view', '/documents/document-124/qr-view.png', 0, 1),
(416, 124, 'download', '/documents/document-124/qr-download.png', 0, 1),
(417, 123, 'view', '/documents/document-123/qr-view.png', 0, 1),
(418, 123, 'download', '/documents/document-123/qr-download.png', 0, 1),
(421, 99, 'view', '/documents/document-99/qr-view.png', 0, 1),
(422, 99, 'download', '/documents/document-99/qr-download.png', 1, 1),
(423, 111, 'view', '/documents/document-111/qr-view.png', 0, 1),
(424, 111, 'download', '/documents/document-111/qr-download.png', 0, 1),
(425, 132, 'view', '/documents/document-132/qr-view.png', 0, 1),
(426, 132, 'download', '/documents/document-132/qr-download.png', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `Id` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Phone` varchar(12) DEFAULT NULL,
  `Password` varchar(255) NOT NULL,
  `ResetCode` varchar(6) DEFAULT NULL,
  `Role` enum('admin','user') NOT NULL DEFAULT 'user',
  `ResetCodeExpiry` datetime DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`Id`, `Name`, `Email`, `Phone`, `Password`, `ResetCode`, `Role`, `ResetCodeExpiry`, `CreatedAt`, `UpdatedAt`) VALUES
(11, 'Admin Cường', 'admin_cuong@gmail.com', NULL, '$2a$11$.TzLfesioTpYpw1Mxo6xJOwAgsTmSJxg/01JD8Ue6hF.pBHX1AZQG', NULL, 'admin', NULL, '2025-06-18 16:21:41', '2025-06-18 16:21:41'),
(12, 'Admin Đạt', 'admin_dat@gmail.com', NULL, '$2a$11$G8OWNRDfR4lIUDEsy9Hup.m7MSFQw5ds5SnINXht2vsSbGHUZIZY6', NULL, 'admin', NULL, '2025-06-18 16:21:58', '2025-06-18 16:21:58'),
(13, 'Tesst', 'test1@gmail.com', '0350012312', '$2a$11$8WFKTW63s6/3enIwrcLAUOdKKjhPP0HuCvq0Ejj4Zkkw0B9VDoBVW', NULL, 'user', NULL, '2025-06-19 04:01:38', '2025-06-19 04:01:38'),
(16, 'Ngô Minh Đạt', 'intarekima@gmail.com', '0900012312', '$2a$11$Gbn0wDwCM6MmO3hOBtG8F.kZO.UHXzdEC704JoNxy3fJpUB3RYHu6', NULL, 'user', NULL, '2025-07-12 13:51:35', '2025-07-12 13:51:35'),
(17, 'Test', 'test@gmail.com', '0123456789', '$2a$11$VDicnGGMhMqcIFb7ZM10W.abt0TOu1ebO8us6cnlMLNrN.e.BOZri', NULL, 'user', NULL, '2025-07-13 08:50:15', '2025-07-13 08:50:15'),
(18, 'dattt', 'nomodo234@gmail.com', NULL, '$2a$11$WZRHrptB0li9wAADj9IGxetB1Efzb3ueBdreDpoayEqnTswwbidLa', NULL, 'user', NULL, '2025-07-15 11:43:41', '2025-07-15 11:43:41');

-- --------------------------------------------------------

--
-- Table structure for table `__efmigrationshistory`
--

CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `__efmigrationshistory`
--

INSERT INTO `__efmigrationshistory` (`MigrationId`, `ProductVersion`) VALUES
('20250609125422_InitialSetup', '8.0.13');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_Categories_ParentId` (`ParentId`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `documentauthors`
--
ALTER TABLE `documentauthors`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_DocumentAuthors_AuthorId` (`AuthorId`),
  ADD KEY `IX_DocumentAuthors_DocumentId` (`DocumentId`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_Documents_CategoryId` (`CategoryId`),
  ADD KEY `IX_Documents_PublisherId` (`PublisherId`);
ALTER TABLE `documents` ADD FULLTEXT KEY `ft_title` (`Title`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_Payments_DocumentId` (`DocumentId`),
  ADD KEY `IX_Payments_UserId` (`UserId`);

--
-- Indexes for table `publishers`
--
ALTER TABLE `publishers`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `qrcodes`
--
ALTER TABLE `qrcodes`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_QRCodes_DocumentId` (`DocumentId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `__efmigrationshistory`
--
ALTER TABLE `__efmigrationshistory`
  ADD PRIMARY KEY (`MigrationId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `documentauthors`
--
ALTER TABLE `documentauthors`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=848;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `publishers`
--
ALTER TABLE `publishers`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `qrcodes`
--
ALTER TABLE `qrcodes`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=427;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `FK_Categories_Categories_ParentId` FOREIGN KEY (`ParentId`) REFERENCES `categories` (`Id`) ON DELETE SET NULL;

--
-- Constraints for table `documentauthors`
--
ALTER TABLE `documentauthors`
  ADD CONSTRAINT `FK_DocumentAuthors_Authors_AuthorId` FOREIGN KEY (`AuthorId`) REFERENCES `authors` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_DocumentAuthors_Documents_DocumentId` FOREIGN KEY (`DocumentId`) REFERENCES `documents` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `FK_Documents_Categories_CategoryId` FOREIGN KEY (`CategoryId`) REFERENCES `categories` (`Id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_Documents_Publishers_PublisherId` FOREIGN KEY (`PublisherId`) REFERENCES `publishers` (`Id`) ON DELETE SET NULL;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `FK_Payments_Documents_DocumentId` FOREIGN KEY (`DocumentId`) REFERENCES `documents` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Payments_Users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `qrcodes`
--
ALTER TABLE `qrcodes`
  ADD CONSTRAINT `FK_QRCodes_Documents_DocumentId` FOREIGN KEY (`DocumentId`) REFERENCES `documents` (`Id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
