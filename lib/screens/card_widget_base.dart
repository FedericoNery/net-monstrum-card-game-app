import 'package:flame/components.dart';

abstract class CardWidget extends SpriteComponent {
  bool isHidden = false;
  double x = 0;
  double y = 0;
  bool isSelected = false;
  bool isRival = false;
  Function callbackSelectCardFromHand = () => {};
  int indexCard = 0;

  CardWidget({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  void reveal();
}