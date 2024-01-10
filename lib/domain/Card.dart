import 'package:net_monstrum_card_game/domain/card-digimon.dart';
import 'package:net_monstrum_card_game/domain/card-equipment.dart';

abstract class ICard {
  bool isDigimonCard();
  bool isEquipmentCard();
}

class Card implements ICard {
  int id;

  Card(this.id);

  @override
  bool isDigimonCard() {
    return this is CardDigimon;
  }

  @override
  bool isEquipmentCard() {
    return this is CardEquipment;
  }

}