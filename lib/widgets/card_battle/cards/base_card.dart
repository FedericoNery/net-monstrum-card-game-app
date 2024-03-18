import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:net_monstrum_card_game/domain/card/card_base.dart';

abstract class BaseCardComponent extends SpriteComponent {
  bool isHidden = false;
  double x = 0;
  double y = 0;
  bool isSelected = false;
  bool isRival = false;
  Card? card;

  BaseCardComponent({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  void reveal();
  int getUniqueCardId();

  void deselectCardEffect(){
    if(isSelected){
      isSelected = false;
      children.first.add(RemoveEffect(delay: 0.1));
      update(1);
    }
  }
}