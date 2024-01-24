
import '../game/tamer.dart';

class EnergyEffect{
  int value;
  String color;

  EnergyEffect(this.value, this.color);

  void applyTo(Tamer tamer){
    tamer.energiesCounters.applyEffectByColor(color, value);
  }

  bool isPositive(){
    return value > 0;
  }

}