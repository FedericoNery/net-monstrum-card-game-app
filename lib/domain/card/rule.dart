import 'package:net_monstrum_card_game/domain/card/color.dart';

class ACTION {
  static const String SEND_TO_HAND = "ToHand";
  static const String SEND_TO_TRASH = "ToTrash";
  static const String SEND_TO_DECK = "ToDeck";
  static const String SEND_TO_FIELD = "ToField";
  static const String SEND_TO_ENEMY_FIELD = "ToEnemyField";
  static const String SEND_TO_ENEMY_HAND = "ToEnemyHand";
  static const String SEND_TO_ENEMY_TRASH = "ToEnemyTrash";
  static const String DEAL_DAMAGE_TO_ENEMY_FIELD = "DealDamageToEnemyField";
}

class FORM_OF_ACTION {
  static const String RANDOM = "Random";
  static const String SELECTED = "Selected";
  static const String NOT_APPLY = "Not Apply";
}

class TARGET_COLOR {
  static const String CARD_OF_COLOR_WHITE = "Card of color white";
  static const String CARD_OF_COLOR_RED = "Card of color red";
  static const String CARD_OF_COLOR_BLUE = "Card of color blue";
  static const String CARD_OF_COLOR_GREEN = "Card of color green";
  static const String CARD_OF_COLOR_BLACK = "Card of color black";
  static const String ANY_COLOR = "Any color";
}

class QUANTITY {
  static const String ALL = "All";
  static const String ONE = "ONE";
}

class TYPE_TARGET_CARD {
  static const String PROGRAMMING = 'PROGRAMMING';
  static const String DIGIMON = 'DIGIMON';
  static const String EQUIPMENT = 'EQUIPMENT';
  static const String SUMMON = 'SUMMON';
  static const String ENERGY = 'ENERGY';
}

class ZONE {
  static const String TRASH = 'TRASH';
  static const String FIELD = 'FIELD';
  static const String HAND = 'HAND';
  static const String DECK = 'DECK';
  static const String SUMMON_PROGRAMMING_ZONE = 'SUMMON_PROGRAMMING_ZONE';
  static const String ENEMY_TRASH = 'ENEMY_TRASH';
  static const String ENEMY_FIELD = 'ENEMY_FIELD';
  static const String ENEMY_HAND = 'ENEMY_HAND';
  static const String ENEMY_DECK = 'ENEMY_DECK';
  static const String ENEMY_SUMMON_PROGRAMMING_ZONE = 'ENEMY_SUMMON_PROGRAMMING_ZONE';
}

class Rule {
  String action;
  String targetZone;
  String formOfAction;
  List<String> targetColors = []; 
  //Si es vacia la lista aplica para cualquier color
  //Es decir, aquellos colores AFECTADOS por la carta
  List<String> targetTypeCard = []; 
  //Si es vacia la lista aplica para cualquier color
  //Es decir, aquellos tipos AFECTADOS por la carta
  String quantity;

  int? damage;

  Rule(this.action, this.targetZone, this.formOfAction, this.targetColors, this.targetTypeCard, this.quantity, this.damage);
}