import 'package:net_monstrum_card_game/adapters/from_api/dto/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_energy_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_summon_digimon_dto.dart';
import 'package:net_monstrum_card_game/domain/editor_deck/card_deck_editor.dart';

class ListCardAdapterFromApi {
  static List<CardDeckEditor> getListOfCardsInstantiated(
      List<Map<String, dynamic>> cards) {
    List<CardDeckEditor> listOfCardsInstantiated = [];
    for (var i = 0; i < cards.length; i++) {
      listOfCardsInstantiated
          .add(ListCardAdapterFromApi.getInstanceCard(cards[i]));
    }
    return listOfCardsInstantiated;
  }

  static CardDeckEditor getInstanceCard(Map<String, dynamic> card) {
    if (card["type"] == 'Digimon') {
      CardDigimonDTO digimonCardDTO = CardDigimonDTO.fromJson(card);
      return CardDeckEditor.fromCardDigimonDTO(digimonCardDTO);
    }

    if (card["type"] == 'Equipment') {
      CardEquipmentDTO equipmentCardDTO = CardEquipmentDTO.fromJson(card);
      return CardDeckEditor.fromCardEquipmentDTO(equipmentCardDTO);
    }
    if (card["type"] == 'Energy') {
      CardEnergyDTO energyCardDTO = CardEnergyDTO.fromJson(card);
      return CardDeckEditor.fromCardEnergyDTO(energyCardDTO);
    }
    CardSummonDigimonDTO summonDigimonCardDTO =
        CardSummonDigimonDTO.fromJson(card);
    return CardDeckEditor.fromCardSummonDigimonDTO(summonDigimonCardDTO);
  }
}
