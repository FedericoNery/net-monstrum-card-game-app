class Card {
  int id;
  String digimonName;
  String color;
  int attackPoints;
  int hp;
  int evolutionId;
  int energyCount;

  Card(this.id, this.digimonName, this.color, this.attackPoints, this.hp, this.evolutionId, this.energyCount);

  String getDigimonImageFilename() {
    return '$digimonName.jpg';
  }
}