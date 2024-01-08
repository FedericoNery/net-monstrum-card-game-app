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
import 'components/victory_message.dart';
import 'package:flame_audio/flame_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame with HasGameRef {
  final background = Background();

  final enabledMusic = false;
  late AudioPool pool;
  late VictoryMessage victoryMessage;
  late CartaWidget card1;
  late CartaWidget card2;
  late CartaWidget card3;
  late CartaWidget card4;
  late CartaWidget card5;
  late CartaWidget card6;
  late CartaWidget card1Rival;
  late CartaWidget card2Rival;
  late CartaWidget card3Rival;
  late CartaWidget card4Rival;
  late CartaWidget card5Rival;
  late CartaWidget card6Rival;

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
  late Aggregation player;
  late Aggregation rival;

  late Tamer playerTamer;
  late Tamer rivalTamer;
  late BattleCardGame battleCardGame;
  late TextComponent apRival;
  late TextComponent hpRival;
  late TextComponent apPlayer;
  late TextComponent hpPlayer;

  late TextComponent roundsWinPlayer;
  late TextComponent roundsWinRival;
  late List<TextComponent> textsCounters;
  late List<TextComponent> textsCountersRival;

  MyGame();

  @override
  Future<void> onLoad() async {
    pool = await FlameAudio.createPool(
      'sounds/card-battle-theme.mp3',
      minPlayers: 2,
      maxPlayers: 2,
    );
    if (enabledMusic){
      startBgmMusic();
    }

    player = service.getAggregatioByUserId(1);
    rival = service.getAggregatioByUserId(2);

    playerTamer = Tamer(player.decksAggregations[0].cards, player.user.username);
    rivalTamer = Tamer(rival.decksAggregations[0].cards, rival.user.username);

    battleCardGame = BattleCardGame(playerTamer, rivalTamer);

    //TODO ANIMACION
    battleCardGame.shuffleDeck();

    //TODO ANIMACION
    battleCardGame.drawCards();
    victoryMessage = new VictoryMessage();

    this.setCardsWidgets();

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

    textsCounters = TextsCounters.getComponents(battleCardGame.player.energiesCounters);
    textsCountersRival = TextsCounters.getRivalComponents(battleCardGame.rival.energiesCounters);

    roundsWinPlayer = TextComponent(
      text: 'W:${this.battleCardGame.player.roundsWon}',
      size: Vector2.all(10.0),
      position: Vector2(0, 370),
    );

    roundsWinRival = TextComponent(
      text: 'W:${this.battleCardGame.rival.roundsWon}',
      size: Vector2.all(10.0),
      position: Vector2(0, 0),
    );

    apRival = TextComponent(
      text: 'AP:${this.battleCardGame.rival.attackPoints}',
      size: Vector2.all(10.0),
      position: Vector2(640, 0),
      scale: Vector2.all(0.8),
    );

    hpRival = TextComponent(
      text: 'HP:${this.battleCardGame.rival.healthPoints}',
      size: Vector2.all(10.0),
      position: Vector2(700, 0),
      scale: Vector2.all(0.8),
    );

    apPlayer = TextComponent(
      text: 'AP:${this.battleCardGame.player.attackPoints}',
      size: Vector2.all(10.0),
      position: Vector2(640, 370),
      scale: Vector2.all(0.8),
    );

    hpPlayer = TextComponent(
      text: 'HP:${this.battleCardGame.player.healthPoints}',
      size: Vector2.all(10.0),
      position: Vector2(700, 370),
      scale: Vector2.all(0.8),
    );

    defaultButton.position = Vector2(650, 50);
    defaultButton.size = Vector2(100, 50);
    defaultButton.tapUpCallback = this.nextPhase;
    defaultButton.onPressed = this.nextPhase;

    add(background);
    this.addCards();
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

    //this.revealPlayerCards();
  }


  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('sounds/card-battle-theme.mp3');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  void revealRivalCards() {
    this.card1Rival.reveal();
    this.card2Rival.reveal();
    this.card3Rival.reveal();
    this.card4Rival.reveal();
    this.card5Rival.reveal();
    this.card6Rival.reveal();
  }

  void updateApHp(){
    this.apRival.text = 'AP:${this.battleCardGame.rival.attackPoints}';
    this.hpRival.text = 'HP:${this.battleCardGame.rival.healthPoints}';
    this.apPlayer.text = 'AP:${this.battleCardGame.player.attackPoints}';
    this.hpPlayer.text = 'HP:${this.battleCardGame.player.healthPoints}';
    this.apRival.update(1);
    this.hpRival.update(1);
    this.apPlayer.update(1);
    this.hpPlayer.update(1);
  }

  void updateRounds(){
    this.roundsWinPlayer.text = 'W:${this.battleCardGame.player.roundsWon}';
    this.roundsWinRival.text = 'W:${this.battleCardGame.rival.roundsWon}';
    this.roundsWinPlayer.update(1);
    this.roundsWinRival.update(1);
  }

  void nextPhase() {
    //TODO :: borrar esto más adelante al seguir desarrollando
    this.battleCardGame.rival.selectAllDigimonThatCanBeSummoned();

    if (this.battleCardGame.digimonsCanBeSummoned()) {
      remove(this.defaultButton);

      this.battleCardGame.player.summonToDigimonZone();
      this.battleCardGame.rival.summonToDigimonZone();

      TextsCounters.updateComponents(textsCounters, this.battleCardGame.player.energiesCounters);
      TextsCounters.updateComponents(textsCountersRival, this.battleCardGame.rival.energiesCounters);

      this.battleCardGame.calculatePoints();

      this.removeNotSummonedCards();
      this.revealRivalCards();

      //this.update(1);
      this.updateApHp();
      //TODO Sleep de 2 segundos
      this.battlePhase();
    }
  }

  void battlePhase() async {
    this.battleCardGame.battle();
    //TODO SLEEP de 2 segundos
    await Future.delayed(Duration(seconds: 5));
    this.updateApHp();

    this.battleCardGame.calculateWinner();
    this.updateRounds();
    this.battleCardGame.finishRound();

    await Future.delayed(Duration(seconds: 5));

    if (this.battleCardGame.battleIsFinished()){
      //TODO Remover todos los elementos visuales
      this.removeAllCards();
      if(this.battleCardGame.isPlayerWinner()){
        victoryMessage.text = "Ganaste";
      }
      else{
        victoryMessage.text = "Perdiste";
      }
      add(victoryMessage);
    }
    else{
      this.updateApHp();
      this.battleCardGame.drawCards();
      //TODO llamar método para agregar devuelta los widgets de cartas
      this.removeAllCards();
      this.setCardsWidgets();
      this.addCards();
      TextsCounters.updateComponents(textsCounters, this.battleCardGame.player.energiesCounters);
      TextsCounters.updateComponents(textsCountersRival, this.battleCardGame.rival.energiesCounters);
      add(this.defaultButton);
    }
  }

  void setCardsWidgets(){
    const offsetX = 100.0;
    const offsetYPlayer = 250.0;
    const card1x = offsetX + 10;
    const card1y = offsetYPlayer;
    const card2x = offsetX + 100;
    const card2y = offsetYPlayer;
    const card3x = offsetX + 190;
    const card3y = offsetYPlayer;
    const card4x = offsetX + 280;
    const card4y = offsetYPlayer;
    const card5x = offsetX + 370;
    const card5y = offsetYPlayer;
    const card6x = offsetX + 450;
    const card6y = offsetYPlayer;

    card1 = CartaWidget(battleCardGame.player.hand.cards[0], card1x, card1y, false, this.addSelectedCard, 0, false);
    card2 = CartaWidget(battleCardGame.player.hand.cards[1], card2x, card2y, false, this.addSelectedCard, 1, false);
    card3 = CartaWidget(battleCardGame.player.hand.cards[2], card3x, card3y, false, this.addSelectedCard, 2, false);
    card4 = CartaWidget(battleCardGame.player.hand.cards[3], card4x, card4y, false, this.addSelectedCard, 3, false);
    card5 = CartaWidget(battleCardGame.player.hand.cards[4], card5x, card5y, false, this.addSelectedCard, 4, false);
    card6 = CartaWidget(battleCardGame.player.hand.cards[5], card6x, card6y, false, this.addSelectedCard, 5, false);

    const offsetYCards = 25.0;
    const card1Rivalx = offsetX + 10;
    const card1Rivaly = offsetYCards;
    const card2Rivalx = offsetX + 100;
    const card2Rivaly = offsetYCards;
    const card3Rivalx = offsetX + 190;
    const card3Rivaly = offsetYCards;
    const card4Rivalx = offsetX + 280;
    const card4Rivaly = offsetYCards;
    const card5Rivalx = offsetX + 370;
    const card5Rivaly = offsetYCards;
    const card6Rivalx = offsetX + 450;
    const card6Rivaly = offsetYCards;

    card1Rival = CartaWidget(battleCardGame.rival.hand.cards[0], card1Rivalx, card1Rivaly, true, this.addSelectedCard, 0, true);
    card2Rival = CartaWidget(battleCardGame.rival.hand.cards[1], card2Rivalx, card2Rivaly, true, this.addSelectedCard, 1, true);
    card3Rival = CartaWidget(battleCardGame.rival.hand.cards[2], card3Rivalx, card3Rivaly, true, this.addSelectedCard, 2, true);
    card4Rival = CartaWidget(battleCardGame.rival.hand.cards[3], card4Rivalx, card4Rivaly, true, this.addSelectedCard, 3, true);
    card5Rival = CartaWidget(battleCardGame.rival.hand.cards[4], card5Rivalx, card5Rivaly, true, this.addSelectedCard, 4, true);
    card6Rival = CartaWidget(battleCardGame.rival.hand.cards[5], card6Rivalx, card6Rivaly, true, this.addSelectedCard, 5, true);
  }

  void revealPlayerCards(){
    this.card1.isHidden = true;
    this.card2.isHidden = true;
    this.card3.isHidden = true;
    this.card4.isHidden = true;
    this.card5.isHidden = true;
    this.card6.isHidden = true;
  }

  void addCards() async{
    add(card1);
    add(card2);
    add(card3);
    add(card4);
    add(card5);
    add(card6);
    add(card1Rival);
    add(card2Rival);
    add(card3Rival);
    add(card4Rival);
    add(card5Rival);
    add(card6Rival);
  }

  void updateCards(){
    card1.update(1);
    card2.update(1);
    card3.update(1);
    card4.update(1);
    card5.update(1);
    card6.update(1);
    card1Rival.update(1);
    card2Rival.update(1);
    card3Rival.update(1);
    card4Rival.update(1);
    card5Rival.update(1);
    card6Rival.update(1);
  }

  void removeAllCards(){
    if (this.card1.isMounted){
      this.remove(this.card1);
    }
    if (this.card2.isMounted){
      this.remove(this.card2);
    }
    if (this.card3.isMounted){
      this.remove(this.card3);
    }
    if (this.card4.isMounted){
      this.remove(this.card4);
    }
    if (this.card5.isMounted){
      this.remove(this.card5);
    }
    if (this.card6.isMounted){
      this.remove(this.card6);
    }
    if (this.card1Rival.isMounted){
      this.remove(this.card1Rival);
    }
    if (this.card2Rival.isMounted){
      this.remove(this.card2Rival);
    }
    if (this.card3Rival.isMounted){
      this.remove(this.card3Rival);
    }
    if (this.card4Rival.isMounted){
      this.remove(this.card4Rival);
    }
    if (this.card5Rival.isMounted){
      this.remove(this.card5Rival);
    }
    if (this.card6Rival.isMounted){
      this.remove(this.card6Rival);
    }
  }

  void removeNotSummonedCards(){
    if (!this.battleCardGame.player.hand.selectedCardsIndexs.contains(0)){
      this.card1.removeFromParent();
    }

    if (!this.battleCardGame.player.hand.selectedCardsIndexs.contains(1)){
      this.card2.removeFromParent();
    }

    if (!this.battleCardGame.player.hand.selectedCardsIndexs.contains(2)){
      this.card3.removeFromParent();
    }

    if (!this.battleCardGame.player.hand.selectedCardsIndexs.contains(3)){
      this.card4.removeFromParent();
    }

    if (!this.battleCardGame.player.hand.selectedCardsIndexs.contains(4)){
      this.card5.removeFromParent();
    }

    if (!this.battleCardGame.player.hand.selectedCardsIndexs.contains(5)){
      this.card6.removeFromParent();
    }

    if (!this.battleCardGame.rival.hand.selectedCardsIndexs.contains(0)){
      this.card1Rival.removeFromParent();
    }

    if (!this.battleCardGame.rival.hand.selectedCardsIndexs.contains(1)){
      this.card2Rival.removeFromParent();
    }

    if (!this.battleCardGame.rival.hand.selectedCardsIndexs.contains(2)){
      this.card3Rival.removeFromParent();
    }

    if (!this.battleCardGame.rival.hand.selectedCardsIndexs.contains(3)){
      this.card4Rival.removeFromParent();
    }

    if (!this.battleCardGame.rival.hand.selectedCardsIndexs.contains(4)){
      this.card5Rival.removeFromParent();
    }

    if (!this.battleCardGame.rival.hand.selectedCardsIndexs.contains(5)){
      this.card6Rival.removeFromParent();
    }

  }

  void addSelectedCard(int index) {
    this.battleCardGame.player.hand.selectCardByIndex(index);
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
