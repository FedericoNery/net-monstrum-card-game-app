import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';
import 'package:net_monstrum_card_game/domain/card/energy_effect.dart';

class CardEnergy extends Card implements IColor{
  String name;
  @override
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

  @override
  bool isRedColor(){ return color == CardColor.RED; }
  @override
  bool isBrownColor(){ return color == CardColor.BROWN; }
  @override
  bool isBlueColor(){ return color == CardColor.BLUE; }
  @override
  bool isWhiteColor(){ return color == CardColor.WHITE; }
  @override
  bool isBlackColor(){ return color == CardColor.BLACK; }
  @override
  bool isGreenColor(){ return color == CardColor.GREEN; }

  EnergyEffect getEnergyEffect(){
    return EnergyEffect(energyCount, color);
  }
}