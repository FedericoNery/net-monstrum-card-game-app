import 'dart:math';

class Card {
  int id;
  String digimonName;
  String color;
  int attackPoints;
  int hp;
  int evolutionId;
  int energyCount;

  Card(this.id, this.digimonName, this.color, this.attackPoints, this.hp, this.evolutionId, this.energyCount);

  String getDigimonImageFilename() {
    return '$digimonName.jpg';
  }
}

class CardsService {
  List<Card> deck = [];
  List<String> digimonNames = [
    'Agumon', 'Greymon', 'MetalGreymon', 'WarGreymon',
    'Gabumon', 'Garurumon', 'WereGarurumon', 'MetalGarurumon',
    'Veemon', 'ExVeemon', 'Paildramon', 'Imperialdramon',
    'Patamon', 'Angemon', 'MagnaAngemon', 'Seraphimon',
    'Gatomon', 'Angewomon', 'Magnadramon', 'Ophanimon',
    'Biyomon', 'Birdramon', 'Garudamon', 'Phoenixmon',
    'Tentomon', 'Kabuterimon', 'MegaKabuterimon', 'HerculesKabuterimon',
    'Palmon', 'Togemon', 'Lillymon', 'Rosemon',
    'Gomamon', 'Ikkakumon', 'Zudomon', 'Vikemon',
    'Elecmon', 'Leomon', 'IceLeomon', 'Saberdramon',
    'Renamon', 'Kyubimon', 'Taomon', 'Sakuyamon',
    'Terriermon', 'Gargomon', 'Rapidmon', 'MegaGargomon',
    'Guilmon', 'Growlmon', 'WarGrowlmon', 'Dukemon',
    'Impmon', 'Wizardmon', 'Mistymon', 'Dynasmon',
    'Palmon', 'Togemon', 'Lillymon', 'Rosemon',
    'Biyomon', 'Birdramon', 'Garudamon', 'Phoenixmon',
    'Kumamon', 'Grizzmon', 'Gigasmon', 'Hisyarumon',
    'Agunimon', 'BurningGreymon', 'Aldamon', 'KaiserGreymon',
    'Lobomon', 'KendoGarurumon', 'BeoWolfmon', 'Magnagarurumon',
  ];

  CardsService() {
    int cardId = 1;
    int evolutionId = 1;
    String currentColor = getRandomColor();

    for (int i = 0; i < digimonNames.length; i++) {
      if (i % 4 == 0 && i > 0) {
        currentColor = getRandomColor();
        evolutionId = 1;
      }

      int energy = (i % 4) + 1;

      int attackPoints = min(Random().nextInt(50) + 1, 50);
      int hp = min(Random().nextInt(50) + 1, 50);

      deck.add(Card(cardId, digimonNames[i], currentColor, attackPoints, hp, evolutionId, energy));

      cardId++;
      evolutionId++;
    }
  }

  Card getCardById(int cardId) {
    return deck.firstWhere((card) => card.id == cardId, orElse: () => null);
  }

  String getRandomColor() {
    List<String> colors = ['Red', 'Blue', 'Green', 'Yellow', 'Black', 'Brown'];
    return colors[Random().nextInt(colors.length)];
  }
}

