import 'package:flame/effects.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/base_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/digimon_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/energy_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/equipment_card.dart';
import 'package:net_monstrum_card_game/screens/multiplayer/components/cards/summon_digimon_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/effects/effects.dart';

import '../../../../domain/card/card_base.dart';
import '../../../../domain/card/card_digimon.dart';
import '../../../../domain/card/card_equipment.dart';
import '../../../../domain/game/digimon_zone.dart';
import '../../../../domain/game/tamer.dart';

//TODO :: analizar de renombrar la clase

class CardsMeasures {
  static const offsetX = 100.0;
  static const offsetYPlayer = 278.5;
  static const card1x = offsetX + 1;
  static const card1y = offsetYPlayer;
  static const card2x = offsetX + 94;
  static const card2y = offsetYPlayer;
  static const card3x = offsetX + 184;
  static const card3y = offsetYPlayer;
  static const card4x = offsetX + 274;
  static const card4y = offsetYPlayer;
  static const card5x = offsetX + 364;
  static const card5y = offsetYPlayer;
  static const card6x = offsetX + 445;
  static const card6y = offsetYPlayer;

  static const OFFSET_Y_INITIAL = 250.0;
  static const OFFSET_X_INITIAL = -100.0;

  static const offsetYCards = 35.0;
  static const card1Rivalx = offsetX + 1;
  static const card1Rivaly = offsetYCards;
  static const card2Rivalx = offsetX + 94;
  static const card2Rivaly = offsetYCards;
  static const card3Rivalx = offsetX + 184;
  static const card3Rivaly = offsetYCards;
  static const card4Rivalx = offsetX + 274;
  static const card4Rivaly = offsetYCards;
  static const card5Rivalx = offsetX + 364;
  static const card5Rivaly = offsetYCards;
  static const card6Rivalx = offsetX + 445;
  static const card6Rivaly = offsetYCards;
}

class CardWidgetFactory {
  late BaseCardComponent card1;
  late BaseCardComponent card2;
  late BaseCardComponent card3;
  late BaseCardComponent card4;
  late BaseCardComponent card5;
  late BaseCardComponent card6;
  bool isRival;
  Tamer tamer;

  CardWidgetFactory(this.tamer, this.isRival) {
    if (isRival) {
      card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.card1Rivalx,
          CardsMeasures.card1Rivaly, true, true);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.card2Rivalx,
          CardsMeasures.card2Rivaly, true, true);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.card3Rivalx,
          CardsMeasures.card3Rivaly, true, true);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.card4Rivalx,
          CardsMeasures.card4Rivaly, true, true);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.card5Rivalx,
          CardsMeasures.card5Rivaly, true, true);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.card6Rivalx,
          CardsMeasures.card6Rivaly, true, true);
    } else {
      card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.OFFSET_X_INITIAL,
          CardsMeasures.OFFSET_Y_INITIAL, true, false);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.OFFSET_X_INITIAL,
          CardsMeasures.OFFSET_Y_INITIAL, true, false);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.OFFSET_X_INITIAL,
          CardsMeasures.OFFSET_Y_INITIAL, true, false);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.OFFSET_X_INITIAL,
          CardsMeasures.OFFSET_Y_INITIAL, true, false);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.OFFSET_X_INITIAL,
          CardsMeasures.OFFSET_Y_INITIAL, true, false);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.OFFSET_X_INITIAL,
          CardsMeasures.OFFSET_Y_INITIAL, true, false);

      /* card1 = _getInstance(tamer.hand.cards[0], CardsMeasures.card1x, CardsMeasures.card1y, false, false);
      card2 = _getInstance(tamer.hand.cards[1], CardsMeasures.card2x, CardsMeasures.card2y, false, false);
      card3 = _getInstance(tamer.hand.cards[2], CardsMeasures.card3x, CardsMeasures.card3y, false, false);
      card4 = _getInstance(tamer.hand.cards[3], CardsMeasures.card4x, CardsMeasures.card4y, false, false);
      card5 = _getInstance(tamer.hand.cards[4], CardsMeasures.card5x, CardsMeasures.card5y, false, false);
      card6 = _getInstance(tamer.hand.cards[5], CardsMeasures.card6x, CardsMeasures.card6y, false, false);
    */
    }
  }

  BaseCardComponent _getInstance(
      Card card, double x, double y, bool isHidden, bool isRival) {
    if (card.isDigimonCard()) {
      return DigimonCardComponent(card as CardDigimon, x, y, isHidden, isRival);
    }

    if (card.isEquipmentCard()) {
      return CardEquipmentWidget(
          card as CardEquipment, x, y, isHidden, isRival);
    }

    if (card.isSummonDigimonCard()) {
      return SummonDigimonCardComponent(
          card as CardSummonDigimon, x, y, isHidden, isRival);
    }

    return EnergyCardComponent(card as CardEnergy, x, y, isHidden, isRival);
  }

  Future attackAnimation() async {
    if (card1.isMounted && card1 is DigimonCardComponent) {
      (card1 as DigimonCardComponent).attackAnimation();
      await Future.delayed(Duration(seconds: 1));
    }
    if (card2.isMounted && card2 is DigimonCardComponent) {
      (card2 as DigimonCardComponent).attackAnimation();
      await Future.delayed(Duration(seconds: 1));
    }
    if (card3.isMounted && card3 is DigimonCardComponent) {
      (card3 as DigimonCardComponent).attackAnimation();
      await Future.delayed(Duration(seconds: 1));
    }
    if (card4.isMounted && card4 is DigimonCardComponent) {
      (card4 as DigimonCardComponent).attackAnimation();
      await Future.delayed(Duration(seconds: 1));
    }
    if (card5.isMounted && card5 is DigimonCardComponent) {
      (card5 as DigimonCardComponent).attackAnimation();
      await Future.delayed(Duration(seconds: 1));
    }
    if (card6.isMounted && card6 is DigimonCardComponent) {
      (card6 as DigimonCardComponent).attackAnimation();
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void revealSelectedCards() {
    if (!card1.isRemoved && tamer.wasSummonedCard(card1.getUniqueCardId())) {
      card1.reveal();
      card1.update(1);
    }
    if (!card2.isRemoved && tamer.wasSummonedCard(card2.getUniqueCardId())) {
      card2.reveal();
      card2.update(1);
    }
    if (!card3.isRemoved && tamer.wasSummonedCard(card3.getUniqueCardId())) {
      card3.reveal();
      card3.update(1);
    }
    if (!card4.isRemoved && tamer.wasSummonedCard(card4.getUniqueCardId())) {
      card4.reveal();
      card4.update(1);
    }
    if (!card5.isRemoved && tamer.wasSummonedCard(card5.getUniqueCardId())) {
      card5.reveal();
      card5.update(1);
    }
    if (!card6.isRemoved && tamer.wasSummonedCard(card6.getUniqueCardId())) {
      card6.reveal();
      card6.update(1);
    }
  }

  void updateCurrentPoints(DigimonZone digimonZone) {
    if (card1.isMounted &&
        card1.card!.isDigimonCard() &&
        digimonZone.hasCardById(card1.card!.uniqueIdInGame!)) {
      var cardUpdated = digimonZone.getCardById(card1.card!.uniqueIdInGame!);
      card1.card = cardUpdated;
      card1.update(1);
    }
    if (card2.isMounted &&
        card2.card!.isDigimonCard() &&
        digimonZone.hasCardById(card2.card!.uniqueIdInGame!)) {
      var cardUpdated = digimonZone.getCardById(card2.card!.uniqueIdInGame!);
      card2.card = cardUpdated;
      card2.update(1);
    }
    if (card3.isMounted &&
        card3.card!.isDigimonCard() &&
        digimonZone.hasCardById(card3.card!.uniqueIdInGame!)) {
      var cardUpdated = digimonZone.getCardById(card3.card!.uniqueIdInGame!);
      card3.card = cardUpdated;
      card3.update(1);
    }
    if (card4.isMounted &&
        card4.card!.isDigimonCard() &&
        digimonZone.hasCardById(card4.card!.uniqueIdInGame!)) {
      var cardUpdated = digimonZone.getCardById(card4.card!.uniqueIdInGame!);
      card4.card = cardUpdated;
      card4.update(1);
    }
    if (card5.isMounted &&
        card5.card!.isDigimonCard() &&
        digimonZone.hasCardById(card5.card!.uniqueIdInGame!)) {
      var cardUpdated = digimonZone.getCardById(card5.card!.uniqueIdInGame!);
      card5.card = cardUpdated;
      card5.update(1);
    }
    if (card6.isMounted &&
        card6.card!.isDigimonCard() &&
        digimonZone.hasCardById(card6.card!.uniqueIdInGame!)) {
      var cardUpdated = digimonZone.getCardById(card6.card!.uniqueIdInGame!);
      card6.card = cardUpdated;
      card6.update(1);
    }
  }

  void deselectCards() {
    card1.deselectCardEffect();
    card2.deselectCardEffect();
    card3.deselectCardEffect();
    card4.deselectCardEffect();
    card5.deselectCardEffect();
    card6.deselectCardEffect();
  }

  void revealCards() {
    card1.isHidden = true;
    card2.isHidden = true;
    card3.isHidden = true;
    card4.isHidden = true;
    card5.isHidden = true;
    card6.isHidden = true;
  }

  void updateCards() {
    card1.update(1);
    card2.update(1);
    card3.update(1);
    card4.update(1);
    card5.update(1);
    card6.update(1);
  }

  void applyDrawEffect() {
    MoveEffect moveEffect = getDrawMoveEffect(
        card1.x, card1.y, CardsMeasures.card1x, CardsMeasures.card1y);
    MoveEffect moveEffect2 = getDrawMoveEffect(
        card2.x, card2.y, CardsMeasures.card2x, CardsMeasures.card2y);
    MoveEffect moveEffect3 = getDrawMoveEffect(
        card3.x, card3.y, CardsMeasures.card3x, CardsMeasures.card3y);
    MoveEffect moveEffect4 = getDrawMoveEffect(
        card4.x, card4.y, CardsMeasures.card4x, CardsMeasures.card4y);
    MoveEffect moveEffect5 = getDrawMoveEffect(
        card5.x, card5.y, CardsMeasures.card5x, CardsMeasures.card5y);
    MoveEffect moveEffect6 = getDrawMoveEffect(
        card6.x, card6.y, CardsMeasures.card6x, CardsMeasures.card6y);
    moveEffect.onComplete = () {
      card2.add(moveEffect2);
    };

    moveEffect2.onComplete = () {
      card3.add(moveEffect3);
    };

    moveEffect3.onComplete = () {
      card4.add(moveEffect4);
    };

    moveEffect4.onComplete = () {
      card5.add(moveEffect5);
    };

    moveEffect5.onComplete = () {
      card6.add(moveEffect6);
    };

    moveEffect6.onComplete = () {
      card1.setPosition(CardsMeasures.card1x, CardsMeasures.card1y);
      card2.setPosition(CardsMeasures.card2x, CardsMeasures.card2y);
      card3.setPosition(CardsMeasures.card3x, CardsMeasures.card3y);
      card4.setPosition(CardsMeasures.card4x, CardsMeasures.card4y);
      card5.setPosition(CardsMeasures.card5x, CardsMeasures.card5y);
      card6.setPosition(CardsMeasures.card6x, CardsMeasures.card6y);

      card1.reveal();
      card2.reveal();
      card3.reveal();
      card4.reveal();
      card5.reveal();
      card6.reveal();

      card1.setPosition(CardsMeasures.card1x, CardsMeasures.card1y);
      card2.setPosition(CardsMeasures.card2x, CardsMeasures.card2y);
      card3.setPosition(CardsMeasures.card3x, CardsMeasures.card3y);
      card4.setPosition(CardsMeasures.card4x, CardsMeasures.card4y);
      card5.setPosition(CardsMeasures.card5x, CardsMeasures.card5y);
      card6.setPosition(CardsMeasures.card6x, CardsMeasures.card6y);
      //card1.children.first.add(RemoveEffect(delay: 0.1));
      //card2.children.add(RemoveEffect(delay: 0.1));
      //card3.children.add(RemoveEffect(delay: 0.1));
      //card4.children.add(RemoveEffect(delay: 0.1));
      //card5.children.add(RemoveEffect(delay: 0.1));
      //card6.children.first.add(RemoveEffect(delay: 0.1));
    };

    card1.add(moveEffect);
  }
}
