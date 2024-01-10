import 'package:net_monstrum_card_game/domain/Card.dart';
import 'package:net_monstrum_card_game/domain/color.dart';

import 'evolution.dart';

class CardDigimon extends Card{
  String digimonName;
  String color;
  int attackPoints;
  int healthPoints;
  Evolution? evolution;
  int energyCount;

  CardDigimon(id, this.digimonName, this.color, this.attackPoints, this.healthPoints, this.evolution, this.energyCount) : super(id);

  String getDigimonImageFilename() {
    return '$digimonName.jpg';
  }

  bool isRedColor(){ return this.color == CardColor.RED; }
  bool isBrownColor(){ return this.color == CardColor.BROWN; }
  bool isBlueColor(){ return this.color == CardColor.BLUE; }
  bool isWhiteColor(){ return this.color == CardColor.WHITE; }
  bool isBlackColor(){ return this.color == CardColor.BLACK; }
  bool isGreenColor(){ return this.color == CardColor.GREEN; }
}