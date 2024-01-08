import 'dart:math';

import 'package:net_monstrum_card_game/domain/color.dart';
import 'package:net_monstrum_card_game/domain/evolution.dart';

import '../domain/card.dart';

class CardsService {
  List<Card> cardsData = [
    Card(1, 'Agumon', CardColor.RED, 10, 10, Evolution('Greymon', CardColor.RED), 1),
    Card(2, 'Greymon', CardColor.RED, 10, 10, Evolution('MetalGreymon (Vaccine)', CardColor.RED), 2),
    Card(3, 'MetalGreymon (Vaccine)', CardColor.RED, 10, 10, Evolution('WarGreymon', CardColor.RED), 3),
    Card(4, 'WarGreymon', CardColor.RED, 10, 10, null, 4),

    Card(5, 'Gabumon', CardColor.BLUE, 10, 10, Evolution('Garurumon', CardColor.BLUE), 1),
    Card(6, 'Garurumon', CardColor.BLUE, 10, 10, Evolution('WereGarurumon', CardColor.BLUE), 2),
    Card(7, 'WereGarurumon', CardColor.BLUE, 10, 10, Evolution('MetalGarurumon', CardColor.BLUE), 3),
    Card(8, 'MetalGarurumon', CardColor.BLUE, 10, 10, null, 4),

    Card(9, 'Veemon', CardColor.RED, 10, 10, Evolution('ExVeemon', CardColor.RED), 1),
    Card(10, 'ExVeemon', CardColor.RED, 10, 10, Evolution('Paildramon', CardColor.RED), 2),
    Card(11, 'Paildramon', CardColor.RED, 10, 10, Evolution('Imperialdramon Fighter Mode', CardColor.RED), 3),
    Card(12, 'Imperialdramon Fighter Mode', CardColor.RED, 10, 10, null, 4),

    Card(13, 'Patamon', CardColor.WHITE, 10, 10, Evolution('Angemon', CardColor.WHITE), 1),
    Card(14, 'Angemon', CardColor.WHITE, 10, 10, Evolution('MagnaAngemon', CardColor.WHITE), 2),
    Card(15, 'MagnaAngemon', CardColor.WHITE, 10, 10, Evolution('Seraphimon', CardColor.WHITE), 3),
    Card(16, 'Seraphimon', CardColor.WHITE, 10, 10, null, 4),

    Card(17, 'Gatomon', CardColor.WHITE, 10, 10, Evolution('Greymon', CardColor.RED), 1),
    Card(18, 'Angewomon', CardColor.WHITE, 10, 10, Evolution('Greymon', CardColor.RED), 2),
    Card(19, 'Magnadramon', CardColor.WHITE, 10, 10, Evolution('Greymon', CardColor.RED), 3),
    Card(20, 'Ophanimon', CardColor.WHITE, 10, 10, null, 4),

    Card(21, 'Biyomon', CardColor.RED, 10, 10, Evolution('Birdramon', CardColor.RED), 1),
    Card(22, 'Birdramon', CardColor.RED, 10, 10, Evolution('Garudamon', CardColor.RED), 2),
    Card(23, 'Garudamon', CardColor.RED, 10, 10, Evolution('Phoenixmon', CardColor.RED), 3),
    Card(24, 'Phoenixmon', CardColor.RED, 10, 10, null, 4),

    Card(25, 'Tentomon', CardColor.GREEN, 10, 10, Evolution('Kabuterimon', CardColor.GREEN), 1),
    Card(26, 'Kabuterimon', CardColor.GREEN, 10, 10, Evolution('MegaKabuterimon', CardColor.GREEN), 2),
    Card(27, 'MegaKabuterimon', CardColor.GREEN, 10, 10, Evolution('HerculesKabuterimon', CardColor.GREEN), 3),
    Card(28, 'HerculesKabuterimon', CardColor.GREEN, 10, 10, null, 4),

    Card(29, 'Palmon', CardColor.GREEN, 10, 10, Evolution('Togemon', CardColor.RED), 1),
    Card(30, 'Togemon', CardColor.GREEN, 10, 10, Evolution('Lillymon', CardColor.RED), 2),
    Card(31, 'Lillymon', CardColor.GREEN, 10, 10, Evolution('Rosemon', CardColor.RED), 3),
    Card(32, 'Rosemon', CardColor.GREEN, 10, 10, null, 4),

    Card(33, 'Gomamon', CardColor.BLUE, 10, 10, Evolution('Ikkakumon', CardColor.RED), 1),
    Card(34, 'Ikkakumon', CardColor.BLUE, 10, 10, Evolution('Zudomon', CardColor.RED), 2),
    Card(35, 'Zudomon', CardColor.BLUE, 10, 10, Evolution('Vikemon', CardColor.RED), 3),
    Card(36, 'Vikemon', CardColor.BLUE, 10, 10, null, 4),

    Card(37, 'Elecmon', CardColor.RED, 10, 10, Evolution('Leomon', CardColor.RED), 1),
    Card(38, 'Leomon', CardColor.RED, 10, 10, Evolution('IceLeomon', CardColor.RED), 2),
    Card(39, 'IceLeomon', CardColor.RED, 10, 10, Evolution('Saberdramon', CardColor.RED), 3),
    Card(40, 'Saberdramon', CardColor.RED, 10, 10, null, 4),

    Card(41, 'Renamon', CardColor.WHITE, 10, 10, Evolution('Kyubimon', CardColor.WHITE), 1),
    Card(42, 'Kyubimon', CardColor.WHITE, 10, 10, Evolution('Taomon', CardColor.WHITE), 2),
    Card(43, 'Taomon', CardColor.WHITE, 10, 10, Evolution('Sakuyamon', CardColor.WHITE), 3),
    Card(44, 'Sakuyamon', CardColor.WHITE, 10, 10, null, 4),

    Card(45, 'Terriermon', CardColor.GREEN, 10, 10, Evolution('Gargomon', CardColor.GREEN), 1),
    Card(46, 'Gargomon', CardColor.GREEN, 10, 10, Evolution('Rapidmon', CardColor.GREEN), 2),
    Card(47, 'Rapidmon', CardColor.GREEN, 10, 10, Evolution('MegaGargomon', CardColor.GREEN), 3),
    Card(48, 'MegaGargomon', CardColor.GREEN, 10, 10, null, 4),

    Card(49, 'Guilmon', CardColor.RED, 10, 10, Evolution('Growlmon', CardColor.RED), 1),
    Card(50, 'Growlmon', CardColor.RED, 10, 10, Evolution('WarGrowlmon', CardColor.RED), 2),
    Card(51, 'WarGrowlmon', CardColor.RED, 10, 10, Evolution('Gallantmon', CardColor.RED), 3),
    Card(52, 'Gallantmon', CardColor.RED, 10, 10, null, 4),

    Card(53, 'Impmon', CardColor.BLACK, 10, 10, Evolution('Wizardmon', CardColor.BLACK), 1),
    Card(54, 'Wizardmon', CardColor.BLACK, 10, 10, Evolution('Mistymon', CardColor.BLACK), 2),
    Card(55, 'Mistymon', CardColor.BLACK, 10, 10, Evolution('Dynasmon', CardColor.BLACK), 3),
    Card(56, 'Dynasmon', CardColor.BLACK, 10, 10, null, 4),

    Card(65, 'Kumamon', CardColor.GREEN, 10, 10, Evolution('Grizzlymon', CardColor.GREEN), 1),
    Card(66, 'Grizzlymon', CardColor.GREEN, 10, 10, Evolution('Gigasmon', CardColor.GREEN), 2),
    Card(67, 'Gigasmon', CardColor.GREEN, 10, 10, Evolution('Hisyaryumon', CardColor.GREEN), 3),
    Card(68, 'Hisyaryumon', CardColor.GREEN, 10, 10, null, 4),

    Card(69, 'Agunimon', CardColor.RED, 10, 10, Evolution('BurningGreymon', CardColor.RED), 1),
    Card(70, 'BurningGreymon', CardColor.RED, 10, 10, Evolution('Aldamon', CardColor.RED), 2),
    Card(71, 'Aldamon', CardColor.RED, 10, 10, Evolution('EmperorGreymon', CardColor.RED), 3),
    Card(72, 'EmperorGreymon', CardColor.RED, 10, 10, null, 4),

    Card(73, 'Lobomon', CardColor.BLUE, 10, 10, Evolution('KendoGarurumon', CardColor.BLUE), 1),
    Card(74, 'KendoGarurumon', CardColor.BLUE, 10, 10, Evolution('BeoWolfmon', CardColor.BLUE), 2),
    Card(75, 'BeoWolfmon', CardColor.BLUE, 10, 10, Evolution('Magnagarurumon', CardColor.BLUE), 3),
    Card(76, 'Magnagarurumon', CardColor.BLUE, 10, 10, null, 4),
  ];

  CardsService() {

  }

  Card getCardById(int cardId) {
    return cardsData.firstWhere((card) => card.id == cardId);
  }

}

