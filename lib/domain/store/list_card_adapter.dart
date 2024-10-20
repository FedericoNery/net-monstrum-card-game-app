import 'package:net_monstrum_card_game/domain/store/card_item.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_energy_dto.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_summon_digimon_dto.dart';

class ListCardAdapterFromApi {
  static List<CardItem> getListOfCardsInstantiated(
      List<Map<String, dynamic>> purchasedCards) {
    List<CardItem> listOfCardsInstantiated = [];
    for (var i = 0; i < purchasedCards.length; i++) {
      listOfCardsInstantiated
          .add(ListCardAdapterFromApi.getInstanceCard(purchasedCards[i]));
    }
    return listOfCardsInstantiated;
  }

  static CardItem getInstanceCard(Map<String, dynamic> purchasedCard) {
    if (purchasedCard["card"]["type"] == 'Digimon') {
      CardDigimonDTO digimonCardDTO = CardDigimonDTO.fromJson(purchasedCard);
      return CardItem.fromCardDigimonDTO(digimonCardDTO);
    }

    if (purchasedCard["card"]["type"] == 'Equipment') {
      CardEquipmentDTO equipmentCardDTO =
          CardEquipmentDTO.fromJson(purchasedCard);
      return CardItem.fromCardEquipmentDTO(equipmentCardDTO);
    }
    if (purchasedCard["card"]["type"] == 'Energy') {
      CardEnergyDTO energyCardDTO = CardEnergyDTO.fromJson(purchasedCard);
      return CardItem.fromCardEnergyDTO(energyCardDTO);
    }
    CardSummonDigimonDTO summonDigimonCardDTO =
        CardSummonDigimonDTO.fromJson(purchasedCard);
    return CardItem.fromCardSummonDigimonDTO(summonDigimonCardDTO);
  }
}
