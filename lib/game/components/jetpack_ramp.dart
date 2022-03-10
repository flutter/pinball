import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class JetpackRamp extends PositionComponent with HasGameRef<PinballGame> {
  JetpackRamp({
    required Vector2 position,
  })  : _position = position,
        super();

  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    await add(
      Pathway.arc(
        color: Color.fromARGB(255, 8, 218, 241),
        position: _position,
        width: 80,
        radius: 200,
        angle: radians(210),
        rotation: radians(-10),
        maskBits: RampType.jetpack.maskBits,
      ),
    );

    await add(
      JetpackRampArea(
        position: _position + Vector2(-10.5, 0),
        rotation: radians(15),
      ),
    );
    await add(
      JetpackRampArea(
        position: _position + Vector2(20.5, 3),
        rotation: radians(-5),
      ),
    );

    gameRef.addContactCallback(JetpackRampAreaCallback());
  }
}

class JetpackRampArea extends RampArea {
  JetpackRampArea({
    required Vector2 position,
    double rotation = 0,
    int size = 7,
  })  : _rotation = rotation,
        _size = size,
        super(
          position: position,
          maskBits: RampType.jetpack.maskBits,
        );

  final double _rotation;
  final int _size;

  @override
  Shape get shape => PolygonShape()
    ..set([
      Vector2(-_size / 2, -.5)..rotate(_rotation),
      Vector2(-_size / 2, .5)..rotate(_rotation),
      Vector2(_size / 2, .5)..rotate(_rotation),
      Vector2(_size / 2, -.5)..rotate(_rotation),
    ]);
}

class JetpackRampAreaCallback extends RampAreaCallback<JetpackRampArea> {
  @override
  Set get ballsInside => <Ball>{};
}
