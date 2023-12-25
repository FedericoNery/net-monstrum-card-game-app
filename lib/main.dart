import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:net_monstrum_card_game/domain/game.dart';
import 'package:net_monstrum_card_game/domain/game/tamer.dart';
import 'package:net_monstrum_card_game/screens/background_battle.dart';
import 'package:net_monstrum_card_game/screens/color_counter.dart';
import 'package:net_monstrum_card_game/screens/counters_measures.dart';
import 'package:net_monstrum_card_game/screens/digimon_card.dart';
import 'package:net_monstrum_card_game/screens/texts_counters_player.dart';
import 'package:net_monstrum_card_game/services/aggregationService.dart';
import 'package:net_monstrum_card_game/widgets/button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame with HasGameRef {
  MyGame();
  final background = Background();
  ImageCardExample? card1;
  ImageCardExample? card2;
  ImageCardExample? card3;
  ImageCardExample? card4;
  ImageCardExample? card5;
  ImageCardExample? card6;

  ImageCardExample? card1Rival;
  ImageCardExample? card2Rival;
  ImageCardExample? card3Rival;
  ImageCardExample? card4Rival;
  ImageCardExample? card5Rival;
  ImageCardExample? card6Rival;

  final blueCounter = ColorCounter(Colors.blueAccent);
  final redCounter = ColorCounter(Colors.red);
  final brownCounter = ColorCounter(Colors.brown);
  final whiteCounter = ColorCounter(Colors.white);
  final blackCounter = ColorCounter(Colors.black);
  final greenCounter = ColorCounter(Colors.green);

  final blueCounterRival = ColorCounter(Colors.blueAccent);
  final redCounterRival = ColorCounter(Colors.red);
  final brownCounterRival = ColorCounter(Colors.brown);
  final whiteCounterRival = ColorCounter(Colors.white);
  final blackCounterRival = ColorCounter(Colors.black);
  final greenCounterRival = ColorCounter(Colors.green);
  final defaultButton = DefaultButton();

  final service = AggregationService();

  @override
  Future<void> onLoad() async {
    Aggregation player = service.getAggregatioByUserId(1);
    Aggregation rival = service.getAggregatioByUserId(2);

    Tamer playerTamer = Tamer(player.decksAggregations[0].cards, player.user.username);
    Tamer rivalTamer = Tamer(rival.decksAggregations[0].cards, rival.user.username);
    BattleCardGame game = BattleCardGame(playerTamer, rivalTamer);

    card1 = ImageCardExample(player.decksAggregations[0].cards[0].digimonName, player.decksAggregations[0].cards[0].color);
    card2 = ImageCardExample(player.decksAggregations[0].cards[1].digimonName, player.decksAggregations[0].cards[1].color);
    card3 = ImageCardExample(player.decksAggregations[0].cards[2].digimonName, player.decksAggregations[0].cards[2].color);
    card4 = ImageCardExample(player.decksAggregations[0].cards[3].digimonName, player.decksAggregations[0].cards[3].color);
    card5 = ImageCardExample(player.decksAggregations[0].cards[4].digimonName, player.decksAggregations[0].cards[4].color);
    card6 = ImageCardExample(player.decksAggregations[0].cards[5].digimonName, player.decksAggregations[0].cards[5].color);

    card1Rival = ImageCardExample(rival.decksAggregations[0].cards[0].digimonName, player.decksAggregations[0].cards[0].color);
    card2Rival = ImageCardExample(rival.decksAggregations[0].cards[1].digimonName, player.decksAggregations[0].cards[1].color);
    card3Rival = ImageCardExample(rival.decksAggregations[0].cards[2].digimonName, player.decksAggregations[0].cards[2].color);
    card4Rival = ImageCardExample(rival.decksAggregations[0].cards[3].digimonName, player.decksAggregations[0].cards[3].color);
    card5Rival = ImageCardExample(rival.decksAggregations[0].cards[4].digimonName, player.decksAggregations[0].cards[4].color);
    card6Rival = ImageCardExample(rival.decksAggregations[0].cards[5].digimonName, player.decksAggregations[0].cards[5].color);

    blueCounter.x = CountersMeasures.BLUE_X;
    blueCounter.y = CountersMeasures.BLUE_Y;
    redCounter.x = CountersMeasures.RED_X;
    redCounter.y = CountersMeasures.RED_Y;
    brownCounter.x = CountersMeasures.BROWN_X;
    brownCounter.y = CountersMeasures.BROWN_Y;
    whiteCounter.x = CountersMeasures.WHITE_X;
    whiteCounter.y = CountersMeasures.WHITE_Y;
    blackCounter.x = CountersMeasures.BLACK_X;
    blackCounter.y = CountersMeasures.BLACK_Y;
    greenCounter.x = CountersMeasures.GREEN_X;
    greenCounter.y = CountersMeasures.GREEN_Y;

    blueCounterRival.x = CountersMeasures.BLUE_RIVAL_X;
    blueCounterRival.y = CountersMeasures.BLUE_RIVAL_Y;
    redCounterRival.x = CountersMeasures.RED_RIVAL_X;
    redCounterRival.y = CountersMeasures.RED_RIVAL_Y;
    brownCounterRival.x = CountersMeasures.BROWN_RIVAL_X;
    brownCounterRival.y = CountersMeasures.BROWN_RIVAL_Y;
    whiteCounterRival.x = CountersMeasures.WHITE_RIVAL_X;
    whiteCounterRival.y = CountersMeasures.WHITE_RIVAL_Y;
    blackCounterRival.x = CountersMeasures.BLACK_RIVAL_X;
    blackCounterRival.y = CountersMeasures.BLACK_RIVAL_Y;
    greenCounterRival.x = CountersMeasures.GREEN_RIVAL_X;
    greenCounterRival.y = CountersMeasures.GREEN_RIVAL_Y;

    List<TextComponent> textsCounters = TextsCounters.getComponents(game.player.energiesCounters);
    List<TextComponent> textsCountersRival = TextsCounters.getRivalComponents(game.rival.energiesCounters);
    
    const offsetX = 100.0;
    card1?.x = offsetX + 10;
    card1?.y = 300;
    card2?.x = offsetX + 100;
    card2?.y = 300;
    card3?.x = offsetX + 190;
    card3?.y = 300;
    card4?.x = offsetX + 280;
    card4?.y = 300;
    card5?.x = offsetX + 370;
    card5?.y = 300;
    card6?.x = offsetX + 450;
    card6?.y = 300;

    const offsetYCards = 25.0;
    card1Rival?.x = offsetX + 10;
    card1Rival?.y = offsetYCards;
    card2Rival?.x = offsetX + 100;
    card2Rival?.y = offsetYCards;
    card3Rival?.x = offsetX + 190;
    card3Rival?.y = offsetYCards;
    card4Rival?.x = offsetX + 280;
    card4Rival?.y = offsetYCards;
    card5Rival?.x = offsetX + 370;
    card5Rival?.y = offsetYCards;
    card6Rival?.x = offsetX + 450;
    card6Rival?.y = offsetYCards;

    final roundsWinPlayer = TextComponent(
    text: 'W:0',
    size: Vector2.all(10.0),
    position: Vector2(0, 370),
    );

    final roundsWinRival = TextComponent(
    text: 'W:0',
    size: Vector2.all(10.0),
    position: Vector2(0, 0),
    );

    final apRival = TextComponent(
    text: 'AP:0',
    size: Vector2.all(10.0),
    position: Vector2(700, 0),
    );

    final hpRival = TextComponent(
    text: 'HP:0',
    size: Vector2.all(10.0),
    position: Vector2(750, 0),
    );

    final apPlayer = TextComponent(
    text: 'AP:0',
    size: Vector2.all(10.0),
    position: Vector2(700, 370),
    );

    final hpPlayer = TextComponent(
    text: 'HP:0',
    size: Vector2.all(10.0),
    position: Vector2(750, 370),
    );

    defaultButton.position = Vector2(650, 50);
    defaultButton.size = Vector2(100, 50);
    defaultButton.tapUpCallback = this.nextPhase;
    defaultButton.onPressed = this.nextPhase;

    print("SISI");
    print(defaultButton.tapUpCallback);

    add(background);
    add(card1 as Component);
    add(card2 as Component);
    add(card3 as Component);
    add(card4 as Component);
    add(card5 as Component);
    add(card6 as Component);
    add(card1Rival as Component);
    add(card2Rival as Component);
    add(card3Rival as Component);
    add(card4Rival as Component);
    add(card5Rival as Component);
    add(card6Rival as Component);
    add(blueCounter);
    add(redCounter);
    add(brownCounter);
    add(whiteCounter);
    add(blackCounter);
    add(greenCounter);
    add(blueCounterRival);
    add(redCounterRival);
    add(brownCounterRival);
    add(whiteCounterRival);
    add(blackCounterRival);
    add(greenCounterRival);
    add(roundsWinPlayer);
    add(roundsWinRival);
    add(apRival);
    add(hpRival);
    add(apPlayer);
    add(hpPlayer);

    for (var textCounterComponent in textsCounters) {
      add(textCounterComponent);
    }
    
    for (var textCounterComponent in textsCountersRival) {
      add(textCounterComponent);
    }
    add(defaultButton);
    
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Aquí se renderizarán los componentes adicionales si los tienes
  }

  void nextPhase(){
    print("LLEGO AL METHOD");
    remove(this.defaultButton);
    this.update(1);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
