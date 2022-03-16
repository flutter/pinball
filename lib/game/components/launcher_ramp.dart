import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template launcher_ramp}
/// Represent the launcher green and upper right yellow ramps for the game.
///
/// Group of [Component]s composed by a [Pathway.arc] as the upper curve ramp,
/// a [Pathway.straight] for the launcher straight ramp, and two
/// [LauncherRampOpening] at the entrance and exit of the ramp, to detect when
/// a ball gets into/out of the ramp.
/// {@endtemplate}
class LauncherRamp extends Component with HasGameRef<PinballGame> {
  /// {@macro launcher_ramp}
  LauncherRamp({
    required this.position,
  });

  final double _radius = 300;
  final double _width = 80;
  final double _angle = radians(200);

  /// The position of this [LauncherRamp]
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    await add(
      Pathway.straight(
        color: const Color.fromARGB(255, 34, 255, 0),
        position: position,
        start: Vector2(0, 0),
        end: Vector2(0, 600),
        width: 80,
        layer: Layer.launcher,
      ),
    );

    await add(
      Pathway.arc(
        color: const Color.fromARGB(255, 251, 255, 0),
        position: position + Vector2(-28.8, -6),
        radius: _radius,
        angle: _angle,
        width: _width,
        layer: Layer.launcher,
      ),
    );
    await add(
      LauncherRampOpening(
        position: position + Vector2(-46.5, -8.5),
        orientation: RampOrientation.down,
        rotation: radians(13),
      ),
    );
    await add(
      LauncherRampOpening(
        position: position + Vector2(4, 0),
        orientation: RampOrientation.down,
      ),
    );

    gameRef.addContactCallback(LauncherRampOpeningBallContactCallback());
  }
}

/// {@template launcher_ramp_opening}
/// [RampOpening] with [Layer.launcher] to filter [Ball]s collisions
/// inside [LauncherRamp].
/// {@endtemplate}
class LauncherRampOpening extends RampOpening {
  /// {@macro launcher_ramp_opening}
  LauncherRampOpening({
    required Vector2 position,
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          position: position,
          pathwayLayer: Layer.launcher,
        );

  /// Orientation of entrance/exit of [LauncherRamp] where
  /// this [LauncherRampOpening] is placed.
  final RampOrientation _orientation;

  /// Rotation of the [RampOpening] to place it right at the
  /// entrance/exit of [LauncherRamp].
  final double _rotation;

  /// Size of the [RampOpening] placed at the entrance/exit of [LauncherRamp].
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

/// {@template launcher_ramp_opening_ball_contact_callback}
/// Detects when a [Ball] enters or exits the [LauncherRamp] through a
/// [LauncherRampOpening].
/// {@endtemplate}
class LauncherRampOpeningBallContactCallback
    extends RampOpeningBallContactCallback<LauncherRampOpening> {
  /// {@macro launcher_ramp_opening_ball_contact_callback}
  LauncherRampOpeningBallContactCallback() : super();

  /// Collection of balls inside [LauncherRamp].
  final _ballsInsideLauncher = <Ball>{};

  @override
  Set get ballsInside => _ballsInsideLauncher;
}
