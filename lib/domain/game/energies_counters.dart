import 'package:net_monstrum_card_game/domain/card/color.dart';

class EnergiesCounters {
  int red;
  int blue;
  int brown;
  int white;
  int green;
  int black;

  EnergiesCounters(this.red, this.blue, this.brown, this.black, this.green, this.white);
  EnergiesCounters.initAllInZero(): red=0, blue=0, brown=0, black=0, green=0, white=0;

  void accumulate(EnergiesCounters energiesCounters){
    this.red += energiesCounters.red;
    this.blue += energiesCounters.blue;
    this.white += energiesCounters.white;
    this.green += energiesCounters.green;
    this.black += energiesCounters.black;
    this.brown += energiesCounters.brown;
  }

  EnergiesCounters getCopy(){
    return EnergiesCounters(red, blue, brown, black, green, white);
  }

  bool canBeDiscountedByColor(String color){
    if (CardColor.RED == color){
      return this.red - 1 >= 0;
    }
    if (CardColor.GREEN == color){
      return this.green - 1 >= 0;
    }
    if (CardColor.BROWN == color){
      return this.brown - 1 >= 0;
    }
    if (CardColor.BLACK == color){
      return this.black - 1 >= 0;
    }
    if (CardColor.BLUE == color){
      return this.blue - 1 >= 0;
    }
    if (CardColor.WHITE == color){
      return this.white - 1 >= 0;
    }

    return false;
  }

  void discountByColor(String color){
    if (CardColor.RED == color){
      this.red -= 1;
    }
    if (CardColor.GREEN == color){
      this.green -= 1;
    }
    if (CardColor.BROWN == color){
      this.brown -= 1;
    }
    if (CardColor.BLACK == color){
      this.black -= 1;
    }
    if (CardColor.BLUE == color){
      this.blue -= 1;
    }
    if (CardColor.WHITE == color){
      this.white -= 1;
    }
  }

  bool allEnergiesAreZeroOrMore(){
    return this.green >= 0 && this.white >= 0 && this.blue >= 0 && this.red >= 0 && this.brown >= 0 && this.black >= 0;
  }
}