import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp for the game.
///
/// Group of [Component]s composed by a [Pathway.arc] as the ramp, and two
/// [JetpackRampArea] at the entrance and exit of the ramp, to detect when
/// a ball gets into/out of the ramp.
/// {@endtemplate}
class JetpackRamp extends PositionComponent with HasGameRef<PinballGame> {
  /// {@macro jetpack_ramp}
  JetpackRamp({
    required Vector2 position,
  })  : _position = position,
        super();

  final double _radius = 200;
  final double _width = 80;
  final double _angle = radians(210);
  final double _rotation = radians(-10);
  final double _entranceRotation = radians(15);
  final double _exitRotation = radians(-5);
  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    await add(
      Pathway.arc(
        color: const Color.fromARGB(255, 8, 218, 241),
        position: _position,
        width: _width,
        radius: _radius,
        angle: _angle,
        rotation: _rotation,
        categoryBits: RampType.jetpack.maskBits,
      ),
    );

    await add(
      JetpackRampArea(
        position: _position + Vector2(-10.5, 0),
        rotation: _entranceRotation,
        orientation: RampOrientation.down,
      ),
    );
    await add(
      JetpackRampArea(
        position: _position + Vector2(20.5, 3),
        rotation: _exitRotation,
        orientation: RampOrientation.down,
      ),
    );

    gameRef.addContactCallback(JetpackRampAreaCallback());
  }
}

/// {@template jetpack_ramp_area}
/// Implementation of [RampArea] for sensors in [JetpackRamp].
///
/// [RampArea] with [RampType.jetpack] to filter [Ball]s collisions
/// inside [JetpackRamp].
/// {@endtemplate}
class JetpackRampArea extends RampArea {
  /// {@macro jetpack_ramp_area}
  JetpackRampArea({
    required Vector2 position,
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          position: position,
          categoryBits: RampType.jetpack.maskBits,
        );

  /// Orientation of entrance/exit of [JetpackRamp] where
  /// this [JetpackRampArea] is placed.
  final RampOrientation _orientation;

  /// Rotation of the [RampArea] to place it right at the
  /// entrance/exit of [JetpackRamp].
  final double _rotation;

  /// Size of the [RampArea] placed at the entrance/exit of [JetpackRamp].
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

/// {@template jetpack_ramp_area_callback}
/// Implementation of [RampAreaCallback] to listen when a [Ball]
/// gets into a [JetpackRampArea].
/// {@endtemplate}
class JetpackRampAreaCallback extends RampAreaCallback<JetpackRampArea> {
  /// {@macro jetpack_ramp_area_callback}
  JetpackRampAreaCallback() : super();

  /// Collection of balls inside [JetpackRamp].
  final _ballsInsideJetpack = <Ball>{};

  @override
  Set get ballsInside => _ballsInsideJetpack;
}
