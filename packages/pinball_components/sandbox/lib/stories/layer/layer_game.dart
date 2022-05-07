import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class LayerGame extends BallGame with TapDetector {
  static const description = '''
    Shows how Layers work when a Ball hits other components.
      
    - Tap anywhere on the screen to spawn a Ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await addAll(
      [
        _BigSquare()..initialPosition = Vector2(30, -40),
        _SmallSquare()..initialPosition = Vector2(50, -40),
        _UnlayeredSquare()..initialPosition = Vector2(60, -40),
      ],
    );
  }
}

class _BigSquare extends BodyComponent with InitialPosition, Layered {
  _BigSquare()
      : super(
          children: [
            _UnlayeredSquare()..initialPosition = Vector2.all(4),
            _SmallSquare()..initialPosition = Vector2.all(-4),
          ],
        ) {
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
}

class _SmallSquare extends BodyComponent with InitialPosition, Layered {
  _SmallSquare() {
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

class _UnlayeredSquare extends BodyComponent with InitialPosition {
  _UnlayeredSquare() {
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
