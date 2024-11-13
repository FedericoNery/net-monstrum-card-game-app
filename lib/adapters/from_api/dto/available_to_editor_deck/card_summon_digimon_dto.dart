class CardSummonDigimonDeckEditorDTO {
  final String id;
  final String name;
  final String type;
  final int? quantityLimit;

  CardSummonDigimonDeckEditorDTO(
      {required this.id,
      required this.name,
      required this.type,
      this.quantityLimit});

  factory CardSummonDigimonDeckEditorDTO.fromJson(Map<String, dynamic> json) {
    return CardSummonDigimonDeckEditorDTO(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        quantityLimit: json.containsKey("quantity") ? json["quantity"] : null);
  }
}
