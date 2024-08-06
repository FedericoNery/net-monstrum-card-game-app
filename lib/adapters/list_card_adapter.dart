import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_equipment.dart';
import 'package:net_monstrum_card_game/domain/card/card_programming.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';

class ListCardAdapter {
  static List<Card> getListOfCardsInstantiated(
      List<Map<String, dynamic>> cards) {
    List<Card> listOfCardsInstantiated = [];
    for (var i = 0; i < cards.length; i++) {
      listOfCardsInstantiated.add(ListCardAdapter.getInstanceCard(cards[i]));
    }
    return listOfCardsInstantiated;
  }

  static Card getInstanceCard(Map<String, dynamic> card) {
    if (card["type"] == 'Digimon') {
      CardDigimon digimonCard = CardDigimon.getInstanceFromSocket(card);
      return digimonCard;
    }

    if (card["type"] == 'Equipment') {
      CardEquipment equipmentCard = CardEquipment.getInstanceFromSocket(card);
      return equipmentCard;
    }
    if (card["type"] == 'Energy') {
      CardEnergy energyCard = CardEnergy.getInstanceFromSocket(card);
      return energyCard;
    }
    if (card["type"] == 'SummonDigimon') {
      CardSummonDigimon summonDigimonCard =
          CardSummonDigimon.getInstanceFromSocket(card);
      return summonDigimonCard;
    }

    CardProgramming programmingCard =
        CardProgramming.getInstanceFromSocket(card);
    return programmingCard;
  }
}
