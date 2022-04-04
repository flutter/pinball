import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BasicLayerGame extends BasicGame with TapDetector {
  BasicLayerGame({required this.color});

  static const info = '''
      Basic example of how layers work when a Ball hits other components.
      
      Tap anywhere on the screen to spawn a ball into the game.
''';

  final Color color;

  @override
  Future<void> onLoad() async {
    await add(BigSquare()..initialPosition = Vector2(30, -40));
    await add(SmallSquare()..initialPosition = Vector2(50, -40));
    await add(UnlayeredSquare()..initialPosition = Vector2(60, -40));
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball(baseColor: color)..initialPosition = info.eventPosition.game,
    );
  }
}

class BigSquare extends BodyComponent with InitialPosition, Layered {
  BigSquare() {
    paint = Paint()
      ..color = const Color.fromARGB(255, 8, 218, 241)
      ..style = PaintingStyle.stroke;
    layer = Layer.spaceshipEntranceRamp;
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(16, 16);
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await addAll(
      [
        UnlayeredSquare()..initialPosition = Vector2.all(4),
        SmallSquare()..initialPosition = Vector2.all(-4),
      ],
    );
  }
}

class SmallSquare extends BodyComponent with InitialPosition, Layered {
  SmallSquare() {
    paint = Paint()
      ..color = const Color.fromARGB(255, 27, 241, 8)
      ..style = PaintingStyle.stroke;
    layer = Layer.board;
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(2, 2);
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class UnlayeredSquare extends BodyComponent with InitialPosition {
  UnlayeredSquare() {
    paint = Paint()
      ..color = const Color.fromARGB(255, 241, 8, 8)
      ..style = PaintingStyle.stroke;
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(3, 3);
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()..position = initialPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
