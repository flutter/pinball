import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template sparky_ramp}
/// Represent the upper right yellow ramp for the game.
///
/// Group of [Component]s composed by a [Pathway.arc] as the ramp, and two
/// [SparkyRampOpening] at the entrance and exit of the ramp, to detect when
/// a ball gets into/out of the ramp.
/// {@endtemplate}
class SparkyRamp extends Component with HasGameRef<PinballGame> {
  /// {@macro sparky_ramp}
  SparkyRamp({
    required this.position,
  });

  final double _radius = 300;
  final double _width = 80;
  final double _angle = radians(200);

  /// The position of this [SparkyRamp]
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    await add(
      Pathway.arc(
        color: const Color.fromARGB(255, 251, 255, 0),
        position: position,
        radius: _radius,
        angle: _angle,
        width: _width,
        categoryBits: RampType.sparky.maskBits,
      ),
    );
    await add(
      SparkyRampOpening(
        position: position + Vector2(-18, -2),
        orientation: RampOrientation.down,
        rotation: radians(13),
      ),
    );
    await add(
      SparkyRampOpening(
        position: position + Vector2(33, 6),
        orientation: RampOrientation.down,
      ),
    );

    gameRef.addContactCallback(SparkyRampOpeningBallContactCallback());
  }
}

/// {@template sparky_ramp_opening}
/// Implementation of [RampOpening] for sensors in [SparkyRamp].
///
/// [RampOpening] with [RampType.sparky] to filter [Ball]s collisions
/// inside [SparkyRamp].
/// {@endtemplate}
class SparkyRampOpening extends RampOpening {
  /// {@macro sparky_ramp_opening}
  SparkyRampOpening({
    required Vector2 position,
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          position: position,
          categoryBits: RampType.sparky.maskBits,
        );

  /// Orientation of entrance/exit of [SparkyRamp] where
  /// this [SparkyRampOpening] is placed.
  final RampOrientation _orientation;

  /// Rotation of the [RampOpening] to place it right at the
  /// entrance/exit of [SparkyRamp].
  final double _rotation;

  /// Size of the [RampOpening] placed at the entrance/exit of [SparkyRamp].
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

/// {@template sparky_ramp_opening_ball_contact_callback}
/// Implementation of [RampOpeningBallContactCallback] to listen when a [Ball]
/// gets into a [SparkyRampOpening].
/// {@endtemplate}
class SparkyRampOpeningBallContactCallback
    extends RampOpeningBallContactCallback<SparkyRampOpening> {
  /// {@macro sparky_ramp_opening_ball_contact_callback}
  SparkyRampOpeningBallContactCallback() : super();

  /// Collection of balls inside [SparkyRamp].
  final _ballsInsideSparky = <Ball>{};

  @override
  Set get ballsInside => _ballsInsideSparky;
}
