import 'package:flame/components.dart';
import 'package:net_monstrum_card_game/domain/game.dart';

class ApHPInstances {
  late TextComponent apRival;
  late TextComponent hpRival;
  late TextComponent apPlayer;
  late TextComponent hpPlayer;

  ApHPInstances() {
    apRival = TextComponent(
      text: 'AP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(640, 0),
      scale: Vector2.all(0.8),
    );

    hpRival = TextComponent(
      text: 'HP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(700, 0),
      scale: Vector2.all(0.8),
    );

    apPlayer = TextComponent(
      text: 'AP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(640, 370),
      scale: Vector2.all(0.8),
    );

    hpPlayer = TextComponent(
      text: 'HP:${0}',
      size: Vector2.all(10.0),
      position: Vector2(700, 370),
      scale: Vector2.all(0.8),
    );
  }

  updateValues(BattleCardGame battleCardGame) {
    apRival.text = 'AP:${battleCardGame.rival.attackPoints}';
    hpRival.text = 'HP:${battleCardGame.rival.healthPoints}';
    apPlayer.text = 'AP:${battleCardGame.player.attackPoints}';
    hpPlayer.text = 'HP:${battleCardGame.player.healthPoints}';
  }
}
