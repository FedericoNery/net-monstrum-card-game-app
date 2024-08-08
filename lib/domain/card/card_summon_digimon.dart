import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';

class CardSummonDigimon extends Card {
  String name;
  List<CardDigimon> digimonsCards = [];

  CardSummonDigimon(id, this.name, this.digimonsCards) : super(id) {
    type = "SummonDigimon";
  }

  CardSummonDigimon copyWith({
    int? id,
    String? name,
    List<CardDigimon>? digimonsCards,
  }) {
    return CardSummonDigimon(
      id ?? this.id,
      name ?? this.name,
      digimonsCards ?? this.digimonsCards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "digimonsCards": digimonsToJson(digimonsCards),
      "type": type,
      "uniqueIdInGame": uniqueIdInGame
    };
  }

  List<Map<String, dynamic>> digimonsToJson(List<CardDigimon> cardDigimons) {
    List<Map<String, dynamic>> cardDigimonsJsonified = [];
    for (var i = 0; i < cardDigimons.length; i++) {
      cardDigimonsJsonified.add({
        "id": cardDigimons[i].id,
        "digimonName": cardDigimons[i].digimonName,
        "color": cardDigimons[i].color,
        "attackPoints": cardDigimons[i].attackPoints,
        "healthPoints": cardDigimons[i].healthPoints,
        "evolution": cardDigimons[i].evolution,
        "energyCount": cardDigimons[i].energyCount,
      });
    }
    return cardDigimonsJsonified;
  }

  static CardSummonDigimon getInstanceFromSocket(Map<String, dynamic> card) {
    CardSummonDigimon cardSummonDigimon = CardSummonDigimon(
        card["id"],
        card["name"],
        CardSummonDigimon.getListDigimonCardsFromSocket(card["digimonsCards"]));
    cardSummonDigimon.uniqueIdInGame = card["uniqueIdInGame"];
    return cardSummonDigimon;
  }

  static List<CardDigimon> getListDigimonCardsFromSocket(
      List<dynamic> originalCards) {
    List<CardDigimon> digimonCards = [];
    for (var i = 0; i < originalCards.length; i++) {
      digimonCards.add(CardDigimon.getInstanceFromSocket(originalCards[i]));
    }
    return digimonCards;
  }
}
