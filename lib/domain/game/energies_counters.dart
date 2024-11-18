import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:net_monstrum_card_game/domain/card/color.dart';

class EnergiesCounters {
  int red;
  int blue;
  int brown;
  int white;
  int green;
  int black;
  final enableSummonDigimonWithOneEnergy =
      dotenv.env['ENABLE_SUMMON_DIGIMON_WITH_ONE_ENERGY']?.toLowerCase() ==
          'true';

  EnergiesCounters(
      this.red, this.blue, this.brown, this.black, this.green, this.white);
  EnergiesCounters.initAllInZero()
      : red = 0,
        blue = 0,
        brown = 0,
        black = 0,
        green = 0,
        white = 0;

  void accumulate(EnergiesCounters energiesCounters) {
    red += energiesCounters.red;
    blue += energiesCounters.blue;
    white += energiesCounters.white;
    green += energiesCounters.green;
    black += energiesCounters.black;
    brown += energiesCounters.brown;
  }

  EnergiesCounters getCopy() {
    return EnergiesCounters(red, blue, brown, black, green, white);
  }

  bool canBeDiscountedByColor(String color) {
    if (CardColor.RED == color) {
      return red - 1 >= 0;
    }
    if (CardColor.GREEN == color) {
      return green - 1 >= 0;
    }
    if (CardColor.BROWN == color) {
      return brown - 1 >= 0;
    }
    if (CardColor.BLACK == color) {
      return black - 1 >= 0;
    }
    if (CardColor.BLUE == color) {
      return blue - 1 >= 0;
    }
    if (CardColor.WHITE == color) {
      return white - 1 >= 0;
    }

    return false;
  }

  bool canBeDiscountedByColorAndQuantity(String color, int quantity) {
    if (CardColor.RED == color) {
      return red - (enableSummonDigimonWithOneEnergy ? 1 : quantity) >= 0;
    }
    if (CardColor.GREEN == color) {
      return green - (enableSummonDigimonWithOneEnergy ? 1 : quantity) >= 0;
    }
    if (CardColor.BROWN == color) {
      return brown - (enableSummonDigimonWithOneEnergy ? 1 : quantity) >= 0;
    }
    if (CardColor.BLACK == color) {
      return black - (enableSummonDigimonWithOneEnergy ? 1 : quantity) >= 0;
    }
    if (CardColor.BLUE == color) {
      return blue - (enableSummonDigimonWithOneEnergy ? 1 : quantity) >= 0;
    }
    if (CardColor.WHITE == color) {
      return white - (enableSummonDigimonWithOneEnergy ? 1 : quantity) >= 0;
    }

    return false;
  }

  void discountByColor(String color) {
    if (CardColor.RED == color) {
      red -= 1;
    }
    if (CardColor.GREEN == color) {
      green -= 1;
    }
    if (CardColor.BROWN == color) {
      brown -= 1;
    }
    if (CardColor.BLACK == color) {
      black -= 1;
    }
    if (CardColor.BLUE == color) {
      blue -= 1;
    }
    if (CardColor.WHITE == color) {
      white -= 1;
    }
  }

  void discountByColorAndQuantity(String color, int quantity) {
    if (CardColor.RED == color) {
      red -= enableSummonDigimonWithOneEnergy ? 1 : quantity;
    }
    if (CardColor.GREEN == color) {
      green -= enableSummonDigimonWithOneEnergy ? 1 : quantity;
    }
    if (CardColor.BROWN == color) {
      brown -= enableSummonDigimonWithOneEnergy ? 1 : quantity;
    }
    if (CardColor.BLACK == color) {
      black -= enableSummonDigimonWithOneEnergy ? 1 : quantity;
    }
    if (CardColor.BLUE == color) {
      blue -= enableSummonDigimonWithOneEnergy ? 1 : quantity;
    }
    if (CardColor.WHITE == color) {
      white -= enableSummonDigimonWithOneEnergy ? 1 : quantity;
    }
  }

  bool allEnergiesAreZeroOrMore() {
    return green >= 0 &&
        white >= 0 &&
        blue >= 0 &&
        red >= 0 &&
        brown >= 0 &&
        black >= 0;
  }

  void applyEffectByColor(String color, int value) {
    if (CardColor.RED == color) {
      red = (red + value) > 0 ? red + value : 0;
    }
    if (CardColor.GREEN == color) {
      green = (green + value) > 0 ? green + value : 0;
    }
    if (CardColor.BROWN == color) {
      brown = (brown + value) > 0 ? brown + value : 0;
    }
    if (CardColor.BLACK == color) {
      black = (black + value) > 0 ? black + value : 0;
    }
    if (CardColor.BLUE == color) {
      blue = (blue + value) > 0 ? blue + value : 0;
    }
    if (CardColor.WHITE == color) {
      white = (white + value) > 0 ? white + value : 0;
    }
  }
}
