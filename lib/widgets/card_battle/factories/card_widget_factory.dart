import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/base_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/summon_digimon_card.dart';

import '../../../domain/card/card_base.dart';
import '../../../domain/card/card_digimon.dart';
import '../../../domain/card/card_equipment.dart';
import '../../../domain/game/tamer.dart';
import '../cards/energy_card.dart';
import '../cards/digimon_card.dart';
import '../cards/equipment_card.dart';

//TODO :: analizar de renombrar la clase

class CardsMeasures{
  static const offsetX = 100.0;
  static const offsetYPlayer = 250.0;
  static const card1x = offsetX + 10;
  static const card1y = offsetYPlayer;
  static const card2x = offsetX + 100;
  static const card2y = offsetYPlayer;
  static const card3x = offsetX + 190;
  static const card3y = offsetYPlayer;
  static const card4x = offsetX + 280;
  static const card4y = offsetYPlayer;
  static const card5x = offsetX + 370;
  static const card5y = offsetYPlayer;
  static const card6x = offsetX + 450;
  static const card6y = offsetYPlayer;

  static const offsetYCards = 25.0;
  static const card1Rivalx = offsetX + 10;
  static const card1Rivaly = offsetYCards;
  static const card2Rivalx = offsetX + 100;
  static const card2Rivaly = offsetYCards;
  static const card3Rivalx = offsetX + 190;
  static const card3Rivaly = offsetYCards;
  static const card4Rivalx = offsetX + 280;
  static const card4Rivaly = offsetYCards;
  static const card5Rivalx = offsetX + 370;
  static const card5Rivaly = offsetYCards;
  static const card6Rivalx = offsetX + 450;
  static const card6Rivaly = offsetYCards;
}

class CardWidgetFactory{
  late BaseCardComponent card1;
  late BaseCardComponent card2;
  late BaseCardComponent card3;
  late BaseCardComponent card4;
  late BaseCardComponent card5;
  late BaseCardComponent card6;
  bool isRival;
  Tamer tamer;

  CardWidgetFactory(this.tamer, this.isRival) {

    if(isRival){
      card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.card1Rivalx, CardsMeasures.card1Rivaly, true, true);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.card2Rivalx, CardsMeasures.card2Rivaly, true, true);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.card3Rivalx, CardsMeasures.card3Rivaly, true, true);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.card4Rivalx, CardsMeasures.card4Rivaly, true, true);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.card5Rivalx, CardsMeasures.card5Rivaly, true, true);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.card6Rivalx, CardsMeasures.card6Rivaly, true, true);
    }
    else{
      card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.card1x, CardsMeasures.card1y, false, false);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.card2x, CardsMeasures.card2y, false, false);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.card3x, CardsMeasures.card3y, false, false);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.card4x, CardsMeasures.card4y, false, false);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.card5x, CardsMeasures.card5y, false, false);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.card6x, CardsMeasures.card6y, false, false);
    }
  }

  BaseCardComponent _getInstance(Card card, double x, double y, bool isHidden, bool isRival){
    if (card.isDigimonCard()){
      return DigimonCardComponent(card as CardDigimon, x, y, isHidden, isRival);
    }

    if (card.isEquipmentCard()){
      return CardEquipmentWidget(card as CardEquipment, x, y, isHidden, isRival);
    }

    if (card.isSummonDigimonCard()){
      return SummonDigimonCardComponent(card as CardSummonDigimon, x, y, isHidden, isRival);
    }

    return EnergyCardComponent(card as CardEnergy, x, y, isHidden, isRival);
  }

  void revealSelectedCards() {
     if (!card1.isRemoved && tamer.wasSelectedCard(card1.getUniqueCardId())){
       card1.reveal();
     }
     if (!card2.isRemoved && tamer.wasSelectedCard(card2.getUniqueCardId())){
       card2.reveal();
     }
     if (!card3.isRemoved && tamer.wasSelectedCard(card3.getUniqueCardId())){
       card3.reveal();
     }
     if (!card4.isRemoved && tamer.wasSelectedCard(card4.getUniqueCardId())){
       card4.reveal();
     }
     if (!card5.isRemoved && tamer.wasSelectedCard(card5.getUniqueCardId())){
       card5.reveal();
     }
     if (!card6.isRemoved && tamer.wasSelectedCard(card6.getUniqueCardId())){
       card6.reveal();
     }
  }

  void deselectCards(){
    card1.deselectCardEffect();
    card2.deselectCardEffect();
    card3.deselectCardEffect();
    card4.deselectCardEffect();
    card5.deselectCardEffect();
    card6.deselectCardEffect();
  }

  void revealCards(){
    card1.isHidden = true;
    card2.isHidden = true;
    card3.isHidden = true;
    card4.isHidden = true;
    card5.isHidden = true;
    card6.isHidden = true;
  }

  void updateCards(){
    card1.update(1);
    card2.update(1);
    card3.update(1);
    card4.update(1);
    card5.update(1);
    card6.update(1);
  }

}