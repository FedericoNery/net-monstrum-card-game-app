import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Background extends SpriteComponent with HasGameRef {
  Background();
  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load("playmat/playmat.png");
    size = gameRef.size;
    sprite = Sprite(background);
  }
}