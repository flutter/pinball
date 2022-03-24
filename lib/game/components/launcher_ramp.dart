import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template launcher_ramp}
/// The yellow left ramp, where the [Ball] goes through when launched from the
/// [Plunger].
/// {@endtemplate}
class LauncherRamp extends Component with HasGameRef<PinballGame> {
  /// {@macro launcher_ramp}
  LauncherRamp({
    required this.position,
  });

  /// The position of this [LauncherRamp].
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    const layer = Layer.launcher;

    gameRef.addContactCallback(
      RampOpeningBallContactCallback<_LauncherRampOpening>(),
    );

    final launcherRampRotation =
        -math.atan(18.6 / PinballGame.boardBounds.height);

    final straightPath = Pathway.straight(
      color: const Color.fromARGB(255, 34, 255, 0),
      start: position + Vector2(-1.2, 10),
      end: position + Vector2(-1.2, 117),
      width: 5,
      rotation: launcherRampRotation,
    )
      ..initialPosition = position
      ..layer = layer;

    final curvedPath = Pathway.arc(
      color: const Color.fromARGB(255, 251, 255, 0),
      center: position + Vector2(-2.8, 87.2),
      radius: 16.3,
      angle: math.pi / 2,
      width: 5,
      rotation: 3 * math.pi / 2,
    )..layer = layer;

    final leftOpening = _LauncherRampOpening(rotation: math.pi / 2)
      ..initialPosition = position + Vector2(-11.8, 66.3)
      ..layer = Layer.opening;
    final rightOpening = _LauncherRampOpening(rotation: 0)
      ..initialPosition = position + Vector2(-4.9, 59.4)
      ..layer = Layer.opening;

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
class _LauncherRampOpening extends RampOpening {
  /// {@macro launcher_ramp_opening}
  _LauncherRampOpening({
    required double rotation,
  })  : _rotation = rotation,
        super(
          pathwayLayer: Layer.launcher,
          orientation: RampOrientation.down,
        );

  final double _rotation;

  // TODO(ruialonso): Avoid magic number 3, should be propotional to
  // [JetpackRamp].
  static final Vector2 _size = Vector2(3, .1);

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
