// ignore_for_file: avoid_renaming_method_parameters, public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/layer_sensor/behaviors/layer_filtering_behavior.dart';

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
/// By default the base [layer] is set to [Layer.board] and the
/// [outsideZIndex] is set to [ZIndexes.ballOnBoard].
/// {@endtemplate}
abstract class LayerSensor extends BodyComponent with InitialPosition, Layered {
  /// {@macro layer_sensor}
  LayerSensor({
    required this.insideLayer,
    Layer? outsideLayer,
    required this.insideZIndex,
    int? outsideZIndex,
    required this.orientation,
  })  : outsideLayer = outsideLayer ?? Layer.board,
        outsideZIndex = outsideZIndex ?? ZIndexes.ballOnBoard,
        super(
          renderBody: false,
          children: [LayerFilteringBehavior()],
        ) {
    layer = Layer.opening;
  }

  final Layer insideLayer;

  final Layer outsideLayer;

  final int insideZIndex;

  final int outsideZIndex;

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
    final bodyDef = BodyDef(position: initialPosition);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
