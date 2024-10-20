class CardEnergyDTO {
  final String id;
  final String name;
  final String color;
  final int energyCount;
  final int price;
  final int quantity;

  CardEnergyDTO({
    required this.id,
    required this.name,
    required this.color,
    required this.energyCount,
    required this.price,
    required this.quantity,
  });

  factory CardEnergyDTO.fromJson(Map<String, dynamic> json) {
    return CardEnergyDTO(
      id: json["card"]['id'],
      name: json["card"]['name'],
      color: json["card"]['color'],
      energyCount: json["card"]['energyCount'],
      price: json["card"]['price'],
      quantity: json['quantity'],
    );
  }
}
