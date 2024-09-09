import 'package:flame/components.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

import 'counters_measures.dart';

class TextsCounters {
  static double offsetNumbersXRival = 25;
  static double offsetNumbersYRival = -4;

  static double offsetNumbersX = 25;
  static double offsetNumbersY = -4;

  late TextComponent blueCounterTextRival;
  late TextComponent redCounterTextRival;
  //late TextAnimation redCounterTextRival;
  late TextComponent brownCounterTextRival;
  late TextComponent whiteCounterTextRival;
  late TextComponent blackCounterTextRival;
  late TextComponent greenCounterTextRival;

  late TextComponent blueCounterText;
  late TextComponent redCounterText;
  late TextComponent brownCounterText;
  late TextComponent whiteCounterText;
  late TextComponent blackCounterText;
  late TextComponent greenCounterText;

  TextsCounters() {
    blueCounterTextRival = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLUE_RIVAL_X + offsetNumbersXRival,
          CountersMeasures.BLUE_RIVAL_Y + offsetNumbersYRival),
    );

    redCounterTextRival = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.RED_RIVAL_X + offsetNumbersXRival,
          CountersMeasures.RED_RIVAL_Y + offsetNumbersYRival),
    );

/*     redCounterTextRival = TextAnimation(initialValue: 0, targetValue: 0, duration: Duration(seconds: 3));
 */
    brownCounterTextRival = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BROWN_RIVAL_X + offsetNumbersXRival,
          CountersMeasures.BROWN_RIVAL_Y + offsetNumbersYRival),
    );

    whiteCounterTextRival = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.WHITE_RIVAL_X + offsetNumbersXRival,
          CountersMeasures.WHITE_RIVAL_Y + offsetNumbersYRival),
    );
    blackCounterTextRival = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLACK_RIVAL_X + offsetNumbersXRival,
          CountersMeasures.BLACK_RIVAL_Y + offsetNumbersYRival),
    );
    greenCounterTextRival = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.GREEN_RIVAL_X + offsetNumbersXRival,
          CountersMeasures.GREEN_RIVAL_Y + offsetNumbersYRival),
    );

    blueCounterText = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLUE_X + offsetNumbersX,
          CountersMeasures.BLUE_Y + offsetNumbersY),
    );
    redCounterText = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.RED_X + offsetNumbersX,
          CountersMeasures.RED_Y + offsetNumbersY),
    );
    brownCounterText = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BROWN_X + offsetNumbersX,
          CountersMeasures.BROWN_Y + offsetNumbersY),
    );
    whiteCounterText = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.WHITE_X + offsetNumbersX,
          CountersMeasures.WHITE_Y + offsetNumbersY),
    );
    blackCounterText = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.BLACK_X + offsetNumbersX,
          CountersMeasures.BLACK_Y + offsetNumbersY),
    );
    greenCounterText = TextComponent(
      text: '${0}',
      size: Vector2.all(10.0),
      position: Vector2(CountersMeasures.GREEN_X + offsetNumbersX,
          CountersMeasures.GREEN_Y + offsetNumbersY),
    );
  }

  updateValues(BattleCardGame battleCardGame) {
    blackCounterText.text = '${battleCardGame.player.energiesCounters.black}';
    blueCounterText.text = '${battleCardGame.player.energiesCounters.blue}';
    brownCounterText.text = '${battleCardGame.player.energiesCounters.brown}';
    greenCounterText.text = '${battleCardGame.player.energiesCounters.green}';
    redCounterText.text = '${battleCardGame.player.energiesCounters.red}';
    whiteCounterText.text = '${battleCardGame.player.energiesCounters.white}';

    blackCounterTextRival.text =
        '${battleCardGame.rival.energiesCounters.black}';
    blueCounterTextRival.text = '${battleCardGame.rival.energiesCounters.blue}';
    brownCounterTextRival.text =
        '${battleCardGame.rival.energiesCounters.brown}';
    greenCounterTextRival.text =
        '${battleCardGame.rival.energiesCounters.green}';
    redCounterTextRival.text = '${battleCardGame.rival.energiesCounters.red}';
    whiteCounterTextRival.text =
        '${battleCardGame.rival.energiesCounters.white}';
  }
/* 
  static void updateComponents(
      List<TextComponent> texts, EnergiesCounters energiesCounters) {
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
  } */
}
