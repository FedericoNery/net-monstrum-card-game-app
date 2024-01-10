import 'card-digimon.dart';

class EquipmentEffect{
  int attackPoints;
  int healthPoints;

  EquipmentEffect(this.attackPoints, this.healthPoints);

  void applyTo(CardDigimon cardDigimon){
    cardDigimon.attackPoints += this.attackPoints;
    cardDigimon.healthPoints += this.healthPoints;
  }

}