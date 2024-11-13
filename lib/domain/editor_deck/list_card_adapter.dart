import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_energy_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_summon_digimon_dto.dart';
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

  static List<CardDeckEditor> getListAvailableCardsInstantiated(
      List<Map<String, dynamic>> cards) {
    List<CardDeckEditor> listOfCardsInstantiated = [];
    for (var i = 0; i < cards.length; i++) {
      listOfCardsInstantiated
          .add(ListCardAdapterFromApi.getInstanceAvailableCard(cards[i]));
    }
    return listOfCardsInstantiated;
  }

  static CardDeckEditor getInstanceAvailableCard(Map<String, dynamic> card) {
    if (card["card"]["type"] == 'Digimon') {
      card["card"]["quantity"] = card["quantity"];
      CardDigimonDeckEditorDTO digimonCardDTO =
          CardDigimonDeckEditorDTO.fromJson(card["card"]);
      return CardDeckEditor.fromCardDigimonDeckEditorDTO(digimonCardDTO);
    }

    if (card["card"]["type"] == 'Equipment') {
      card["card"]["quantity"] = card["quantity"];
      CardEquipmentDeckEditorDTO equipmentCardDTO =
          CardEquipmentDeckEditorDTO.fromJson(card["card"]);
      return CardDeckEditor.fromCardEquipmentDeckEditorDTO(equipmentCardDTO);
    }
    if (card["card"]["type"] == 'Energy') {
      card["card"]["quantity"] = card["quantity"];
      CardEnergyDeckEditorDTO energyCardDTO =
          CardEnergyDeckEditorDTO.fromJson(card["card"]);
      return CardDeckEditor.fromCardEnergyDeckEditorDTO(energyCardDTO);
    }

    card["card"]["quantity"] = card["quantity"];
    CardSummonDigimonDeckEditorDTO summonDigimonCardDTO =
        CardSummonDigimonDeckEditorDTO.fromJson(card["card"]);
    return CardDeckEditor.fromCardSummonDigimonDeckEditorDTO(
        summonDigimonCardDTO);
  }
}
