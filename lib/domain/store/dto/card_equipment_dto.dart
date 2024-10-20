class CardEquipmentDTO {
  final String id;
  final String name;
  final int attackPoints;
  final int healthPoints;
  final int? quantityOfTargets;
  final String targetScope;
  final int price;
  final int quantity;

  CardEquipmentDTO({
    required this.id,
    required this.name,
    required this.attackPoints,
    required this.healthPoints,
    required this.quantityOfTargets,
    required this.targetScope,
    required this.price,
    required this.quantity,
  });

  factory CardEquipmentDTO.fromJson(Map<String, dynamic> json) {
    return CardEquipmentDTO(
      id: json["card"]['id'],
      name: json["card"]['name'],
      attackPoints: json["card"]['attackPointsCardEquipment'],
      healthPoints: json["card"]['healthPointsCardEquipment'],
      quantityOfTargets: json["card"]['quantityOfTargets'],
      targetScope: json["card"]['targetScope'],
      price: json["card"]['price'],
      quantity: json['quantity'],
    );
  }
}
