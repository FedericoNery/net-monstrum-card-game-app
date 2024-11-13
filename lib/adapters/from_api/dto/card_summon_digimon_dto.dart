/* attackPointsCardSummonDigimon: 
healthPointsCardSummonDigimon:  */
class InternalCardDigimonDTO {
  String name;
  String color;
  int attackPoints;
  int healthPoints;
  int energyCount;
  int level;

  InternalCardDigimonDTO(
      {required this.name,
      required this.color,
      required this.attackPoints,
      required this.healthPoints,
      required this.energyCount,
      required this.level});
}

class CardSummonDigimonDTO {
  final String id;
  final String name;
  late final List<InternalCardDigimonDTO> digimonsCards;
  final int? quantityLimit;

  CardSummonDigimonDTO(
      {required this.id,
      required this.name,
      required this.digimonsCards,
      this.quantityLimit});

  factory CardSummonDigimonDTO.fromJson(Map<String, dynamic> json) {
    var listDigimonsCardsJsonList = json['digimonsCards'] as List;
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
        id: json['id'],
        name: json['name'],
        digimonsCards: listDigimonsCardsTransformed,
        quantityLimit: json.containsKey("quantity") ? json["quantity"] : null);
  }
}
