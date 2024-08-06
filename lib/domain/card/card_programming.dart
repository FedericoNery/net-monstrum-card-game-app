import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/card/rule.dart';

class CardProgramming extends Card {
  String name;
  @override
  String color;
  List<Rule> rules = [];

  CardProgramming(id, this.name, this.color, this.rules) : super(id) {
    type = "Programming";
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "color": color,
      "rules": rulesToJson(rules),
      "type": type
    };
  }

  List<Map<String, dynamic>> rulesToJson(List<Rule> rules) {
    List<Map<String, dynamic>> rulesJsonified = [];
    for (var i = 0; i < rules.length; i++) {
      rulesJsonified.add({
        "action": rules[i].action,
        "targetZone": rules[i].targetZone,
        "formOfAction": rules[i].formOfAction,
        "targetColors": rules[i].targetColors,
        "targetTypeCard": rules[i].targetTypeCard,
        "quantity": rules[i].quantity,
        "damage": rules[i].damage,
      });
    }
    return rulesJsonified;
  }

  static CardProgramming getInstanceFromSocket(Map<String, dynamic> card) {
    return CardProgramming(card["id"], card["name"], card["color"],
        Rule.getRulesFromSocket(card["rules"]));
  }
}
