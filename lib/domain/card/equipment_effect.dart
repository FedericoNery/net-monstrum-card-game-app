import 'card_digimon.dart';

class EquipmentEffect {
  int attackPoints;
  int healthPoints;

  EquipmentEffect(this.attackPoints, this.healthPoints);

  void applyTo(CardDigimon cardDigimon) {
    cardDigimon.currentAttackPoints += attackPoints;
    cardDigimon.currentHealthPoints += healthPoints;
  }
}
