import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:collection/collection.dart';

import '../card/equipment_effect.dart';

class DigimonZone {
  List<CardDigimon> cards;
  List<EquipmentEffect> equipmentEffectsQueue = [];

  DigimonZone(this.cards);

  void addToDigimonZone(CardDigimon card) {
    cards.add(card);
  }

  void removeFromDigimonZone(int index) {
    cards.removeAt(index);
  }

  int getAttackPoints() {
    int attackPoints = 0;
    for (CardDigimon card in cards) {
      attackPoints += card.attackPoints;
    }

    int evolutionAttackPoints = getEvolutionAttackPoints();

    return attackPoints + evolutionAttackPoints;
  }

  Map<String, int> getCardCounts() {
    Map<String, int> cardCounts = {};
    for (CardDigimon card in cards) {
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
        CardDigimon card =
            cards.firstWhere((card) => card.digimonName == digimonName);
        totalAttackPoints += card.attackPoints * count;
      }
    }
    return totalAttackPoints;
  }

  int getHealthPoints() {
    int healthPoints = 0;
    for (CardDigimon card in cards) {
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
        CardDigimon card =
            cards.firstWhere((card) => card.digimonName == digimonName);
        totalHealthPoints += card.healthPoints * count;
      }
    }
    return totalHealthPoints;
  }

  void addEquipmentsEffect(List<EquipmentEffect> equipmentEffects) {
    for (EquipmentEffect equipmentEffect in equipmentEffects) {
      equipmentEffectsQueue.add(equipmentEffect);
    }
  }

  void applyLastEquipmentEffectTo(CardDigimon cardDigimon) {
    EquipmentEffect equipmentEffect = equipmentEffectsQueue.removeLast();
    equipmentEffect.applyTo(cardDigimon);
  }

  void applyEffectTo(int digimonCardUniqueId, EquipmentEffect equipmentEffect) {
    int indexCard =
        cards.indexWhere((card) => card.uniqueIdInGame == digimonCardUniqueId);
    cards[indexCard].applyEquipmentEffect(equipmentEffect);
  }

  bool isDigimonCardByInternalId(int internalCardId) {
    var card =
        cards.firstWhereOrNull((card) => card.uniqueIdInGame == internalCardId);
    return card != null && card.isDigimonCard();
  }

  bool hasCardById(int internalCardId) {
    var card =
        cards.firstWhereOrNull((card) => card.uniqueIdInGame == internalCardId);
    return card != null;
  }

  CardDigimon getCardById(int internalCardId) {
    return cards.firstWhere((card) => card.uniqueIdInGame == internalCardId);
  }
}
