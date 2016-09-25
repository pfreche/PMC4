-- MySQL dump 10.13  Distrib 5.7.15, for Linux (x86_64)
--
-- Host: localhost    Database: media_development
-- ------------------------------------------------------
-- Server version	5.7.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agroups`
--

DROP TABLE IF EXISTS `agroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agroups`
--

LOCK TABLES `agroups` WRITE;
/*!40000 ALTER TABLE `agroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `agroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agroups_mfiles`
--

DROP TABLE IF EXISTS `agroups_mfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agroups_mfiles` (
  `mfile_id` int(11) DEFAULT NULL,
  `agroup_id` int(11) DEFAULT NULL,
  KEY `index_agroups_mfiles_on_agroup_id` (`agroup_id`) USING BTREE,
  KEY `index_agroups_mfiles_on_mfile_id` (`mfile_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agroups_mfiles`
--

LOCK TABLES `agroups_mfiles` WRITE;
/*!40000 ALTER TABLE `agroups_mfiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `agroups_mfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `artist_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  `year` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `artist_id` (`artist_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2016-09-21 19:56:33','2016-09-21 19:56:33');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists`
--

DROP TABLE IF EXISTS `artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  `browse_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists`
--

LOCK TABLES `artists` WRITE;
/*!40000 ALTER TABLE `artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attris`
--

DROP TABLE IF EXISTS `attris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attris` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `agroup_id` int(11) DEFAULT NULL,
  `id_sort` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `keycode` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attris_on_agroup_id` (`agroup_id`) USING BTREE,
  KEY `index_attris_on_keycode` (`keycode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attris`
--

LOCK TABLES `attris` WRITE;
/*!40000 ALTER TABLE `attris` DISABLE KEYS */;
/*!40000 ALTER TABLE `attris` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attris_mfiles`
--

DROP TABLE IF EXISTS `attris_mfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attris_mfiles` (
  `mfile_id` int(11) DEFAULT NULL,
  `attri_id` int(11) DEFAULT NULL,
  KEY `index_attris_mfiles_on_attri_id` (`attri_id`) USING BTREE,
  KEY `index_attris_mfiles_on_mfile_id` (`mfile_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attris_mfiles`
--

LOCK TABLES `attris_mfiles` WRITE;
/*!40000 ALTER TABLE `attris_mfiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `attris_mfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES (1,'','http://cs.nyu.edu/~pbethe/bridgeReview200908.pdf','','2016-09-21 19:59:20','2016-09-21 19:59:20'),(2,'','http://de.learnlayout.com/inline-block.html','','2016-09-24 22:26:19','2016-09-24 22:26:19');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folders`
--

DROP TABLE IF EXISTS `folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storage_id` int(11) DEFAULT NULL,
  `mpath` varchar(255) DEFAULT NULL,
  `lfolder` varchar(255) DEFAULT NULL,
  `mfile_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_folders_on_storage_id` (`storage_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folders`
--

LOCK TABLES `folders` WRITE;
/*!40000 ALTER TABLE `folders` DISABLE KEYS */;
INSERT INTO `folders` VALUES (1,2,'','',NULL),(2,2,'/','history',NULL),(3,2,'/intl/','de',NULL),(4,2,'/intl/de/','policies',NULL),(5,1,'/www.maturedoyen.com/watch/','monica_furry_001920',NULL),(6,1,'/www.maturedoyen.com/watch/monica_furry_001920/','thumbs',NULL);
/*!40000 ALTER TABLE `folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indexer`
--

DROP TABLE IF EXISTS `indexer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indexer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indexer`
--

LOCK TABLES `indexer` WRITE;
/*!40000 ALTER TABLE `indexer` DISABLE KEYS */;
/*!40000 ALTER TABLE `indexer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `typ` int(11) DEFAULT NULL,
  `storage_id` int(11) DEFAULT NULL,
  `inuse` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `prefix` varchar(255) DEFAULT NULL,
  `mfile_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'','http:/','',1,1,1,'2016-09-21 20:01:04','2016-09-21 20:45:22','',1),(2,'google container','http://www.google.de','',1,2,1,'2016-09-21 20:07:12','2016-09-21 20:11:22','',2),(3,'google','http://www.google.de','',0,NULL,0,'2016-09-21 20:08:42','2016-09-21 20:08:42','',3),(4,'monica','http://www.maturedoyen.com/watch/monica_furry_001920/index.php','',0,NULL,0,'2016-09-21 20:17:06','2016-09-21 20:19:12','',15),(5,'','','',3,1,1,'2016-09-21 20:21:57','2016-09-21 20:24:28','',42);
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pattern` varchar(255) DEFAULT NULL,
  `extract` varchar(255) DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `filter` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `result` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (1,'www','','','','2016-09-22 19:42:22','2016-09-22 19:42:22','');
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_types`
--

DROP TABLE IF EXISTS `media_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_types`
--

LOCK TABLES `media_types` WRITE;
/*!40000 ALTER TABLE `media_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mfiles`
--

DROP TABLE IF EXISTS `mfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mfiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `mod_date` date DEFAULT NULL,
  `mtype` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_mfiles_on_folder_id` (`folder_id`) USING BTREE,
  KEY `index_mfiles_on_modified` (`modified`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mfiles`
--

LOCK TABLES `mfiles` WRITE;
/*!40000 ALTER TABLE `mfiles` DISABLE KEYS */;
INSERT INTO `mfiles` VALUES (1,NULL,'','2016-09-21 20:01:04','2016-09-21',1),(2,NULL,'','2016-09-21 20:07:12','2016-09-21',1),(3,NULL,'','2016-09-21 20:08:42','2016-09-21',1),(4,1,'imghp?hl=de&tab=wi',NULL,NULL,5),(5,2,'optout?hl=de',NULL,NULL,5),(6,1,'preferences?hl=de',NULL,NULL,5),(7,1,'advanced_search?hl=de&authuser=0',NULL,NULL,5),(8,1,'language_tools?hl=de&authuser=0',NULL,NULL,5),(9,3,'ads',NULL,NULL,5),(10,1,'services',NULL,NULL,5),(11,3,'about.html',NULL,NULL,5),(12,1,'setprefdomain?prefdom=US&sig=__qPs20ie8mnjK13zADSPY_SsWa4A=',NULL,NULL,5),(13,4,'privacy',NULL,NULL,5),(14,4,'terms',NULL,NULL,5),(15,NULL,'','2016-09-21 20:17:06','2016-09-21',1),(16,5,'monica_furry_001920-1.jpg',NULL,NULL,5),(17,5,'monica_furry_001920-2.jpg',NULL,NULL,5),(18,5,'monica_furry_001920-3.jpg',NULL,NULL,5),(19,5,'monica_furry_001920-4.jpg',NULL,NULL,5),(20,5,'monica_furry_001920-5.jpg',NULL,NULL,5),(21,5,'monica_furry_001920-6.jpg',NULL,NULL,5),(22,5,'monica_furry_001920-7.jpg',NULL,NULL,5),(23,5,'monica_furry_001920-8.jpg',NULL,NULL,5),(24,5,'monica_furry_001920-9.jpg',NULL,NULL,5),(25,5,'monica_furry_001920-10.jpg',NULL,NULL,5),(26,5,'monica_furry_001920-11.jpg',NULL,NULL,5),(27,5,'monica_furry_001920-12.jpg',NULL,NULL,5),(28,5,'monica_furry_001920-13.jpg',NULL,NULL,5),(29,6,'monica_furry_001920-1.jpg',NULL,NULL,5),(30,6,'monica_furry_001920-2.jpg',NULL,NULL,5),(31,6,'monica_furry_001920-3.jpg',NULL,NULL,5),(32,6,'monica_furry_001920-4.jpg',NULL,NULL,5),(33,6,'monica_furry_001920-5.jpg',NULL,NULL,5),(34,6,'monica_furry_001920-6.jpg',NULL,NULL,5),(35,6,'monica_furry_001920-7.jpg',NULL,NULL,5),(36,6,'monica_furry_001920-8.jpg',NULL,NULL,5),(37,6,'monica_furry_001920-9.jpg',NULL,NULL,5),(38,6,'monica_furry_001920-10.jpg',NULL,NULL,5),(39,6,'monica_furry_001920-11.jpg',NULL,NULL,5),(40,6,'monica_furry_001920-12.jpg',NULL,NULL,5),(41,6,'monica_furry_001920-13.jpg',NULL,NULL,5),(42,NULL,'','2016-09-21 20:21:57','2016-09-21',1);
/*!40000 ALTER TABLE `mfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mtypes`
--

DROP TABLE IF EXISTS `mtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `has_file` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mtypes`
--

LOCK TABLES `mtypes` WRITE;
/*!40000 ALTER TABLE `mtypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `mtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packlocations`
--

DROP TABLE IF EXISTS `packlocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packlocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `filepath` varchar(255) DEFAULT NULL,
  `webpath` varchar(255) DEFAULT NULL,
  `tnfilepath` varchar(255) DEFAULT NULL,
  `tnwebpath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packlocations`
--

LOCK TABLES `packlocations` WRITE;
/*!40000 ALTER TABLE `packlocations` DISABLE KEYS */;
/*!40000 ALTER TABLE `packlocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packs`
--

DROP TABLE IF EXISTS `packs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `packlocation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packs`
--

LOCK TABLES `packs` WRITE;
/*!40000 ALTER TABLE `packs` DISABLE KEYS */;
/*!40000 ALTER TABLE `packs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `play_log`
--

DROP TABLE IF EXISTS `play_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `play_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `track_id` int(11) DEFAULT NULL,
  `date_played` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `scrobbled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ix_play_log_track_id` (`track_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `play_log`
--

LOCK TABLES `play_log` WRITE;
/*!40000 ALTER TABLE `play_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `play_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_tracks`
--

DROP TABLE IF EXISTS `playlist_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playlist_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist_id` int(11) DEFAULT NULL,
  `track_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_tracks`
--

LOCK TABLES `playlist_tracks` WRITE;
/*!40000 ALTER TABLE `playlist_tracks` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlist_tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `properties`
--

LOCK TABLES `properties` WRITE;
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `props`
--

DROP TABLE IF EXISTS `props`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `props` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mfile_id` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `pixels` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `md5` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_props_on_md5` (`md5`) USING BTREE,
  KEY `index_props_on_mfile_id` (`mfile_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `props`
--

LOCK TABLES `props` WRITE;
/*!40000 ALTER TABLE `props` DISABLE KEYS */;
/*!40000 ALTER TABLE `props` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_log`
--

DROP TABLE IF EXISTS `request_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `request_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(16) NOT NULL,
  `date_of_request` datetime NOT NULL,
  `request_url` varchar(255) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `referer` varchar(255) NOT NULL,
  `cookies` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_log`
--

LOCK TABLES `request_log` WRITE;
/*!40000 ALTER TABLE `request_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `request_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scanners`
--

DROP TABLE IF EXISTS `scanners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scanners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) DEFAULT NULL,
  `pattern` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanners`
--

LOCK TABLES `scanners` WRITE;
/*!40000 ALTER TABLE `scanners` DISABLE KEYS */;
INSERT INTO `scanners` VALUES (1,'231','123','2016-09-23 16:11:11','2016-09-23 16:11:11'),(2,'','','2016-09-23 16:44:45','2016-09-23 16:44:45'),(3,'','(.+galler.+)','2016-09-24 21:30:14','2016-09-24 21:30:14');
/*!40000 ALTER TABLE `scanners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20130825083917'),('20141228184717'),('20141229182701'),('20141229220854'),('20141230125118'),('20141230130633'),('20160102135035'),('20160111213543'),('20160701132533'),('20160923153539');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selections`
--

DROP TABLE IF EXISTS `selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `selections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `what` varchar(1) DEFAULT NULL,
  `seize` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `par` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selections`
--

LOCK TABLES `selections` WRITE;
/*!40000 ALTER TABLE `selections` DISABLE KEYS */;
/*!40000 ALTER TABLE `selections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selitems`
--

DROP TABLE IF EXISTS `selitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `selitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objid` int(11) DEFAULT NULL,
  `next_id` int(11) DEFAULT NULL,
  `prev_id` int(11) DEFAULT NULL,
  `selection_id` int(11) DEFAULT NULL,
  `what` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_selitems_on_selection_id` (`selection_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selitems`
--

LOCK TABLES `selitems` WRITE;
/*!40000 ALTER TABLE `selitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `selitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storages`
--

DROP TABLE IF EXISTS `storages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `no` int(11) DEFAULT '1',
  `filepath` varchar(100) DEFAULT NULL,
  `webpath` varchar(50) DEFAULT NULL,
  `filepath_tn` varchar(100) DEFAULT NULL,
  `webpath_tn` varchar(50) DEFAULT NULL,
  `mtype` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storages`
--

LOCK TABLES `storages` WRITE;
/*!40000 ALTER TABLE `storages` DISABLE KEYS */;
INSERT INTO `storages` VALUES (1,'http:/',1,NULL,NULL,NULL,NULL,NULL),(2,'generic http',1,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `storages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracks`
--

DROP TABLE IF EXISTS `tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `artist_id` int(11) NOT NULL,
  `album_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(500) NOT NULL,
  `length` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  `collection_id` int(11) NOT NULL,
  `track_no` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `artist_id` (`artist_id`,`album_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracks`
--

LOCK TABLES `tracks` WRITE;
/*!40000 ALTER TABLE `tracks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `pass` varchar(32) NOT NULL,
  `email` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` varchar(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
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

-- Dump completed on 2016-09-25  7:36:20
