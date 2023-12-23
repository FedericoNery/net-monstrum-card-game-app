import 'package:flame/components.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
import 'package:net_monstrum_card_game/screens/counters_measures.dart';

class TextsCounters {
  static List<TextComponent> getComponents(EnergiesCounters energiesCounters) {
    const double offsetNumbersX = 25;
    const double offsetNumbersY = -4;

    final blueCounterText = TextComponent(
    text: '100',
    size: Vector2.all(10.0),
    position: Vector2(CountersMeasures.BLUE_X + offsetNumbersX, CountersMeasures.BLUE_Y + offsetNumbersY),
    );

    final redCounterText = TextComponent(
      text: '100',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.RED_X + offsetNumbersX, CountersMeasures.RED_Y + offsetNumbersY),
    );
    
    final brownCounterText = TextComponent(
      text: '100',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BROWN_X + offsetNumbersX, CountersMeasures.BROWN_Y + offsetNumbersY),
    );
    
    final whiteCounterText = TextComponent(
      text: '100',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.WHITE_X + offsetNumbersX, CountersMeasures.WHITE_Y + offsetNumbersY),
    );
    
    final blackCounterText = TextComponent(
      text: '100',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLACK_X + offsetNumbersX, CountersMeasures.BLACK_Y + offsetNumbersY),
    );
    
    final greenCounterText = TextComponent(
      text: '100',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.GREEN_X + offsetNumbersX, CountersMeasures.GREEN_Y + offsetNumbersY),
    );

    return [blueCounterText, redCounterText, brownCounterText, whiteCounterText, blackCounterText, greenCounterText];  
  }
}