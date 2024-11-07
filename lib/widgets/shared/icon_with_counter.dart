import 'dart:typed_data';

import 'package:flame/components.dart' as flameComponents;
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
/* class IconWithCounter extends PositionComponent {
  int cantidad;
  final double x;
  final double y;
  final Color backgroundColor;

  IconWithCounter({
    required this.cantidad,
    required this.x,
    required this.y,
    this.backgroundColor = const Color(0xFF333333),
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this.position = Vector2(x, y);

    final Paint textBackgroundPaint = Paint()..color = backgroundColor;
    final RRect textBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(26.0, 0, 36.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(textBackgroundRect, textBackgroundPaint);

    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
    textPaint.render(canvas, '$cantidad', Vector2(30, 4));
  }
}

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart'; */

class IconWithCounter extends flameComponents.PositionComponent {
  int cantidad;
  final double x;
  final double y;
  final Color backgroundColor;
  final String imageUrl; // Imagen a mostrar
  late ui.Image image;

  IconWithCounter({
    required this.cantidad,
    required this.x,
    required this.y,
    required this.imageUrl,
    this.backgroundColor = const Color(0xFF333333),
  });

  @override
  Future<void> onLoad() async {
/*     // Cargar la imagen desde los assets
    final ByteData data = await rootBundle.load(imageUrl);
    final List<int> bytes = data.buffer.asUint8List();
    image = await decodeImageFromList(Uint8List.fromList(bytes));
    await image.resize(Vector2(1, 1)); */
    // Cargar la imagen desde los assets
    final ByteData data = await rootBundle.load(imageUrl);
    final List<int> bytes = data.buffer.asUint8List();
    image = await decodeImageFromList(Uint8List.fromList(bytes));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    this.position = flameComponents.Vector2(x, y);

    // Dimensiones del fondo y posición de la imagen según `imagePosition`
    final double imageSize = 48.0; // Tamaño de la imagen
    final double heightImageSize = 32.0; // Tamaño de la imagen
    flameComponents.Vector2 imagePositionOffset;

    RRect imageBackgroundRect;

    imagePositionOffset =
        flameComponents.Vector2(50, 0); // A la izquierda del texto
    imageBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-10, -2.5, imageSize, heightImageSize + 5),
      Radius.circular(5.0),
    );

    // Fondo para el contador
    final Paint textBackgroundPaint = Paint()..color = backgroundColor;
    final textBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(30.0, -2, 36.0, 22.0),
      Radius.circular(5.0),
    );
    canvas.drawRRect(textBackgroundRect, textBackgroundPaint);

    // Texto del contador
    final flameComponents.TextPaint textPaint = flameComponents.TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
    flameComponents.Vector2 textPositionOffset =
        flameComponents.Vector2(48, 3); // Posición del texto dentro del fondo
    textPaint.render(canvas, '$cantidad', textPositionOffset);

    // Dibujar fondo para la imagen
    canvas.drawRRect(imageBackgroundRect, textBackgroundPaint);

    drawOnCanvas(canvas);
  }

  drawOnCanvas(Canvas canvas) {
    // Dibujar la imagen en el canvas
    // Definir el tamaño de la nueva imagen (escala)
    final double scaleWidth = 30.0; // Ancho deseado
    final double scaleHeight = 30.0; // Alto deseado

    // Escalar la imagen para que encaje en la pantalla
    final Rect srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dstRect = Rect.fromLTWH(
        0, 0, scaleWidth, scaleHeight); // Posicionamiento y tamaño final

    // Dibujar la imagen escalada en el canvas
    final Paint paint = Paint();
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }
}
