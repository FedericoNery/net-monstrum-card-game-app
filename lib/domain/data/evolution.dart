class Evolution {
  String digimonName;
  String color;
  int attackPoints = 0;
  int healthPoints = 0;

  Evolution(this.digimonName, this.color);

  String getDigimonImageFilename() {
    return '$digimonName.jpg';
  }

  Map<String, dynamic> toJson() {
    return {
      "digimonName": digimonName,
      "color": color,
      "attackPoints": attackPoints,
      "healthPoints": healthPoints
    };
  }

  static Evolution? getInstanceFromSocket(Map<String, dynamic>? evolution) {
    if (evolution != null) {
      return Evolution(evolution["digimonName"], evolution["color"]);
    }

    return null;
  }
}
