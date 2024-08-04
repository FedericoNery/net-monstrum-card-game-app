import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';

class CardSummonDigimon extends Card {
  String name;
  List<CardDigimon> digimonsCards = [];

  CardSummonDigimon(id, this.name, this.digimonsCards) : super(id);

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
      "digimonsCards": digimonsToJson(digimonsCards)
    };
  }

  List<Map<String, dynamic>> digimonsToJson(List<CardDigimon> cardDigimons) {
    List<Map<String, dynamic>> cardDigimonsJsonified = [];
    for (var i = 0; i < cardDigimons.length; i++) {
      cardDigimonsJsonified.add({
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
}
