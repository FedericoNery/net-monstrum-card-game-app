import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart' as CardBase;
import 'package:net_monstrum_card_game/services/aggregation_service.dart';

class AppState extends ChangeNotifier {
  String _message = "Hola Mundo";
  String get message => _message;

  List<Map<String, dynamic>>? _selectedDeckToMultiplayer;
  List<Map<String, dynamic>>? get selectedDeckToMultiplayer =>
      _selectedDeckToMultiplayer;

  late List<CardBase.Card> castedDeckToMultiplayer;
  late int userId;
  late String username;
  Map<String, dynamic>? userInformation;

  AppState() {
    AggregationService service = AggregationService();
    Aggregation player = service.getAggregatioByUserId(1);
    castedDeckToMultiplayer = player.decksAggregations[0].cards;
    userId = player.user.id;
    username = player.user.username;
  }

  void updateMessage(String newMessage) {
    _message = newMessage;
    //notifyListeners(); // Notifica a los widgets que el estado ha cambiado
  }

  void setSelectedDeck(List<Map<String, dynamic>> deck) {
    _selectedDeckToMultiplayer = deck;
  }

  void setUserInformation(Map<String, dynamic> user) {
    userInformation = user;
  }
}
