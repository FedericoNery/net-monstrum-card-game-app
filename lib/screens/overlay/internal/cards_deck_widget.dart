import 'package:flame/effects.dart';
import 'package:net_monstrum_card_game/domain/card/card_energy.dart';
import 'package:net_monstrum_card_game/domain/card/card_summon_digimon.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/base_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/digimon_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/energy_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/equipment_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/cards/summon_digimon_card.dart';
import 'package:net_monstrum_card_game/widgets/card_battle/effects/effects.dart';

import '../../../domain/card/card_base.dart';
import '../../../domain/card/card_digimon.dart';
import '../../../domain/card/card_equipment.dart';
import '../../../domain/game/tamer.dart';

//TODO :: analizar de renombrar la clase

class CardsDeckWidgetFactory{
  late List<BaseCardComponent> cardsComponent = [];
  bool isRival;
  Tamer tamer;
  double position = 0;
  int counter = 0;

  CardsDeckWidgetFactory(this.tamer, this.isRival) {
    for (var card in tamer.deck.cards) {
      BaseCardComponent cardComponent = _getInstance(card, getXposition(), 150, true, true);
      cardsComponent.add(cardComponent);
      counter++;
    }
  }

  double getXposition(){
    double actualPosition = position;
    position += 15;
    return actualPosition;
  }

  BaseCardComponent _getInstance(Card card, double x, double y, bool isHidden, bool isRival){
    if (card.isDigimonCard()){
      return DigimonCardComponent(card as CardDigimon, x, y, isHidden, isRival);
    }

    if (card.isEquipmentCard()){
      return CardEquipmentWidget(card as CardEquipment, x, y, isHidden, isRival);
    }

    if (card.isSummonDigimonCard()){
      return SummonDigimonCardComponent(card as CardSummonDigimon, x, y, isHidden, isRival);
    }

    return EnergyCardComponent(card as CardEnergy, x, y, isHidden, isRival);
  }
}