import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/card/equipment_effect.dart';

import '../data/evolution.dart';

class CardDigimon extends Card implements IColor {
  String digimonName;
  @override
  String color;
  int attackPoints;
  int healthPoints;
  Evolution? evolution;
  int energyCount;

  CardDigimon(id, this.digimonName, this.color, this.attackPoints,
      this.healthPoints, this.evolution, this.energyCount)
      : super(id) {
    type = "Digimon";
  }

  CardDigimon copyWith(
      {int? id,
      String? digimonName,
      String? color,
      int? attackPoints,
      int? healthPoints,
      Evolution? evolution,
      int? energyCount}) {
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

  @override
  bool isRedColor() {
    return color == CardColor.RED;
  }

  @override
  bool isBrownColor() {
    return color == CardColor.BROWN;
  }

  @override
  bool isBlueColor() {
    return color == CardColor.BLUE;
  }

  @override
  bool isWhiteColor() {
    return color == CardColor.WHITE;
  }

  @override
  bool isBlackColor() {
    return color == CardColor.BLACK;
  }

  @override
  bool isGreenColor() {
    return color == CardColor.GREEN;
  }

  void applyEquipmentEffect(EquipmentEffect equipmentEffect) {
    attackPoints += equipmentEffect.attackPoints;
    healthPoints += equipmentEffect.healthPoints;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'digimonName': digimonName,
      'color': color,
      'attackPoints': attackPoints,
      'healthPoints': healthPoints,
      'energyCount': energyCount,
      'evolution': evolution?.toJson(),
      "type": type
    };
  }

  static CardDigimon getInstanceFromSocket(Map<String, dynamic> card) {
    return CardDigimon(
        card["id"],
        card["digimonName"],
        card["color"],
        card["attackPoints"],
        card["healthPoints"],
        Evolution.getInstanceFromSocket(card["evolution"]),
        card["energyCount"]);
  }
}
