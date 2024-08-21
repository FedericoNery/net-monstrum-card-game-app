import 'package:net_monstrum_card_game/domain/game/energies_counters.dart';

class EnergiesAdapter {
  static EnergiesCounters getEnergiesFromSocketInfo(
      Map<String, dynamic> energiesFromSocket) {
    return EnergiesCounters(
        energiesFromSocket["red"]!,
        energiesFromSocket["blue"]!,
        energiesFromSocket["brown"]!,
        energiesFromSocket["black"]!,
        energiesFromSocket["green"]!,
        energiesFromSocket["white"]!);
  }
}
