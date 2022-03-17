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
    gameRef.addContactCallback(
      RampOpeningBallContactCallback<LauncherRampOpening>(),
    );

    final straightPath = Pathway.straight(
      color: const Color.fromARGB(255, 34, 255, 0),
      start: Vector2(0, 0),
      end: Vector2(0, 600),
      width: 80,
      layer: Layer.launcher,
    )..initialPosition = position;
    final curvedPath = Pathway.arc(
      color: const Color.fromARGB(255, 251, 255, 0),
      center: position + Vector2(-28.8, -6),
      radius: _radius,
      angle: _angle,
      width: _width,
      layer: Layer.launcher,
    )..initialPosition = position + Vector2(-28.8, -6);
    final leftOpening = LauncherRampOpening(
      orientation: RampOrientation.down,
      rotation: radians(13),
    )..initialPosition = position + Vector2(-46.5, -8.5);
    final rightOpening = LauncherRampOpening(
      orientation: RampOrientation.down,
    )..initialPosition = position + Vector2(4, 0);

    await addAll([
      straightPath,
      curvedPath,
      leftOpening,
      rightOpening,
    ]);
  }
}

/// {@template launcher_ramp_opening}
/// [RampOpening] with [Layer.launcher] to filter [Ball]s collisions
/// inside [LauncherRamp].
/// {@endtemplate}
class LauncherRampOpening extends RampOpening {
  /// {@macro launcher_ramp_opening}
  LauncherRampOpening({
    double rotation = 0,
    required RampOrientation orientation,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          pathwayLayer: Layer.launcher,
          openingLayer: Layer.opening,
        );

  /// Orientation of entrance/exit of [LauncherRamp] where
  /// this [LauncherRampOpening] is placed.
  final RampOrientation _orientation;

  /// Rotation of the [RampOpening] to place it right at the
  /// entrance/exit of [LauncherRamp].
  final double _rotation;

  /// Size of the [RampOpening] placed at the entrance/exit of [LauncherRamp].
  final int _size = 6;

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
