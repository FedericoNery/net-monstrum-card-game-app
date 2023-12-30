import 'package:net_monstrum_card_game/domain/card.dart';

class DigimonZone {
  List<Card> cards;

  DigimonZone(this.cards);

  void addToDigimonZone(Card card) {
    cards.add(card);
  }

  void removeFromDigimonZone(int index) {
    cards.removeAt(index);
  }

  int getAttackPoints(){
    int attackPoints = 0;
    for (Card card in cards){
        attackPoints += card.attackPoints;
    }

    return attackPoints;
  }

  int getHealthPoints(){
    int healthPoints = 0;
    for (Card card in cards){
      healthPoints += card.healthPoints;
    }

    return healthPoints;
  }

  //TODO :: si hay 3 o mas cartas iguales, entonces sumar la totalidad de cada carta y mostrar la imagen de la evolución
  int getAttackPointsOfEvolutions(){
    return 0;
  }

  int getHealthPointsOfEvolutions(){
    return 0;
  }

}