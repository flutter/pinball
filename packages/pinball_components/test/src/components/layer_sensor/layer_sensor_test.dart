// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/layer_sensor/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class TestLayerSensor extends LayerSensor {
  TestLayerSensor({
    required LayerEntranceOrientation orientation,
    required int insideZIndex,
    required Layer insideLayer,
  }) : super(
          insideLayer: insideLayer,
          insideZIndex: insideZIndex,
          orientation: orientation,
        );

  @override
  Shape get shape => PolygonShape()..setAsBoxXY(1, 1);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);
  const insidePriority = 1;

  group('LayerSensor', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final layerSensor = TestLayerSensor(
          orientation: LayerEntranceOrientation.down,
          insideZIndex: insidePriority,
          insideLayer: Layer.spaceshipEntranceRamp,
        );
        await game.ensureAdd(layerSensor);

        expect(game.contains(layerSensor), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is static',
        (game) async {
          final layerSensor = TestLayerSensor(
            orientation: LayerEntranceOrientation.down,
            insideZIndex: insidePriority,
            insideLayer: Layer.spaceshipEntranceRamp,
          );
          await game.ensureAdd(layerSensor);

          expect(layerSensor.body.bodyType, equals(BodyType.static));
        },
      );

      group('first fixture', () {
        const pathwayLayer = Layer.spaceshipEntranceRamp;
        const openingLayer = Layer.opening;

        flameTester.test(
          'exists',
          (game) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            expect(layerSensor.body.fixtures[0], isA<Fixture>());
          },
        );

        flameTester.test(
          'shape is a polygon',
          (game) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          },
        );

        flameTester.test(
          'is sensor',
          (game) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );
      });
    });

    flameTester.test(
      'adds a LayerFilteringBehavior',
      (game) async {
        final layerSensor = TestLayerSensor(
          orientation: LayerEntranceOrientation.down,
          insideZIndex: insidePriority,
          insideLayer: Layer.spaceshipEntranceRamp,
        );
        await game.ensureAdd(layerSensor);

        expect(
          layerSensor.children.whereType<LayerFilteringBehavior>().length,
          equals(1),
        );
      },
    );
  });
}
