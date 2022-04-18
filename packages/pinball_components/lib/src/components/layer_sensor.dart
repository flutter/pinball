// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template layer_entrance_orientation}
/// Determines if a layer entrance is oriented [up] or [down] on the board.
/// {@endtemplate}
enum LayerEntranceOrientation {
  /// Facing up on the Board.
  up,

  /// Facing down on the Board.
  down,
}

/// {@template layer_sensor}
/// [BodyComponent] located at the entrance and exit of a [Layer].
///
/// [LayerSensorBallContactCallback] detects when a [Ball] passes
/// through this sensor.
///
/// By default the base [layer] is set to [Layer.board] and the
/// [outsidePriority] is set to the lowest possible [Layer].
/// {@endtemplate}
abstract class LayerSensor extends BodyComponent with InitialPosition, Layered {
  /// {@macro layer_sensor}
  LayerSensor({
    required Layer insideLayer,
    Layer? outsideLayer,
    required int insidePriority,
    int? outsidePriority,
    required this.orientation,
  })  : _insideLayer = insideLayer,
        _outsideLayer = outsideLayer ?? Layer.board,
        _insidePriority = insidePriority,
        _outsidePriority = outsidePriority ?? RenderPriority.ballOnBoard {
    layer = Layer.opening;
  }
  final Layer _insideLayer;
  final Layer _outsideLayer;
  final int _insidePriority;
  final int _outsidePriority;

  /// Mask bits value for collisions on [Layer].
  Layer get insideLayer => _insideLayer;

  /// Mask bits value for collisions outside of [Layer].
  Layer get outsideLayer => _outsideLayer;

  /// Render priority for the [Ball] on [Layer].
  int get insidePriority => _insidePriority;

  /// Render priority for the [Ball] outside of [Layer].
  int get outsidePriority => _outsidePriority;

  /// The [Shape] of the [LayerSensor].
  Shape get shape;

  /// {@macro layer_entrance_orientation}
  // TODO(ruimiguel): Try to remove the need of [LayerEntranceOrientation] for
  // collision calculations.
  final LayerEntranceOrientation orientation;

  @override
  Body createBody() {
    final fixtureDef = FixtureDef(
      shape,
      isSensor: true,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template layer_sensor_ball_contact_callback}
/// Detects when a [Ball] enters or exits a [Layer] through a [LayerSensor].
///
/// Modifies [Ball]'s [Layer] and render priority depending on whether the
/// [Ball] is on or outside of a [Layer].
/// {@endtemplate}
class LayerSensorBallContactCallback<LayerEntrance extends LayerSensor>
    extends ContactCallback<Ball, LayerEntrance> {
  @override
  void begin(Ball ball, LayerEntrance layerEntrance, Contact _) {
    if (ball.layer != layerEntrance.insideLayer) {
      final isBallEnteringOpening =
          (layerEntrance.orientation == LayerEntranceOrientation.down &&
                  ball.body.linearVelocity.y < 0) ||
              (layerEntrance.orientation == LayerEntranceOrientation.up &&
                  ball.body.linearVelocity.y > 0);

      if (isBallEnteringOpening) {
        ball
          ..layer = layerEntrance.insideLayer
          ..priority = layerEntrance.insidePriority
          ..reorderChildren();
      }
    } else {
      ball
        ..layer = layerEntrance.outsideLayer
        ..priority = layerEntrance.outsidePriority
        ..reorderChildren();
    }
  }
}
