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

    final straightPath = Pathway.straight(
      color: const Color.fromARGB(255, 34, 255, 0),
      start: position + Vector2(-4.5, -10),
      end: position + Vector2(-4.5, 117),
      width: 4,
      rotation: PinballGame.boardPerspectiveAngle,
    )
      ..initialPosition = position
      ..layer = layer;

    final curvedPath = Pathway.arc(
      color: const Color.fromARGB(255, 251, 255, 0),
      center: position + Vector2(-7, 87.2),
      radius: 16.3,
      angle: math.pi / 2,
      width: 4,
      rotation: 3 * math.pi / 2,
    )..layer = layer;

    final leftOpening = _LauncherRampOpening(rotation: math.pi / 2)
      ..initialPosition = position + Vector2(-13.8, 66.7)
      ..layer = Layer.opening;
    final rightOpening = _LauncherRampOpening(rotation: 0)
      ..initialPosition = position + Vector2(-6.8, 59.4)
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

  // TODO(ruialonso): Avoid magic number 2.5, should be propotional to
  // [JetpackRamp].
  static final Vector2 _size = Vector2(2.5, .1);

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
