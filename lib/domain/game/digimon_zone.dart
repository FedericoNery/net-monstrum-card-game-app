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

    int evolutionAttackPoints = getEvolutionAttackPoints();

    return attackPoints + evolutionAttackPoints;
  }

  Map<String, int> getCardCounts(){
    Map<String, int> cardCounts = {};
    for (Card card in cards) {
      if (cardCounts.containsKey(card.digimonName)) {
        cardCounts[card.digimonName] = cardCounts[card.digimonName]! + 1;
      } else {
        cardCounts[card.digimonName] = 1;
      }
    }

    return cardCounts;
  }

  int getEvolutionAttackPoints() {
    Map<String, int> cardCounts = getCardCounts();

    int totalAttackPoints = 0;
    for (String digimonName in cardCounts.keys) {
      int count = cardCounts[digimonName]!;
      if (count >= 3) {
        Card card = cards.firstWhere((card) => card.digimonName == digimonName);
        totalAttackPoints += card.attackPoints * count;
      }
    }
    return totalAttackPoints;
  }



  int getHealthPoints(){
    int healthPoints = 0;
    for (Card card in cards){
      healthPoints += card.healthPoints;
    }

    int evolutionHealthPoints = getEvolutionHealthPoints();

    return healthPoints + evolutionHealthPoints;
  }

  int getEvolutionHealthPoints() {
    Map<String, int> cardCounts = getCardCounts();

    int totalHealthPoints = 0;
    for (String digimonName in cardCounts.keys) {
      int count = cardCounts[digimonName]!;
      if (count >= 3) {
        Card card = cards.firstWhere((card) => card.digimonName == digimonName);
        totalHealthPoints += card.healthPoints * count;
      }
    }
    return totalHealthPoints;
  }

  //TODO :: si hay 3 o mas cartas iguales, entonces sumar la totalidad de cada carta y mostrar la imagen de la evolución
  int getAttackPointsOfEvolutions(){
    return 0;
  }

  int getHealthPointsOfEvolutions(){
    return 0;
  }

}