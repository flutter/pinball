// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class TestLayerSensor extends LayerSensor {
  TestLayerSensor({
    required LayerEntranceOrientation orientation,
    required int insidePriority,
    required Layer insideLayer,
  }) : super(
          insideLayer: insideLayer,
          insidePriority: insidePriority,
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
          insidePriority: insidePriority,
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
            insidePriority: insidePriority,
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
              insidePriority: insidePriority,
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
              insidePriority: insidePriority,
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
              insidePriority: insidePriority,
              insideLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(layerSensor);

            final fixture = layerSensor.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );
      });
    });
  });

  group('beginContact', () {
    late Ball ball;
    late Body body;

    setUp(() {
      ball = MockBall();
      body = MockBody();

      when(() => ball.body).thenReturn(body);
      when(() => ball.priority).thenReturn(1);
      when(() => ball.layer).thenReturn(Layer.board);
    });

    flameTester.test(
        'changes ball layer and priority '
        'when a ball enters and exits a downward oriented LayerSensor',
        (game) async {
      final sensor = TestLayerSensor(
        orientation: LayerEntranceOrientation.down,
        insidePriority: insidePriority,
        insideLayer: Layer.spaceshipEntranceRamp,
      )..initialPosition = Vector2(0, 10);

      when(() => body.linearVelocity).thenReturn(Vector2(0, -1));

      sensor.beginContact(ball, MockContact());
      verify(() => ball.layer = sensor.insideLayer).called(1);
      verify(() => ball.priority = sensor.insidePriority).called(1);
      verify(ball.reorderChildren).called(1);

      when(() => ball.layer).thenReturn(sensor.insideLayer);

      sensor.beginContact(ball, MockContact());
      verify(() => ball.layer = Layer.board);
      verify(() => ball.priority = RenderPriority.ballOnBoard).called(1);
      verify(ball.reorderChildren).called(1);
    });

    flameTester.test(
        'changes ball layer and priority '
        'when a ball enters and exits an upward oriented LayerSensor',
        (game) async {
      final sensor = TestLayerSensor(
        orientation: LayerEntranceOrientation.up,
        insidePriority: insidePriority,
        insideLayer: Layer.spaceshipEntranceRamp,
      )..initialPosition = Vector2(0, 10);

      when(() => body.linearVelocity).thenReturn(Vector2(0, 1));

      sensor.beginContact(ball, MockContact());
      verify(() => ball.layer = sensor.insideLayer).called(1);
      verify(() => ball.priority = sensor.insidePriority).called(1);
      verify(ball.reorderChildren).called(1);

      when(() => ball.layer).thenReturn(sensor.insideLayer);

      sensor.beginContact(ball, MockContact());
      verify(() => ball.layer = Layer.board);
      verify(() => ball.priority = RenderPriority.ballOnBoard).called(1);
      verify(ball.reorderChildren).called(1);
    });
  });
}
