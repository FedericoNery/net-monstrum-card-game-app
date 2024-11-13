import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_energy_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/available_to_editor_deck/card_summon_digimon_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_energy_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_summon_digimon_dto.dart';

class CardDeckEditor {
  String id;
  String name;
  String? color;
  String imageName;
  int? quantityLimit;

  CardDeckEditor(
      {required this.id,
      required this.name,
      required this.color,
      required this.imageName,
      required this.quantityLimit});

  //TODO USAR GENERICS O HACER HERENCIA
  factory CardDeckEditor.fromCardDigimonDTO(CardDigimonDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: card.color,
        imageName:
            """assets/images/digimon/${card.name.replaceAll(" ", "-")}.jpg""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardEnergyDTO(CardEnergyDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: card.color,
        imageName:
            """assets/images/energies/${card.name.replaceAll(" ", "-")}.png""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardSummonDigimonDTO(CardSummonDigimonDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: null,
        imageName:
            """assets/images/summon_digimon/${card.name.replaceAll(" ", "-")}.png""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardEquipmentDTO(CardEquipmentDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: null,
        imageName:
            """images/equipments/${card.name.replaceAll(" ", "-")}.png""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardDigimonDeckEditorDTO(
      CardDigimonDeckEditorDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: card.color,
        imageName:
            """assets/images/digimon/${card.name.replaceAll(" ", "-")}.jpg""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardEnergyDeckEditorDTO(
      CardEnergyDeckEditorDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: card.color,
        imageName:
            """assets/images/energies/${card.name.replaceAll(" ", "-")}.png""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardSummonDigimonDeckEditorDTO(
      CardSummonDigimonDeckEditorDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: null,
        imageName:
            """assets/images/summon_digimon/${card.name.replaceAll(" ", "-")}.png""",
        quantityLimit: card.quantityLimit);
  }

  factory CardDeckEditor.fromCardEquipmentDeckEditorDTO(
      CardEquipmentDeckEditorDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: null,
        imageName:
            """images/equipments/${card.name.replaceAll(" ", "-")}.png""",
        quantityLimit: card.quantityLimit);
  }
}
