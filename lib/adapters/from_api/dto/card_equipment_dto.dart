class CardEquipmentDTO {
  final String id;
  final String name;
  final int attackPoints;
  final int healthPoints;
  final int? quantityOfTargets;
  final String targetScope;
  final int? quantityLimit;

  CardEquipmentDTO(
      {required this.id,
      required this.name,
      required this.attackPoints,
      required this.healthPoints,
      required this.quantityOfTargets,
      required this.targetScope,
      this.quantityLimit});

  factory CardEquipmentDTO.fromJson(Map<String, dynamic> json) {
    return CardEquipmentDTO(
        id: json['id'],
        name: json['name'],
        attackPoints: json['attackPointsCardEquipment'],
        healthPoints: json['healthPointsCardEquipment'],
        quantityOfTargets: json['quantityOfTargets'],
        targetScope: json['targetScope'],
        quantityLimit: json.containsKey("quantity") ? json["quantity"] : null);
  }
}
