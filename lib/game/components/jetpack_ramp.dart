import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp for the game.
///
/// Composed of a [Pathway.arc] defining the ramp, and two
/// [JetpackRampOpening]s at the entrance and exit of the ramp.
/// {@endtemplate}
class JetpackRamp extends Component with HasGameRef<PinballGame> {
  /// {@macro jetpack_ramp}
  JetpackRamp({
    required this.position,
  });

  final double _radius = 200;
  final double _width = 80;
  final double _angle = radians(210);
  final double _rotation = radians(-10);
  final double _entranceRotation = radians(15);
  final double _exitRotation = radians(-5);

  /// The position of this [JetpackRamp]
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    await add(
      Pathway.arc(
        color: const Color.fromARGB(255, 8, 218, 241),
        position: position,
        width: _width,
        radius: _radius,
        angle: _angle,
        rotation: _rotation,
        categoryBits: RampType.jetpack.maskBits,
      ),
    );

    await add(
      JetpackRampOpening(
        position: position + Vector2(-10.5, 0),
        rotation: _entranceRotation,
        orientation: RampOrientation.down,
      ),
    );
    await add(
      JetpackRampOpening(
        position: position + Vector2(20.5, 3),
        rotation: _exitRotation,
        orientation: RampOrientation.down,
      ),
    );

    gameRef.addContactCallback(JetpackRampOpeningBallContactCallback());
  }
}

/// {@template jetpack_ramp_opening}
/// Implementation of [RampOpening] for sensors in [JetpackRamp].
///
/// [RampOpening] with [RampType.jetpack] to filter [Ball]s collisions
/// inside [JetpackRamp].
/// {@endtemplate}
class JetpackRampOpening extends RampOpening {
  /// {@macro jetpack_ramp_opening}
  JetpackRampOpening({
    required Vector2 position,
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          position: position,
          layer: RampType.jetpack,
        );

  /// Orientation of entrance/exit of [JetpackRamp] where
  /// this [JetpackRampOpening] is placed.
  final RampOrientation _orientation;

  /// Rotation of the [RampOpening] to place it right at the
  /// entrance/exit of [JetpackRamp].
  final double _rotation;

  /// Size of the [RampOpening] placed at the entrance/exit of [JetpackRamp].
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

/// {@template jetpack_ramp_opening_ball_contact_callback}
/// Implementation of [RampOpeningBallContactCallback] to listen when a [Ball]
/// gets into a [JetpackRampOpening].
/// {@endtemplate}
class JetpackRampOpeningBallContactCallback
    extends RampOpeningBallContactCallback<JetpackRampOpening> {
  /// {@macro jetpack_ramp_opening_ball_contact_callback}
  JetpackRampOpeningBallContactCallback() : super();

  /// Collection of balls inside [JetpackRamp].
  final _ballsInsideJetpack = <Ball>{};

  @override
  Set get ballsInside => _ballsInsideJetpack;
}
