class CardDigimonDeckEditorDTO {
  final String id;
  final String name;
  final String color;
  final String type;
  final int? quantityLimit;

  CardDigimonDeckEditorDTO(
      {required this.id,
      required this.name,
      required this.color,
      required this.type,
      this.quantityLimit});

  factory CardDigimonDeckEditorDTO.fromJson(Map<String, dynamic> json) {
    return CardDigimonDeckEditorDTO(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        type: json['type'],
        quantityLimit: json.containsKey("quantity") ? json["quantity"] : null);
  }
}
