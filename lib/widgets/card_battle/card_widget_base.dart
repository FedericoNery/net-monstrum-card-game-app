import 'package:flame/components.dart';
import 'package:flame/effects.dart';

abstract class CardWidget extends SpriteComponent {
  bool isHidden = false;
  double x = 0;
  double y = 0;
  bool isSelected = false;
  bool isRival = false;
  Function callbackSelectCardFromHand = () => {};
  Function isEnabledToSelectCard = () => {};
  int internalCardId = 0;

  CardWidget({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  void reveal();

  void deselectCardEffect(){
    if(isSelected){
      isSelected = false;
      children.first.add(RemoveEffect(delay: 0.1));
    }
  }
}