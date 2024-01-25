import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BackgroundImage extends SpriteComponent with HasGameRef {
  String imageUri;

  BackgroundImage(this.imageUri);
  double originalSizeX = 807.2727272727273;
  double originalSizeY = 392.72727272727275;

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(imageUri);
    size = Vector2(originalSizeX, originalSizeY);
    sprite = Sprite(background);
  }
}