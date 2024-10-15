class CardEnergyDTO {
  final String id;
  final String name;
  final String color;
  final int energyCount;

  CardEnergyDTO({
    required this.id,
    required this.name,
    required this.color,
    required this.energyCount,
  });

  factory CardEnergyDTO.fromJson(Map<String, dynamic> json) {
    return CardEnergyDTO(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      energyCount: json['energyCount'],
    );
  }
}
