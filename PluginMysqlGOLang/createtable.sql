-------------------------------------
--ALAN SANTOS
--EXAMPLE CREATE TABLE
-------------------------------------
USE SYS;

CREATE TABLE `images` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` varchar(200) DEFAULT NULL,
  `imagedescription` varchar(50) DEFAULT NULL,
  `image` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
------------------------------------