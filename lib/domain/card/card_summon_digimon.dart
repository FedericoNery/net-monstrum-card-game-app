import 'package:net_monstrum_card_game/domain/card/card_base.dart';
import 'package:net_monstrum_card_game/domain/card/card_digimon.dart';

class CardSummonDigimon extends Card{
  String name;
  List<CardDigimon> digimonsCards = [];

  CardSummonDigimon(id, this.name, this.digimonsCards):  super(id);

  CardSummonDigimon copyWith({int? id, String? name, int? attackPoints, int? healthPoints, int? quantityOfTargets, String? targetScope}){
    return CardSummonDigimon(
      id ?? this.id,
      name ?? this.name,
      digimonsCards ?? this.digimonsCards,
    );
  }
}