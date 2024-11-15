import 'package:flutter/material.dart';

class CoinState extends ChangeNotifier {
  int _coins = 0;

  int get coins => _coins;

  void setCoins(int newCoins) {
    _coins = newCoins;
    notifyListeners();
  }

  void setWithoutListener(int newCoins) {
    _coins = newCoins;
  }
}
