import 'package:flame/components.dart';
import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';
import 'package:net_monstrum_card_game/screens/counters_measures.dart';

class TextsCounters {
    static List<TextComponent> getRivalComponents(EnergiesCounters energiesCounters) {
    const double offsetNumbersX = 25;
    const double offsetNumbersY = -4;

    final blueCounterText = TextComponent(
    text: '${energiesCounters.blue}',
    size: Vector2.all(10.0),
    position: Vector2(CountersMeasures.BLUE_RIVAL_X + offsetNumbersX, CountersMeasures.BLUE_RIVAL_Y + offsetNumbersY),
    );

    final redCounterText = TextComponent(
      text: '${energiesCounters.red}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.RED_RIVAL_X + offsetNumbersX, CountersMeasures.RED_RIVAL_Y + offsetNumbersY),
    );
    
    final brownCounterText = TextComponent(
      text: '${energiesCounters.brown}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BROWN_RIVAL_X + offsetNumbersX, CountersMeasures.BROWN_RIVAL_Y + offsetNumbersY),
    );
    
    final whiteCounterText = TextComponent(
      text: '${energiesCounters.white}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.WHITE_RIVAL_X + offsetNumbersX, CountersMeasures.WHITE_RIVAL_Y + offsetNumbersY),
    );
    
    final blackCounterText = TextComponent(
      text: '${energiesCounters.black}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLACK_RIVAL_X + offsetNumbersX, CountersMeasures.BLACK_RIVAL_Y + offsetNumbersY),
    );
    
    final greenCounterText = TextComponent(
      text: '${energiesCounters.green}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.GREEN_RIVAL_X + offsetNumbersX, CountersMeasures.GREEN_RIVAL_Y + offsetNumbersY),
    );

    return [blueCounterText, redCounterText, brownCounterText, whiteCounterText, blackCounterText, greenCounterText];  
  }

    static List<TextComponent> getComponents(EnergiesCounters energiesCounters) {
      const double offsetNumbersX = 25;
      const double offsetNumbersY = -4;

      final blueCounterText = TextComponent(
      text: '${energiesCounters.blue}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLUE_X + offsetNumbersX, CountersMeasures.BLUE_Y + offsetNumbersY),
      );

      final redCounterText = TextComponent(
        text: '${energiesCounters.red}',
        size: Vector2.all(10.0),
        position: Vector2(CountersMeasures.RED_X + offsetNumbersX, CountersMeasures.RED_Y + offsetNumbersY),
      );

      final brownCounterText = TextComponent(
        text: '${energiesCounters.brown}',
        size: Vector2.all(10.0),
        position: Vector2(CountersMeasures.BROWN_X + offsetNumbersX, CountersMeasures.BROWN_Y + offsetNumbersY),
      );

      final whiteCounterText = TextComponent(
        text: '${energiesCounters.white}',
        size: Vector2.all(10.0),
        position: Vector2(CountersMeasures.WHITE_X + offsetNumbersX, CountersMeasures.WHITE_Y + offsetNumbersY),
      );

      final blackCounterText = TextComponent(
        text: '${energiesCounters.black}',
        size: Vector2.all(10.0),
        position: Vector2(CountersMeasures.BLACK_X + offsetNumbersX, CountersMeasures.BLACK_Y + offsetNumbersY),
      );

      final greenCounterText = TextComponent(
        text: '${energiesCounters.green}',
        size: Vector2.all(10.0),
        position: Vector2(CountersMeasures.GREEN_X + offsetNumbersX, CountersMeasures.GREEN_Y + offsetNumbersY),
      );

      return [blueCounterText, redCounterText, brownCounterText, whiteCounterText, blackCounterText, greenCounterText];
    }

    static void updateComponents(List<TextComponent> texts, EnergiesCounters energiesCounters){
      texts[0].text = '${energiesCounters.blue}';
      texts[1].text = '${energiesCounters.red}';
      texts[2].text = '${energiesCounters.brown}';
      texts[3].text = '${energiesCounters.white}';
      texts[4].text = '${energiesCounters.black}';
      texts[5].text = '${energiesCounters.green}';

      texts[0].update(1);
      texts[1].update(1);
      texts[2].update(1);
      texts[3].update(1);
      texts[4].update(1);
      texts[5].update(1);
    }
}