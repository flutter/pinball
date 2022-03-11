import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class SparkyRamp extends PositionComponent with HasGameRef<PinballGame> {
  SparkyRamp({
    required Vector2 position,
  })  : _position = position,
        super();

  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    await add(
      Pathway.arc(
        color: const Color.fromARGB(255, 251, 255, 0),
        position: _position,
        radius: 300,
        angle: math.pi,
        width: 80,
        maskBits: RampType.sparky.maskBits,
      ),
    );
    await add(
      SparkyRampArea(
        position: _position + Vector2(-19, 6),
        orientation: RampOrientation.down,
      ),
    );
    await add(
      SparkyRampArea(
        position: _position + Vector2(33, 6),
        orientation: RampOrientation.down,
      ),
    );

    gameRef.addContactCallback(SparkyRampAreaCallback());
  }
}

class SparkyRampArea extends RampArea {
  SparkyRampArea({
    required Vector2 position,
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          position: position,
          maskBits: RampType.sparky.maskBits,
        );

  final RampOrientation _orientation;
  final double _rotation;
  final int _size = 7;

  @override
  RampOrientation get orientation => _orientation;

  @override
  Shape get shape => PolygonShape()
    ..set([
      Vector2(-_size / 2, -.1)..rotate(_rotation),
      Vector2(-_size / 2, .1)..rotate(_rotation),
      Vector2(_size / 2, .1)..rotate(_rotation),
      Vector2(_size / 2, -.1)..rotate(_rotation),
    ]);
}

class SparkyRampAreaCallback extends RampAreaCallback<SparkyRampArea> {
  SparkyRampAreaCallback() : super();

  final _ballsInsideSparky = <Ball>{};

  @override
  Set get ballsInside => _ballsInsideSparky;
}
