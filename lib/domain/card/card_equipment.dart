import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/game/digimon_zone.dart';

import 'equipment_effect.dart';

// UNIQUE
// PARTIAL
// ALL

//TODO :: AMPLIAR FUNCIONALIDAD PARA QUE CARD EQUIPMENT FUNCIONE SEGUN LAS PROPIEDADES DE UN DIGIMON
// TODO :: analizar si es conveniente agregar una propiedad targetZone para que la carta sepa que digimon zone es el objetivo
// o sino delegar esto al usuario y que solo apliques efectos a las cartas que quieras
class CardEquipment extends Card {
  String name;
  int attackPoints;
  int healthPoints;
  int? quantityOfTargets = null;
  String targetScope = "UNIQUE";

  CardEquipment(id, this.name, this.attackPoints, this.healthPoints,
      this.targetScope, this.quantityOfTargets)
      : super(id) {
    type = "Equipment";
  }

  CardEquipment copyWith(
      {String? id,
      String? name,
      int? attackPoints,
      int? healthPoints,
      int? quantityOfTargets,
      String? targetScope}) {
    return CardEquipment(
        id ?? this.id,
        name ?? this.name,
        attackPoints ?? this.attackPoints,
        healthPoints ?? this.healthPoints,
        targetScope ?? this.targetScope,
        quantityOfTargets ?? this.quantityOfTargets);
  }

  //TODO :: PUEDE QUE ESTO ESTE SOBRE DESARROLADO
  //Puedo hacer que quantityOfTargets si es null -> aplica a todos y si posee un numero, que lo aplique a esa cantidad
  List<EquipmentEffect> getEffects(DigimonZone digimonZone) {
    List<EquipmentEffect> effects = [];
    if (this.targetScope == "UNIQUE") {
      effects.add(EquipmentEffect(attackPoints, healthPoints));
    }

    if (this.targetScope == "PARTIAL") {
      for (var i = 0; i < quantityOfTargets!; i++) {
        effects.add(EquipmentEffect(attackPoints, healthPoints));
      }
    }

    if (this.targetScope == "ALL") {
      for (var i = 0; i < digimonZone.cards.length; i++) {
        effects.add(EquipmentEffect(attackPoints, healthPoints));
      }
    }

    return effects;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "attackPoints": this.attackPoints,
      "healthPoints": this.healthPoints,
      "targetScope": this.targetScope,
      "quantityOfTargets": this.quantityOfTargets,
      "type": type,
      "uniqueIdInGame": uniqueIdInGame
    };
  }

  static CardEquipment getInstanceFromSocket(Map<String, dynamic> card) {
    CardEquipment cardEquipment = CardEquipment(
        card["id"],
        card["name"],
        card.containsKey("attackPoints")
            ? card["attackPoints"]
            : card["attackPointsCardEquipment"],
        card.containsKey("healthPoints")
            ? card["healthPoints"]
            : card["healthPointsCardEquipment"],
        card["targetScope"],
        card["quantityOfTargets"]);
    cardEquipment.uniqueIdInGame = card["uniqueIdInGame"];
    return cardEquipment;
  }
}
