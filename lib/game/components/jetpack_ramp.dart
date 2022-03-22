import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp of the [Board].
/// {@endtemplate}
class JetpackRamp extends Component with HasGameRef<PinballGame> {
  /// {@macro jetpack_ramp}
  JetpackRamp({
    required this.position,
  });

  /// The position of this [JetpackRamp].
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    const layer = Layer.jetpack;

    gameRef.addContactCallback(
      RampOpeningBallContactCallback<_JetpackRampOpening>(),
    );

    final curvePath = Pathway.arc(
      // TODO(ruialonso): Remove color when not needed.
      // TODO(ruialonso): Use a bezier curve once control points are defined.
      color: const Color.fromARGB(255, 8, 218, 241),
      center: position,
      width: 62,
      radius: 200,
      angle: math.pi,
    )
      ..initialPosition = position
      ..layer = layer;
    final leftOpening = _JetpackRampOpening(outsideLayer: Layer.spaceship)
      ..initialPosition = position + Vector2(-27.6, 25.3)
      ..layer = Layer.jetpack;

    final rightOpening = _JetpackRampOpening()
      ..initialPosition = position + Vector2(-10.6, 25.3)
      ..layer = Layer.opening;

    await addAll([
      curvePath,
      leftOpening,
      rightOpening,
    ]);
  }
}

/// {@template jetpack_ramp_opening}
/// [RampOpening] with [Layer.jetpack] to filter [Ball] collisions
/// inside [JetpackRamp].
/// {@endtemplate}
class _JetpackRampOpening extends RampOpening {
  /// {@macro jetpack_ramp_opening}
  _JetpackRampOpening({
    Layer? outsideLayer,
  }) : super(
          pathwayLayer: Layer.jetpack,
          outsideLayer: outsideLayer,
          orientation: RampOrientation.down,
        );

  // TODO(ruialonso): Avoid magic number 2, should be proportional to
  // [JetpackRamp].
  static const _size = 2;

  @override
  Shape get shape => PolygonShape()
    ..setAsEdge(
      Vector2(initialPosition.x - _size, initialPosition.y),
      Vector2(initialPosition.x + _size, initialPosition.y),
    );
}
