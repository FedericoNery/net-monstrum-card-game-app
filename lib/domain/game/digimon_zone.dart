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
    return 0;
  }

  int getHealthPoints(){
    return 0;
  }

  int getAttackPointsOfEvolutions(){
    return 0;
  }

  int getHealthPointsOfEvolutions(){
    return 0;
  }

}