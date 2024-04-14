import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/card/rule.dart';

class CardProgramming extends Card{
  String name;
  @override
  String color;
  List<Rule> rules = [];

  CardProgramming(id, this.name, this.color, this.rules) : super(id);

}