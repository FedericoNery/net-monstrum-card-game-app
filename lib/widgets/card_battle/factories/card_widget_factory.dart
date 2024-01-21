import 'package:net_monstrum_card_game/domain/card/card_energy.dart';

import '../../../domain/card/card_base.dart';
import '../../../domain/card/card_digimon.dart';
import '../../../domain/card/card_equipment.dart';
import '../../../domain/game/tamer.dart';
import '../card_energy.dart';
import '../card_widget_base.dart';
import '../digimon_card.dart';
import '../equipment_card.dart';

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
  late CardWidget card1;
  late CardWidget card2;
  late CardWidget card3;
  late CardWidget card4;
  late CardWidget card5;
  late CardWidget card6;
  bool isRival;
  Tamer tamer;

  CardWidgetFactory(this.tamer, this.isRival,
      addSelectedCard, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip,
      isEnabledToActivaEquipmentCard, activateEquipment) {

    if(isRival){
      card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.card1Rivalx, CardsMeasures.card1Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.card2Rivalx, CardsMeasures.card2Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.card3Rivalx, CardsMeasures.card3Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.card4Rivalx, CardsMeasures.card4Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.card5Rivalx, CardsMeasures.card5Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.card6Rivalx, CardsMeasures.card6Rivaly, true, addSelectedCard, true, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
    }
    else{
      card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.card1x, CardsMeasures.card1y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.card2x, CardsMeasures.card2y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.card3x, CardsMeasures.card3y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.card4x, CardsMeasures.card4y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.card5x, CardsMeasures.card5y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.card6x, CardsMeasures.card6y, false, addSelectedCard, false, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment);
    }
  }

  CardWidget _getInstance(Card card, x, y, isHidden, addSelectedCard, isRival, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, isEnabledToActivaEquipmentCard, activateEquipment){
    if (card.isDigimonCard()){
      return CardDigimonWidget(card as CardDigimon, x, y, isHidden, addSelectedCard, isRival, isEnabledToSummonDigimonCard, targetOfEquipment, isEnabledToEquip, card.internalGameId!);
    }

    if (card.isEquipmentCard()){
      return CardEquipmentWidget(card as CardEquipment, x, y, isHidden, addSelectedCard, isRival, isEnabledToActivaEquipmentCard, activateEquipment, card.internalGameId!);
    }

    return CardEnergyWidget(card as CardEnergy, x, y, isHidden, isRival, card.internalGameId!);
  }

  void revealSelectedCards() {
     if (!card1.isRemoved && tamer.wasSelectedCard(card1.internalCardId!)){
       card1.reveal();
     }
     if (!card2.isRemoved && tamer.wasSelectedCard(card2.internalCardId!)){
       card2.reveal();
     }
     if (!card3.isRemoved && tamer.wasSelectedCard(card3.internalCardId!)){
       card3.reveal();
     }
     if (!card4.isRemoved && tamer.wasSelectedCard(card4.internalCardId!)){
       card4.reveal();
     }
     if (!card5.isRemoved && tamer.wasSelectedCard(card5.internalCardId!)){
       card5.reveal();
     }
     if (!card6.isRemoved && tamer.wasSelectedCard(card6.internalCardId!)){
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