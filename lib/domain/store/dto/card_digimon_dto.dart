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
  final int price;
  final int quantity;
  final EvolutionDTO? evolution;

  CardDigimonDTO({
    required this.id,
    required this.name,
    required this.color,
    required this.attackPoints,
    required this.healthPoints,
    required this.energyCount,
    required this.level,
    required this.price,
    required this.quantity,
    required this.evolution,
  });

  factory CardDigimonDTO.fromJson(Map<String, dynamic> json) {
    return CardDigimonDTO(
      id: json["card"]['id'],
      name: json["card"]['name'],
      color: json["card"]['color'],
      attackPoints: json["card"]['attackPoints'],
      healthPoints: json["card"]['healthPoints'],
      energyCount: json["card"]['energyCount'],
      level: json["card"]['level'],
      price: json["card"]['price'],
      quantity: json['quantity'],
      evolution: json["card"]['evolution'] != null
          ? EvolutionDTO(
              name: json["card"]['evolution']['name'],
              color: json["card"]['evolution']['color'],
              attackPoints: json["card"]['evolution']['attackPoints'],
              healthPoints: json["card"]['evolution']['healthPoints'])
          : null,
    );
  }
}
