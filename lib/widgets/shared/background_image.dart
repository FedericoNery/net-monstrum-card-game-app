import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BackgroundImage extends SpriteComponent with HasGameRef {
  String imageUri;

  BackgroundImage(this.imageUri);

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(imageUri);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}