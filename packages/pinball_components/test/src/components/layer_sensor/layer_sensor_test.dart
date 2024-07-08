// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/layer_sensor/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

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
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final layerSensor = TestLayerSensor(
          orientation: LayerEntranceOrientation.down,
          insideZIndex: insidePriority,
          insideLayer: Layer.spaceshipEntranceRamp,
        );
        await game.ensureAdd(layerSensor);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<TestLayerSensor>(), isNotEmpty);
      },
    );

    group('body', () {
      flameTester.testGameWidget(
        'is static',
        setUp: (game, _) async {
          final layerSensor = TestLayerSensor(
            orientation: LayerEntranceOrientation.down,
            insideZIndex: insidePriority,
            insideLayer: Layer.spaceshipEntranceRamp,
          );
          await game.ensureAdd(layerSensor);
        },
        verify: (game, _) async {
          final layerSensor =
              game.descendants().whereType<TestLayerSensor>().single;
          expect(layerSensor.body.bodyType, equals(BodyType.static));
        },
      );

      group('first fixture', () {
        const pathwayLayer = Layer.spaceshipEntranceRamp;
        const openingLayer = Layer.opening;

        flameTester.testGameWidget(
          'exists',
          setUp: (game, _) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);
          },
          verify: (game, _) async {
            final layerSensor =
                game.descendants().whereType<TestLayerSensor>().single;
            expect(layerSensor.body.fixtures[0], isA<Fixture>());
          },
        );

        flameTester.testGameWidget(
          'shape is a polygon',
          setUp: (game, _) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);
          },
          verify: (game, _) async {
            final layerSensor =
                game.descendants().whereType<TestLayerSensor>().single;

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          },
        );

        flameTester.testGameWidget(
          'is sensor',
          setUp: (game, _) async {
            final layerSensor = TestLayerSensor(
              orientation: LayerEntranceOrientation.down,
              insideZIndex: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);
          },
          verify: (game, _) async {
            final layerSensor =
                game.descendants().whereType<TestLayerSensor>().single;

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );
      });
    });

    flameTester.testGameWidget(
      'adds a LayerFilteringBehavior',
      setUp: (game, _) async {
        final layerSensor = TestLayerSensor(
          orientation: LayerEntranceOrientation.down,
          insideZIndex: insidePriority,
          insideLayer: Layer.spaceshipEntranceRamp,
        );
        await game.ensureAdd(layerSensor);
      },
      verify: (game, _) async {
        final layerSensor =
            game.descendants().whereType<TestLayerSensor>().single;
        expect(
          layerSensor.children.whereType<LayerFilteringBehavior>().length,
          equals(1),
        );
      },
    );
  });
}
