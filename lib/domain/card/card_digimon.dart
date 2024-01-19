import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/card/equipment_effect.dart';

import '../data/evolution.dart';

class CardDigimon extends Card{
  String digimonName;
  String color;
  int attackPoints;
  int healthPoints;
  Evolution? evolution;
  int energyCount;

  CardDigimon(id, this.digimonName, this.color, this.attackPoints, this.healthPoints, this.evolution, this.energyCount) : super(id);

  CardDigimon copyWith({int? id, String? digimonName, String? color, int? attackPoints, int? healthPoints, Evolution? evolution, int? energyCount}){
    return CardDigimon(
      id ?? this.id,
      digimonName ?? this.digimonName,
      color ?? this.color,
      attackPoints ?? this.attackPoints,
      healthPoints ?? this.healthPoints,
      evolution ?? this.evolution,
      energyCount ?? this.energyCount,
    );
  }

  String getDigimonImageFilename() {
    return '$digimonName.jpg';
  }

  bool isRedColor(){ return color == CardColor.RED; }
  bool isBrownColor(){ return color == CardColor.BROWN; }
  bool isBlueColor(){ return color == CardColor.BLUE; }
  bool isWhiteColor(){ return color == CardColor.WHITE; }
  bool isBlackColor(){ return color == CardColor.BLACK; }
  bool isGreenColor(){ return color == CardColor.GREEN; }

  void applyEquipmentEffect(EquipmentEffect equipmentEffect){
    attackPoints += equipmentEffect.attackPoints;
    healthPoints += equipmentEffect.healthPoints;
  }
}