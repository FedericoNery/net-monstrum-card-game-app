import 'dart:ui';

import '../../screens/singleplayer/rounded_rectangle_component.dart';

class LeftSideSectionRival {
  late RectanguloRedondeadoComponent firstLayer;
  late RectanguloRedondeadoComponent secondLayer;
  late RectanguloRedondeadoComponent thirdLayer;
  LeftSideSectionRival() {
    firstLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(123, 24, 42, 1),
        top: 0,
        left: 0,
        width: 100,
        height: 200,
        borderRadius: 0);

    secondLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(132, 74, 82, 1),
        top: 105,
        left: 0,
        width: 90,
        height: 90,
        borderRadius: 4);

    thirdLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(189, 140, 148, 1),
        top: 110,
        left: 0,
        width: 85,
        height: 80,
        borderRadius: 4);
  }
}

class LeftSideSectionPlayer {
  late RectanguloRedondeadoComponent firstLayer;
  late RectanguloRedondeadoComponent secondLayer;
  late RectanguloRedondeadoComponent thirdLayer;
  LeftSideSectionPlayer() {
    firstLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(24, 49, 123, 1),
        top: 200,
        left: 0,
        width: 100,
        height: 200,
        borderRadius: 0);

    secondLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(74, 90, 132, 1),
        top: 205,
        left: 0,
        width: 90,
        height: 90,
        borderRadius: 4);

    thirdLayer = RectanguloRedondeadoComponent(
        color: const Color.fromRGBO(142, 157, 190, 1),
        top: 210,
        left: 0,
        width: 85,
        height: 80,
        borderRadius: 4);
  }
}
