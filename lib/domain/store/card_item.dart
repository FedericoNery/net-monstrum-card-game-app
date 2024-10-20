import 'package:net_monstrum_card_game/domain/store/dto/card_digimon_dto.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_equipment_dto.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_energy_dto.dart';
import 'package:net_monstrum_card_game/domain/store/dto/card_summon_digimon_dto.dart';

class CardItem {
  final String id;
  final String name;
  final String? color;
  final String imageUrl; // URL de la imagen de la carta
  final DateTime creationDate;
  int ownedCount;
  final int maxCopies;
  final int price;

  CardItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
    required this.creationDate,
    required this.ownedCount,
    this.maxCopies = 4,
    required this.price,
  });

  bool get isNew => DateTime.now().difference(creationDate).inDays < 7;
  bool get isMaxOwned => ownedCount >= maxCopies;

  CardItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? color,
    DateTime? creationDate,
    int? ownedCount,
    int maxCopies = 4,
    int? price,
  }) {
    var cardItem = CardItem(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        color: color ?? this.color,
        creationDate: creationDate ?? this.creationDate,
        ownedCount: ownedCount ?? this.ownedCount,
        maxCopies: maxCopies,
        price: price ?? this.price);

    return cardItem;
  }

//TODO USAR GENERICS O HACER HERENCIA
  factory CardItem.fromCardDigimonDTO(CardDigimonDTO card) {
    return CardItem(
        id: card.id,
        name: card.name,
        color: card.color,
        imageUrl: """images/digimon/${card.name}.jpg""",
        ownedCount: card.quantity,
        creationDate: DateTime.now(),
        price: card.price);
  }

  factory CardItem.fromCardEnergyDTO(CardEnergyDTO card) {
    return CardItem(
        id: card.id,
        name: card.name,
        color: card.color,
        imageUrl: """images/energies/${card.name}.png""",
        ownedCount: card.quantity,
        creationDate: DateTime.now(),
        price: card.price);
  }

  factory CardItem.fromCardSummonDigimonDTO(CardSummonDigimonDTO card) {
    return CardItem(
        id: card.id,
        name: card.name,
        color: null,
        imageUrl: """images/summon_digimon/${card.name}.png""",
        ownedCount: card.quantity, //TODO NO ESTA BUENO ESTO
        creationDate: DateTime.now(),
        price: card.price);
  }

  factory CardItem.fromCardEquipmentDTO(CardEquipmentDTO card) {
    return CardItem(
        id: card.id,
        name: card.name,
        color: null,
        imageUrl: """images/equipments/${card.name}.png""",
        ownedCount: card.quantity, //TODO NO ESTA BUENO ESTO
        creationDate: DateTime.now(),
        price: card.price);
  }
}
