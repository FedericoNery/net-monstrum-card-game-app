import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';

abstract class ICard {
  bool isDigimonCard();
  bool isEquipmentCard();
  bool isEnergyCard();
  bool isSummonDigimonCard();
  bool isDigimonOrEnergyCard();
}

class Card implements ICard {
  int id;
  int? uniqueIdInGame;

  Card(this.id);

  @override
  bool isDigimonOrEnergyCard(){
    return this is CardDigimon || this is CardEnergy;
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
  
}