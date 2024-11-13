class EvolutionDTO {
  final String name;
  final String color;
  final int attackPoints;
  final int healthPoints;

  EvolutionDTO(
      {required this.name,
      required this.color,
      required this.attackPoints,
      required this.healthPoints});
}

class CardDigimonDTO {
  final String id;
  final String name;
  final String color;
  final int attackPoints;
  final int healthPoints;
  final int energyCount;
  final int level;
  final int? quantityLimit;
  final EvolutionDTO? evolution;

  CardDigimonDTO(
      {required this.id,
      required this.name,
      required this.color,
      required this.attackPoints,
      required this.healthPoints,
      required this.energyCount,
      required this.level,
      required this.evolution,
      this.quantityLimit});

  factory CardDigimonDTO.fromJson(Map<String, dynamic> json) {
    return CardDigimonDTO(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        attackPoints: json['attackPoints'],
        healthPoints: json['healthPoints'],
        energyCount: json['energyCount'],
        level: json['level'],
        evolution: json['evolution'] != null
            ? EvolutionDTO(
                name: json['evolution']['name'],
                color: json['evolution']['color'],
                attackPoints: json['evolution']['attackPoints'],
                healthPoints: json['evolution']['healthPoints'])
            : null,
        quantityLimit: json.containsKey("quantity") ? json["quantity"] : null);
  }
}
