/* attackPointsCardSummonDigimon: 
healthPointsCardSummonDigimon:  */
class InternalCardDigimonDTO {
  String name;
  String color;
  int attackPoints;
  int healthPoints;
  int energyCount;
  int level;

  InternalCardDigimonDTO({
    required this.name,
    required this.color,
    required this.attackPoints,
    required this.healthPoints,
    required this.energyCount,
    required this.level,
  });
}

class CardSummonDigimonDTO {
  final String id;
  final String name;
  late final List<InternalCardDigimonDTO> digimonsCards;
  final int price;
  final int quantity;

  CardSummonDigimonDTO({
    required this.id,
    required this.name,
    required this.digimonsCards,
    required this.price,
    required this.quantity,
  });

  factory CardSummonDigimonDTO.fromJson(Map<String, dynamic> json) {
    var listDigimonsCardsJsonList = json["card"]['digimonsCards'] as List;
    var listDigimonsCardsTransformed =
        listDigimonsCardsJsonList.map((cardJson) {
      return InternalCardDigimonDTO(
        name: cardJson['name'],
        color: cardJson['color'],
        attackPoints: cardJson['attackPointsCardSummonDigimon'],
        healthPoints: cardJson['healthPointsCardSummonDigimon'],
        level: cardJson['level'],
        energyCount: cardJson['energyCount'],
      );
    }).toList();
    return CardSummonDigimonDTO(
      id: json["card"]['id'],
      name: json["card"]['name'],
      digimonsCards: listDigimonsCardsTransformed,
      price: json["card"]['price'],
      quantity: json['quantity'],
    );
  }
}
