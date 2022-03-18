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
      width: 80,
      radius: 200,
      angle: 7 * math.pi / 6,
      rotation: -math.pi / 18,
    )
      ..initialPosition = position
      ..layer = layer;
    final leftOpening = _JetpackRampOpening(
      rotation: 15 * math.pi / 180,
    )
      ..initialPosition = position + Vector2(-27, 21)
      ..layer = Layer.opening;
    final rightOpening = _JetpackRampOpening(
      rotation: -math.pi / 20,
    )
      ..initialPosition = position + Vector2(-11.2, 22.5)
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
    required double rotation,
  })  : _rotation = rotation,
        super(
          pathwayLayer: Layer.jetpack,
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
