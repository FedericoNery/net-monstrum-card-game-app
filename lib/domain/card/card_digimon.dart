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
  int currentAttackPoints = 0;
  int currentHealthPoints = 0;
  Evolution? evolution;
  int energyCount;

  CardDigimon(id, this.digimonName, this.color, this.attackPoints,
      this.healthPoints, this.evolution, this.energyCount)
      : super(id) {
    type = "Digimon";
    currentAttackPoints = attackPoints;
    currentHealthPoints = healthPoints;
  }

  CardDigimon copyWith(
      {String? id,
      String? digimonName,
      String? color,
      int? attackPoints,
      int? healthPoints,
      Evolution? evolution,
      int? energyCount}) {
    var cardDigimon = CardDigimon(
      id ?? this.id,
      digimonName ?? this.digimonName,
      color ?? this.color,
      attackPoints ?? this.attackPoints,
      healthPoints ?? this.healthPoints,
      evolution ?? this.evolution,
      energyCount ?? this.energyCount,
    );

    cardDigimon.currentAttackPoints = cardDigimon.attackPoints;
    cardDigimon.currentHealthPoints = cardDigimon.healthPoints;
    return cardDigimon;
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
      'currentAttackPoints': currentAttackPoints,
      'currentHealthPoints': currentHealthPoints,
      'energyCount': energyCount,
      'evolution': evolution?.toJson(),
      "type": type,
      "uniqueIdInGame": uniqueIdInGame
    };
  }

  static CardDigimon getInstanceFromSocket(Map<String, dynamic> card) {
    CardDigimon cardDigimon = CardDigimon(
        card["id"],
        card.containsKey("digimonName") ? card["digimonName"] : card["name"],
        card["color"],
        card["attackPoints"],
        card["healthPoints"],
        Evolution.getInstanceFromSocket(card["evolution"]),
        card["energyCount"]);
    cardDigimon.uniqueIdInGame = card["uniqueIdInGame"];
    cardDigimon.currentAttackPoints = card.containsKey('currentAttackPoints')
        ? card["currentAttackPoints"]
        : cardDigimon.attackPoints;
    cardDigimon.currentHealthPoints = card.containsKey('currentHealthPoints')
        ? card["currentHealthPoints"]
        : cardDigimon.healthPoints;
    return cardDigimon;
  }

  void resetCurrentAtkAndHpPoints() {
    currentAttackPoints = attackPoints;
    currentHealthPoints = healthPoints;
  }
}
