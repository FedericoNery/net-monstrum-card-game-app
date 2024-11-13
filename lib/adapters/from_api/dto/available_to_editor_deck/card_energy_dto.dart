class CardEnergyDeckEditorDTO {
  final String id;
  final String name;
  final String type;
  final String color;
  final int? quantityLimit;

  CardEnergyDeckEditorDTO(
      {required this.id,
      required this.name,
      required this.color,
      required this.type,
      this.quantityLimit});

  factory CardEnergyDeckEditorDTO.fromJson(Map<String, dynamic> json) {
    return CardEnergyDeckEditorDTO(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      type: json['type'],
      quantityLimit: json.containsKey("quantity") ? json["quantity"] : null,
    );
  }
}
