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
        color: const Color.fromARGB(255, 8, 218, 241),
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
        orientation: RampOrientation.down,
      ),
    );
    await add(
      JetpackRampArea(
        position: _position + Vector2(20.5, 3),
        rotation: radians(-5),
        orientation: RampOrientation.down,
      ),
    );

    gameRef.addContactCallback(JetpackRampAreaCallback());
  }
}

class JetpackRampArea extends RampArea {
  JetpackRampArea({
    required Vector2 position,
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          position: position,
          maskBits: RampType.jetpack.maskBits,
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

class JetpackRampAreaCallback extends RampAreaCallback<JetpackRampArea> {
  JetpackRampAreaCallback() : super();

  final _ballsInsideJetpack = <Ball>{};

  @override
  Set get ballsInside => _ballsInsideJetpack;
}
