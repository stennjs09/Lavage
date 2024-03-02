-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : sam. 02 mars 2024 à 19:44
-- Version du serveur : 8.2.0
-- Version de PHP : 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `myapp`
--

-- --------------------------------------------------------

--
-- Structure de la table `galana`
--

DROP TABLE IF EXISTS `galana`;
CREATE TABLE IF NOT EXISTS `galana` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_esp` varchar(50) NOT NULL,
  `temps` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `galana`
--

INSERT INTO `galana` (`id`, `nom_esp`, `temps`) VALUES
(1, 'lavage', '13'),
(2, 'lavage_moteur', '0'),
(3, 'pneumatique_vl', '0'),
(4, 'pneumatique_pl', '0');

-- --------------------------------------------------------

--
-- Structure de la table `total`
--

DROP TABLE IF EXISTS `total`;
CREATE TABLE IF NOT EXISTS `total` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_esp` varchar(50) NOT NULL,
  `temps` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `total`
--

INSERT INTO `total` (`id`, `nom_esp`, `temps`) VALUES
(1, 'lavage', '0'),
(2, 'pneumatique', '0');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
