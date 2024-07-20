import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/card_programming.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/card/rule.dart';
import 'package:net_monstrum_card_game/domain/data/evolution.dart';

import '../domain/card/card_digimon.dart';

class CardsService {
  List<Card> cardsData = [
    CardDigimon(1, 'Agumon', CardColor.RED, 10, 10,
        Evolution('Greymon', CardColor.RED), 1),
    CardDigimon(2, 'Greymon', CardColor.RED, 10, 10,
        Evolution('MetalGreymon (Vaccine)', CardColor.RED), 2),
    CardDigimon(3, 'MetalGreymon (Vaccine)', CardColor.RED, 10, 10,
        Evolution('WarGreymon', CardColor.RED), 3),
    CardDigimon(4, 'WarGreymon', CardColor.RED, 10, 10, null, 4),

    CardDigimon(5, 'Gabumon', CardColor.BLUE, 10, 10,
        Evolution('Garurumon', CardColor.BLUE), 1),
    CardDigimon(6, 'Garurumon', CardColor.BLUE, 10, 10,
        Evolution('WereGarurumon', CardColor.BLUE), 2),
    CardDigimon(7, 'WereGarurumon', CardColor.BLUE, 10, 10,
        Evolution('MetalGarurumon', CardColor.BLUE), 3),
    CardDigimon(8, 'MetalGarurumon', CardColor.BLUE, 10, 10, null, 4),

    CardDigimon(9, 'Veemon', CardColor.RED, 10, 10,
        Evolution('ExVeemon', CardColor.RED), 1),
    CardDigimon(10, 'ExVeemon', CardColor.RED, 10, 10,
        Evolution('Paildramon', CardColor.RED), 2),
    CardDigimon(11, 'Paildramon', CardColor.RED, 10, 10,
        Evolution('Imperialdramon Fighter Mode', CardColor.RED), 3),
    CardDigimon(
        12, 'Imperialdramon Fighter Mode', CardColor.RED, 10, 10, null, 4),

    CardDigimon(13, 'Patamon', CardColor.WHITE, 10, 10,
        Evolution('Angemon', CardColor.WHITE), 1),
    CardDigimon(14, 'Angemon', CardColor.WHITE, 10, 10,
        Evolution('MagnaAngemon', CardColor.WHITE), 2),
    CardDigimon(15, 'MagnaAngemon', CardColor.WHITE, 10, 10,
        Evolution('Seraphimon', CardColor.WHITE), 3),
    CardDigimon(16, 'Seraphimon', CardColor.WHITE, 10, 10, null, 4),

    CardDigimon(17, 'Salamon', CardColor.WHITE, 10, 10,
        Evolution('Gatomon', CardColor.WHITE), 1),
    CardDigimon(18, 'Gatomon', CardColor.WHITE, 10, 10,
        Evolution('Angewomon', CardColor.WHITE), 2),
    CardDigimon(19, 'Angewomon', CardColor.WHITE, 10, 10,
        Evolution('Ophanimon', CardColor.WHITE), 3),
    CardDigimon(20, 'Ophanimon', CardColor.WHITE, 10, 10, null, 4),

    CardDigimon(21, 'Biyomon', CardColor.RED, 10, 10,
        Evolution('Birdramon', CardColor.RED), 1),
    CardDigimon(22, 'Birdramon', CardColor.RED, 10, 10,
        Evolution('Garudamon', CardColor.RED), 2),
    CardDigimon(23, 'Garudamon', CardColor.RED, 10, 10,
        Evolution('Phoenixmon', CardColor.RED), 3),
    CardDigimon(24, 'Phoenixmon', CardColor.RED, 10, 10, null, 4),

    CardDigimon(25, 'Tentomon', CardColor.GREEN, 10, 10,
        Evolution('Kabuterimon', CardColor.GREEN), 1),
    CardDigimon(26, 'Kabuterimon', CardColor.GREEN, 10, 10,
        Evolution('MegaKabuterimon', CardColor.GREEN), 2),
    CardDigimon(27, 'MegaKabuterimon', CardColor.GREEN, 10, 10,
        Evolution('HerculesKabuterimon', CardColor.GREEN), 3),
    CardDigimon(28, 'HerculesKabuterimon', CardColor.GREEN, 10, 10, null, 4),

    CardDigimon(29, 'Palmon', CardColor.GREEN, 10, 10,
        Evolution('Togemon', CardColor.RED), 1),
    CardDigimon(30, 'Togemon', CardColor.GREEN, 10, 10,
        Evolution('Lillymon', CardColor.RED), 2),
    CardDigimon(31, 'Lillymon', CardColor.GREEN, 10, 10,
        Evolution('Rosemon', CardColor.RED), 3),
    CardDigimon(32, 'Rosemon', CardColor.GREEN, 10, 10, null, 4),

    CardDigimon(33, 'Gomamon', CardColor.BLUE, 10, 10,
        Evolution('Ikkakumon', CardColor.RED), 1),
    CardDigimon(34, 'Ikkakumon', CardColor.BLUE, 10, 10,
        Evolution('Zudomon', CardColor.RED), 2),
    CardDigimon(35, 'Zudomon', CardColor.BLUE, 10, 10,
        Evolution('Vikemon', CardColor.RED), 3),
    CardDigimon(36, 'Vikemon', CardColor.BLUE, 10, 10, null, 4),

    CardDigimon(37, 'Elecmon', CardColor.RED, 10, 10,
        Evolution('Leomon', CardColor.RED), 1),
    CardDigimon(38, 'Leomon', CardColor.RED, 10, 10,
        Evolution('IceLeomon', CardColor.RED), 2),
    CardDigimon(39, 'IceLeomon', CardColor.RED, 10, 10,
        Evolution('Saberdramon', CardColor.RED), 3),
    CardDigimon(40, 'Saberdramon', CardColor.RED, 10, 10, null, 4),

    CardDigimon(41, 'Renamon', CardColor.WHITE, 10, 10,
        Evolution('Kyubimon', CardColor.WHITE), 1),
    CardDigimon(42, 'Kyubimon', CardColor.WHITE, 10, 10,
        Evolution('Taomon', CardColor.WHITE), 2),
    CardDigimon(43, 'Taomon', CardColor.WHITE, 10, 10,
        Evolution('Sakuyamon', CardColor.WHITE), 3),
    CardDigimon(44, 'Sakuyamon', CardColor.WHITE, 10, 10, null, 4),

    CardDigimon(45, 'Terriermon', CardColor.GREEN, 10, 10,
        Evolution('Gargomon', CardColor.GREEN), 1),
    CardDigimon(46, 'Gargomon', CardColor.GREEN, 10, 10,
        Evolution('Rapidmon', CardColor.GREEN), 2),
    CardDigimon(47, 'Rapidmon', CardColor.GREEN, 10, 10,
        Evolution('MegaGargomon', CardColor.GREEN), 3),
    CardDigimon(48, 'MegaGargomon', CardColor.GREEN, 10, 10, null, 4),

    CardDigimon(49, 'Guilmon', CardColor.RED, 10, 10,
        Evolution('Growlmon', CardColor.RED), 1),
    CardDigimon(50, 'Growlmon', CardColor.RED, 10, 10,
        Evolution('WarGrowlmon', CardColor.RED), 2),
    CardDigimon(51, 'WarGrowlmon', CardColor.RED, 10, 10,
        Evolution('Gallantmon', CardColor.RED), 3),
    CardDigimon(52, 'Gallantmon', CardColor.RED, 10, 10, null, 4),

    CardDigimon(53, 'Impmon', CardColor.BLACK, 10, 10,
        Evolution('Wizardmon', CardColor.BLACK), 1),
    CardDigimon(54, 'Wizardmon', CardColor.BLACK, 10, 10,
        Evolution('Mistymon', CardColor.BLACK), 2),
    CardDigimon(55, 'Mistymon', CardColor.BLACK, 10, 10,
        Evolution('Dynasmon', CardColor.BLACK), 3),
    CardDigimon(56, 'Dynasmon', CardColor.BLACK, 10, 10, null, 4),

    CardDigimon(65, 'Kumamon', CardColor.GREEN, 10, 10,
        Evolution('Grizzlymon', CardColor.GREEN), 1),
    CardDigimon(66, 'Grizzlymon', CardColor.GREEN, 10, 10,
        Evolution('Gigasmon', CardColor.GREEN), 2),
    CardDigimon(67, 'Gigasmon', CardColor.GREEN, 10, 10,
        Evolution('Hisyaryumon', CardColor.GREEN), 3),
    CardDigimon(68, 'Hisyaryumon', CardColor.GREEN, 10, 10, null, 4),

    CardDigimon(69, 'Agunimon', CardColor.RED, 10, 10,
        Evolution('BurningGreymon', CardColor.RED), 1),
    CardDigimon(70, 'BurningGreymon', CardColor.RED, 10, 10,
        Evolution('Aldamon', CardColor.RED), 2),
    CardDigimon(71, 'Aldamon', CardColor.RED, 10, 10,
        Evolution('EmperorGreymon', CardColor.RED), 3),
    CardDigimon(72, 'EmperorGreymon', CardColor.RED, 10, 10, null, 4),

    CardDigimon(73, 'Lobomon', CardColor.BLUE, 10, 10,
        Evolution('KendoGarurumon', CardColor.BLUE), 1),
    CardDigimon(74, 'KendoGarurumon', CardColor.BLUE, 10, 10,
        Evolution('BeoWolfmon', CardColor.BLUE), 2),
    CardDigimon(75, 'BeoWolfmon', CardColor.BLUE, 10, 10,
        Evolution('Magnagarurumon', CardColor.BLUE), 3),
    CardDigimon(76, 'Magnagarurumon', CardColor.BLUE, 10, 10, null, 4),

    CardEquipment(77, "Armor +10", 0, 10, "UNIQUE", 1),
    CardEquipment(78, "Sword +10", 10, 0, "UNIQUE", 1),
    CardEquipment(79, "Armor 2x +10", 0, 10, "PARTIAL", 2),
    CardEquipment(80, "Armor 3x +10", 0, 10, "PARTIAL", 3),
    CardEquipment(81, "Armor 4x +10", 0, 10, "PARTIAL", 4),
    CardEquipment(82, "Sword 2x +10", 10, 0, "PARTIAL", 2),
    CardEquipment(83, "Sword 3x +10", 10, 0, "PARTIAL", 3),
    CardEquipment(84, "Sword 4x +10", 10, 0, "PARTIAL", 4),
    CardEquipment(85, "Aura", 10, 10, "ALL", null),

    CardEnergy(86, "Red Energy +1", CardColor.RED, 1),
    CardEnergy(87, "Green Energy +1", CardColor.GREEN, 1),
    CardEnergy(88, "Black Energy +1", CardColor.BLACK, 1),
    CardEnergy(89, "Blue Energy +1", CardColor.BLUE, 1),
    CardEnergy(90, "White Energy +1", CardColor.WHITE, 1),
    CardEnergy(91, "Brown Energy +1", CardColor.BROWN, 1),

    CardEnergy(92, "Red Energy -1", CardColor.RED, -1),
    CardEnergy(93, "Green Energy -1", CardColor.GREEN, -1),
    CardEnergy(94, "Black Energy -1", CardColor.BLACK, -1),
    CardEnergy(95, "Blue Energy -1", CardColor.BLUE, -1),
    CardEnergy(96, "White Energy -1", CardColor.WHITE, -1),
    CardEnergy(97, "Brown Energy -1", CardColor.BROWN, -1),

    CardSummonDigimon(98, "Summon Gatomon x2", [
      CardDigimon(99, 'Gatomon', CardColor.WHITE, 10, 10,
          Evolution('Angewomon', CardColor.WHITE), 2),
      CardDigimon(100, 'Gatomon', CardColor.WHITE, 10, 10,
          Evolution('Angewomon', CardColor.WHITE), 2),
    ]),
    CardSummonDigimon(101, "Summon Angemon x2", [
      CardDigimon(102, 'Angemon', CardColor.WHITE, 10, 10,
          Evolution('MagnaAngemon', CardColor.WHITE), 2),
      CardDigimon(103, 'Angemon', CardColor.WHITE, 10, 10,
          Evolution('MagnaAngemon', CardColor.WHITE), 2),
    ]),

    CardProgramming(104, "Sacred Spear", CardColor.WHITE, [
      Rule(
          ACTION.SEND_TO_TRASH,
          ZONE.ENEMY_FIELD,
          FORM_OF_ACTION.NOT_APPLY,
          [
            TARGET_COLOR.CARD_OF_COLOR_BLACK,
            TARGET_COLOR.CARD_OF_COLOR_BLUE,
            TARGET_COLOR.CARD_OF_COLOR_RED,
            TARGET_COLOR.CARD_OF_COLOR_GREEN,
          ],
          [TYPE_TARGET_CARD.DIGIMON],
          QUANTITY.ALL,
          null)
    ]),
    CardProgramming(105, "Tidal Wave", CardColor.BLUE, [
      Rule(
          ACTION.SEND_TO_TRASH,
          ZONE.ENEMY_FIELD,
          FORM_OF_ACTION.NOT_APPLY,
          [
            TARGET_COLOR.CARD_OF_COLOR_BLACK,
            TARGET_COLOR.CARD_OF_COLOR_WHITE,
            TARGET_COLOR.CARD_OF_COLOR_RED,
            TARGET_COLOR.CARD_OF_COLOR_GREEN,
          ],
          [TYPE_TARGET_CARD.DIGIMON],
          QUANTITY.ALL,
          null),
    ]),
    CardProgramming(106, "Control Parts", CardColor.BLUE, [
      Rule(ACTION.SEND_TO_FIELD, ZONE.ENEMY_FIELD, FORM_OF_ACTION.SELECTED, [],
          [TYPE_TARGET_CARD.DIGIMON], QUANTITY.ONE, null),
    ]),
    CardProgramming(107, "Freeze Bug", CardColor.BLUE, [
      Rule(
          ACTION.SEND_TO_TRASH,
          ZONE.ENEMY_SUMMON_PROGRAMMING_ZONE,
          FORM_OF_ACTION.NOT_APPLY,
          [],
          [
            TYPE_TARGET_CARD.PROGRAMMING,
            TYPE_TARGET_CARD.EQUIPMENT,
            TYPE_TARGET_CARD.ENERGY
          ],
          QUANTITY.ONE,
          null),
    ]),
    CardProgramming(108, "Eclipse Undo", CardColor.BLUE, [
      Rule(ACTION.SEND_TO_ENEMY_HAND, ZONE.ENEMY_FIELD, FORM_OF_ACTION.NOT_APPLY,
          [], [TYPE_TARGET_CARD.DIGIMON], QUANTITY.ONE, null),
    ]),
    CardProgramming(109, "Ecoly Cycle", CardColor.BLUE, [
      Rule(ACTION.SEND_TO_HAND, ZONE.TRASH, FORM_OF_ACTION.NOT_APPLY, [],
          [TYPE_TARGET_CARD.DIGIMON], QUANTITY.ONE, null),
    ]),
    //DEBERIA SER UNA CARTA DE EQUIPAMIENTO MEZCLADA CON PROGRAMACION
    CardProgramming(110, "Volcanic Gatlin", CardColor.RED, [
      Rule(
          ACTION.DEAL_DAMAGE_TO_ENEMY_FIELD,
          ZONE.ENEMY_FIELD,
          FORM_OF_ACTION.NOT_APPLY,
          [
            TARGET_COLOR.CARD_OF_COLOR_BLACK,
            TARGET_COLOR.CARD_OF_COLOR_WHITE,
            TARGET_COLOR.CARD_OF_COLOR_BLUE,
            TARGET_COLOR.CARD_OF_COLOR_GREEN,
          ],
          [TYPE_TARGET_CARD.DIGIMON],
          QUANTITY.ALL,
          60),
    ]),
    CardProgramming(111, "Flame Gatlin", CardColor.RED, [
      Rule(
          ACTION.DEAL_DAMAGE_TO_ENEMY_FIELD,
          ZONE.ENEMY_FIELD,
          FORM_OF_ACTION.NOT_APPLY,
          [
            TARGET_COLOR.CARD_OF_COLOR_BLACK,
            TARGET_COLOR.CARD_OF_COLOR_WHITE,
            TARGET_COLOR.CARD_OF_COLOR_BLUE,
            TARGET_COLOR.CARD_OF_COLOR_GREEN,
          ],
          [TYPE_TARGET_CARD.DIGIMON],
          QUANTITY.ALL,
          15),
    ]),
    CardProgramming(112, "Fire Cannon", CardColor.RED, [
      Rule(
          ACTION.DEAL_DAMAGE_TO_ENEMY_FIELD,
          ZONE.ENEMY_FIELD,
          FORM_OF_ACTION.NOT_APPLY,
          [],
          [TYPE_TARGET_CARD.DIGIMON],
          QUANTITY.ONE,
          30),
    ]),
    CardProgramming(113, "Darkness Gale", CardColor.BLACK, [
      Rule(
          ACTION.SEND_TO_ENEMY_TRASH,
          ZONE.ENEMY_FIELD,
          FORM_OF_ACTION.NOT_APPLY,
          [
            TARGET_COLOR.CARD_OF_COLOR_WHITE,
            TARGET_COLOR.CARD_OF_COLOR_BLUE,
            TARGET_COLOR.CARD_OF_COLOR_GREEN,
            TARGET_COLOR.CARD_OF_COLOR_RED,
          ],
          [TYPE_TARGET_CARD.DIGIMON],
          QUANTITY.ALL,
          null),
    ]),
    CardProgramming(114, "Deceive Clock", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
    ]),
    CardProgramming(115, "Chaos Virus", CardColor.BLACK, [
      Rule(
          ACTION.SEND_TO_ENEMY_TRASH,
          ZONE.ENEMY_SUMMON_PROGRAMMING_ZONE,
          FORM_OF_ACTION.NOT_APPLY,
          [
            TARGET_COLOR.CARD_OF_COLOR_WHITE,
            TARGET_COLOR.CARD_OF_COLOR_BLUE,
            TARGET_COLOR.CARD_OF_COLOR_GREEN,
            TARGET_COLOR.CARD_OF_COLOR_RED,
          ],
          [TYPE_TARGET_CARD.PROGRAMMING],
          QUANTITY.ONE,
          null),
    ]),
    CardProgramming(116, "Vicious Hacking", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_HAND, FORM_OF_ACTION.SELECTED,
          [], [], QUANTITY.ONE, null),
    ]),
    CardProgramming(117, "Delete Matrix", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_FIELD, FORM_OF_ACTION.NOT_APPLY,
          [], [TYPE_TARGET_CARD.DIGIMON], QUANTITY.ALL, null),
    ]),
    CardProgramming(118, "Misery Gate", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.NOT_APPLY,
          [], [], QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.NOT_APPLY,
          [], [], QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.NOT_APPLY,
          [], [], QUANTITY.ONE, null),
    ]),
    CardProgramming(119, "Desire Access", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_TRASH, ZONE.HAND, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ALL, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
    ]),
    CardProgramming(120, "Revival Charge", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_DECK, ZONE.TRASH, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ALL, null),
    ]),
    CardProgramming(121, "Chrono Balance", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_TRASH, ZONE.HAND, FORM_OF_ACTION.RANDOM, [], [],
          QUANTITY.ONE, 1),
      Rule(ACTION.SEND_TO_TRASH, ZONE.HAND, FORM_OF_ACTION.RANDOM, [], [],
          QUANTITY.ONE, 1),
      Rule(ACTION.SEND_TO_TRASH, ZONE.HAND, FORM_OF_ACTION.RANDOM, [], [],
          QUANTITY.ONE, 1),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_HAND, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, 1),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_HAND, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, 1),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_HAND, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, 1),
    ]),
    CardProgramming(122, "Security Hall", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.RANDOM,
          [], [], QUANTITY.ONE, null),
    ]),
    CardProgramming(123, "Revival Charge", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_DECK, ZONE.TRASH, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ALL, null),
    ]),

    CardProgramming(124, "Scramble Up", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_FIELD, ZONE.HAND, FORM_OF_ACTION.SELECTED, [], [],
          QUANTITY.ONE, null),
    ]),
    CardProgramming(125, "Charge Terminal", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_HAND, ZONE.HAND, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_HAND, ZONE.HAND, FORM_OF_ACTION.NOT_APPLY, [], [],
          QUANTITY.ONE, null),
    ]),
    CardProgramming(126, "Digimon Charge", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.SELECTED, [],
          [TYPE_TARGET_CARD.DIGIMON], QUANTITY.ONE, null),
    ]),
    CardProgramming(127, "Program Charge", CardColor.BLACK, [
      Rule(
          ACTION.SEND_TO_HAND,
          ZONE.DECK,
          FORM_OF_ACTION.SELECTED,
          [],
          [
            TYPE_TARGET_CARD.PROGRAMMING,
            TYPE_TARGET_CARD.EQUIPMENT,
            TYPE_TARGET_CARD.ENERGY,
            TYPE_TARGET_CARD.SUMMON
          ],
          QUANTITY.ONE,
          null),
    ]),

    CardProgramming(128, "Trade Charge", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_HAND, ZONE.DECK, FORM_OF_ACTION.RANDOM, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_TRASH, ZONE.HAND, FORM_OF_ACTION.SELECTED, [], [],
          QUANTITY.ONE, null),
    ]),
    CardProgramming(129, "Illegal Access", CardColor.BLACK, [
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.SELECTED, [], [],
          QUANTITY.ONE, null),
      Rule(ACTION.SEND_TO_ENEMY_TRASH, ZONE.ENEMY_DECK, FORM_OF_ACTION.SELECTED, [], [],
          QUANTITY.ONE, null),
    ]),
  ];

  CardsService();

  Card getCardById(int cardId) {
    Card card = cardsData.firstWhere((card) => card.id == cardId);
    if (card.isDigimonCard()) {
      return (card as CardDigimon).copyWith();
    }

    if (card.isEquipmentCard()) {
      return (card as CardEquipment).copyWith();
    }

    if (card.isSummonDigimonCard()) {
      return (card as CardSummonDigimon).copyWith();
    }

    return (card as CardEnergy).copyWith();
  }
}
