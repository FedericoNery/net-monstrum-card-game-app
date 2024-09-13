import 'package:net_monstrum_card_game/adapters/energies_adapter.dart';
import 'package:net_monstrum_card_game/adapters/list_card_adapter.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
import 'dart:convert';

class BattleCardGameAdapter {
  BattleCardGameFromJSON getBattleCardGameFromSocket(
      dynamic dataFromSocket, bool isPlayer) {
    var jsonMap = json.decode(dataFromSocket);
    Map<String, dynamic> flutterMap = Map<String, dynamic>.from(jsonMap);

    List<Card> playerDeckCards = ListCardAdapter.getListOfCardsInstantiated(
        flutterMap["gameData"]["game"]["field1"]["deck"]["cartas"]);
    List<Card> playerHandCards = ListCardAdapter.getListOfCardsInstantiated(
        flutterMap["gameData"]["game"]["field1"]["hand"]["cartas"]);
    List<Card> playerTrashCards = ListCardAdapter.getListOfCardsInstantiated(
        flutterMap["gameData"]["game"]["field1"]["trash"]["cartas"]);
    List<CardDigimon> playerDigimonZoneCards =
        ListCardAdapter.getListOfDigimonCardsInstantiated(
            flutterMap["gameData"]["game"]["field1"]["digimonZone"]["cartas"]);

    List<Card> rivalDeckCards = ListCardAdapter.getListOfCardsInstantiated(
        flutterMap["gameData"]["game"]["field2"]["deck"]["cartas"]);
    List<Card> rivalHandCards = ListCardAdapter.getListOfCardsInstantiated(
        flutterMap["gameData"]["game"]["field2"]["hand"]["cartas"]);
    List<Card> rivalTrashCards = ListCardAdapter.getListOfCardsInstantiated(
        flutterMap["gameData"]["game"]["field2"]["trash"]["cartas"]);
    List<CardDigimon> rivalDigimonZoneCards =
        ListCardAdapter.getListOfDigimonCardsInstantiated(
            flutterMap["gameData"]["game"]["field2"]["digimonZone"]["cartas"]);

    EnergiesCounters energiesPlayer = EnergiesAdapter.getEnergiesFromSocketInfo(
        flutterMap["gameData"]["game"]["field1"]["cantidadesEnergias"]);
    EnergiesCounters energiesRival = EnergiesAdapter.getEnergiesFromSocketInfo(
        flutterMap["gameData"]["game"]["field2"]["cantidadesEnergias"]);

    String phaseGame = flutterMap["gameData"]["game"]["estadoDeLaRonda"];

    bool player1SummonCards =
        flutterMap["gameData"]["game"]["player1SummonCards"];

    bool player2SummonCards =
        flutterMap["gameData"]["game"]["player2SummonCards"];

    int apPlayer = flutterMap["gameData"]["game"]["field1"]["attackPoints"];
    int apRival = flutterMap["gameData"]["game"]["field2"]["attackPoints"];

    int hpPlayer = flutterMap["gameData"]["game"]["field1"]["healthPoints"];
    int hpRival = flutterMap["gameData"]["game"]["field2"]["healthPoints"];

    int wonRoundsPlayer = flutterMap["gameData"]["game"]["roundsPlayer1"];
    int wonRoundsRival = flutterMap["gameData"]["game"]["roundsPlayer2"];

    return BattleCardGameFromJSON(
        playerDeckCards: isPlayer ? playerDeckCards : rivalDeckCards,
        playerHandCards: isPlayer ? playerHandCards : rivalHandCards,
        playerDigimonZoneCards:
            isPlayer ? playerDigimonZoneCards : rivalDigimonZoneCards,
        playerTrashCards: isPlayer ? playerTrashCards : rivalTrashCards,
        rivalDeckCards: isPlayer ? rivalDeckCards : playerDeckCards,
        rivalHandCards: isPlayer ? rivalHandCards : playerHandCards,
        rivalDigimonZoneCards:
            isPlayer ? rivalDigimonZoneCards : playerDigimonZoneCards,
        rivalTrashCards: isPlayer ? rivalTrashCards : playerTrashCards,
        energiesPlayer: isPlayer ? energiesPlayer : energiesRival,
        energiesRival: isPlayer ? energiesRival : energiesPlayer,
        apPlayer: isPlayer ? apPlayer : apRival,
        apRival: isPlayer ? apRival : apPlayer,
        hpPlayer: isPlayer ? hpPlayer : hpRival,
        hpRival: isPlayer ? hpRival : hpPlayer,
        phaseGame: phaseGame,
        playerSummonedDigimons:
            isPlayer ? player1SummonCards : player2SummonCards,
        wonRoundsPlayer: isPlayer ? wonRoundsPlayer : wonRoundsRival,
        wonRoundsRival: isPlayer ? wonRoundsRival : wonRoundsPlayer);
  }
}

class BattleCardGameFromJSON {
  late List<Card> playerDeckCards;
  late List<Card> playerHandCards;
  late List<CardDigimon> playerDigimonZoneCards;
  late List<Card> playerTrashCards;
  late List<Card> rivalDeckCards;
  late List<Card> rivalHandCards;
  late List<CardDigimon> rivalDigimonZoneCards;
  late List<Card> rivalTrashCards;
  late EnergiesCounters energiesPlayer;
  late EnergiesCounters energiesRival;
  late String phaseGame;
  late bool playerSummonedDigimons;
  late int apPlayer;
  late int apRival;
  late int hpPlayer;
  late int hpRival;
  late int wonRoundsPlayer;
  late int wonRoundsRival;

  BattleCardGameFromJSON(
      {required this.playerDeckCards,
      required this.playerHandCards,
      required this.playerDigimonZoneCards,
      required this.playerTrashCards,
      required this.rivalDeckCards,
      required this.rivalHandCards,
      required this.rivalDigimonZoneCards,
      required this.rivalTrashCards,
      required this.energiesPlayer,
      required this.energiesRival,
      required this.apPlayer,
      required this.apRival,
      required this.hpPlayer,
      required this.hpRival,
      required this.phaseGame,
      required this.playerSummonedDigimons,
      required this.wonRoundsPlayer,
      required this.wonRoundsRival});
}
