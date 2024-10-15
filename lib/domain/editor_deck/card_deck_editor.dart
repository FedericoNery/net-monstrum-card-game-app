import 'package:net_monstrum_card_game/adapters/from_api/dto/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_energy_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/adapters/from_api/dto/card_summon_digimon_dto.dart';

class CardDeckEditor {
  String id;
  String name;
  String? color;
  String imageName;

  CardDeckEditor(
      {required this.id,
      required this.name,
      required this.color,
      required this.imageName});

  //TODO USAR GENERICS O HACER HERENCIA
  factory CardDeckEditor.fromCardDigimonDTO(CardDigimonDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: card.color,
        imageName: """assets/images/digimon/${card.name}.jpg""");
  }

  factory CardDeckEditor.fromCardEnergyDTO(CardEnergyDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: card.color,
        imageName: """assets/images/energies/${card.name}.png""");
  }

  factory CardDeckEditor.fromCardSummonDigimonDTO(CardSummonDigimonDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: null,
        imageName: """assets/images/summon_digimon/${card.name}.png""");
  }

  factory CardDeckEditor.fromCardEquipmentDTO(CardEquipmentDTO card) {
    return CardDeckEditor(
        id: card.id,
        name: card.name,
        color: null,
        imageName: """images/equipments/${card.name}.png""");
  }
}
