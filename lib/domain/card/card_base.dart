import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/card_programming.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';

abstract class ICard {
  bool isDigimonCard();
  bool isEquipmentCard();
  bool isEnergyCard();
  bool isSummonDigimonCard();
  bool isDigimonOrEnergyCard();
  bool isProgrammingCard();
}

class Card implements ICard {
  String id;
  int? uniqueIdInGame;
  late String type;

  Card(this.id);

  @override
  bool isDigimonOrEnergyCard() {
    return this is CardDigimon || this is CardEnergy;
  }

  @override
  bool isEnergyCardOrEquipmentCard() {
    return this is CardEnergy || this is CardEquipment;
  }

  @override
  bool isDigimonCard() {
    return this is CardDigimon;
  }

  @override
  bool isEquipmentCard() {
    return this is CardEquipment;
  }

  @override
  bool isEnergyCard() {
    return this is CardEnergy;
  }

  @override
  bool isSummonDigimonCard() {
    return this is CardSummonDigimon;
  }

  @override
  bool isProgrammingCard() {
    return this is CardProgramming;
  }
}
