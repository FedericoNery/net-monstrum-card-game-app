class CardEquipmentDeckEditorDTO {
  final String id;
  final String name;
  final String type;
  final int? quantityLimit;

  CardEquipmentDeckEditorDTO(
      {required this.id,
      required this.name,
      required this.type,
      this.quantityLimit});

  factory CardEquipmentDeckEditorDTO.fromJson(Map<String, dynamic> json) {
    return CardEquipmentDeckEditorDTO(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        quantityLimit: json.containsKey("quantity") ? json["quantity"] : null);
  }
}
