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
  // TODO(ruialonso): Avoid using radians.
  final double _angle = radians(210);
  final double _rotation = radians(-10);

  /// The position of this [JetpackRamp]
  final Vector2 position;

  static const _layer = Layer.jetpack;

  @override
  Future<void> onLoad() async {
    gameRef.addContactCallback(
      RampOpeningBallContactCallback<JetpackRampOpening>(),
    );

    final curvePath = Pathway.arc(
      // TODO(ruialonso): Remove color when not needed.
      // TODO(ruialonso): Use a bezier curve once control points are defined.
      color: const Color.fromARGB(255, 8, 218, 241),
      center: position,
      width: _width,
      radius: _radius,
      angle: _angle,
      rotation: _rotation,
    )
      ..initialPosition = position
      ..layer = _layer;
    final leftOpening = JetpackRampOpening(
      orientation: RampOrientation.down,
      rotation: radians(15),
    )
      ..initialPosition = position + Vector2(-25.7, 25)
      ..layer = Layer.opening;
    final rightOpening = JetpackRampOpening(
      orientation: RampOrientation.down,
      rotation: radians(-9),
    )
      ..initialPosition = position + Vector2(-10, 26.2)
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
class JetpackRampOpening extends RampOpening {
  /// {@macro jetpack_ramp_opening}
  JetpackRampOpening({
    required RampOrientation orientation,
    double rotation = 0,
  })  : _rotation = rotation,
        _orientation = orientation,
        super(
          pathwayLayer: Layer.jetpack,
        );

  /// Orientation of entrance/exit of [JetpackRamp] where
  /// this [JetpackRampOpening] is placed.
  final RampOrientation _orientation;

  /// Rotation of the [RampOpening] to place it right at the
  /// entrance/exit of [JetpackRamp].
  final double _rotation;

  /// Size of the [RampOpening] placed at the entrance/exit of [JetpackRamp].
  // TODO(ruialonso): Avoid magic number 3, should be propotional to
  // [JetpackRamp].
  final Vector2 _size = Vector2(3, .1);

  @override
  RampOrientation get orientation => _orientation;

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      _size.x,
      _size.y,
      initialPosition,
      _rotation,
    );
}
