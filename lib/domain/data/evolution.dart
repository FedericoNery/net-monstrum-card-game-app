class Evolution {
  String digimonName;
  String color;
  int attackPoints = 0;
  int deffensePoints = 0;

  Evolution(this.digimonName, this.color);

  String getDigimonImageFilename() {
    return '$digimonName.jpg';
  }

}