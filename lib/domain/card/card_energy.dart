import 'package:net_monstrum_card_game/domain/card/card_base.dart';

class CardEnergy extends Card{
  String name;
  String color;
  int energyCount;

  CardEnergy(id, this.name, this.color, this.energyCount): super(id);

  CardEnergy copyWith({int? id, String? name, String? color, int? energyCount }){
    return CardEnergy(
        id ?? this.id,
        name ?? this.name,
        color ?? this.color,
        energyCount ?? this.energyCount
    );
  }
}