// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/layer_sensor/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../../helpers/helpers.dart';

class _TestLayerSensor extends LayerSensor {
  _TestLayerSensor({
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

class _MockBall extends Mock implements Ball {}

class _MockBody extends Mock implements Body {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'LayerSensorBehavior',
    () {
      test('can be instantiated', () {
        expect(
          LayerFilteringBehavior(),
          isA<LayerFilteringBehavior>(),
        );
      });

      flameTester.test(
        'loads',
        (game) async {
          final behavior = LayerFilteringBehavior();
          final parent = _TestLayerSensor(
            orientation: LayerEntranceOrientation.down,
            insideZIndex: 1,
            insideLayer: Layer.spaceshipEntranceRamp,
          );

          await parent.add(behavior);
          await game.ensureAdd(parent);

          expect(game.contains(parent), isTrue);
        },
      );

      group('beginContact', () {
        late Ball ball;
        late Body body;
        late int insideZIndex;
        late Layer insideLayer;

        setUp(() {
          ball = _MockBall();
          body = _MockBody();
          insideZIndex = 1;
          insideLayer = Layer.spaceshipEntranceRamp;

          when(() => ball.body).thenReturn(body);
          when(() => ball.layer).thenReturn(Layer.board);
        });

        flameTester.test(
            'changes ball layer and zIndex '
            'when a ball enters and exits a downward oriented LayerSensor',
            (game) async {
          final parent = _TestLayerSensor(
            orientation: LayerEntranceOrientation.down,
            insideZIndex: 1,
            insideLayer: insideLayer,
          )..initialPosition = Vector2(0, 10);
          final behavior = LayerFilteringBehavior();

          await parent.add(behavior);
          await game.ensureAdd(parent);

          when(() => body.linearVelocity).thenReturn(Vector2(0, -1));

          behavior.beginContact(ball, _MockContact());
          verify(() => ball.layer = insideLayer).called(1);
          verify(() => ball.zIndex = insideZIndex).called(1);

          when(() => ball.layer).thenReturn(insideLayer);

          behavior.beginContact(ball, _MockContact());
          verify(() => ball.layer = Layer.board);
          verify(() => ball.zIndex = ZIndexes.ballOnBoard).called(1);
        });

        flameTester.test(
            'changes ball layer and zIndex '
            'when a ball enters and exits an upward oriented LayerSensor',
            (game) async {
          final parent = _TestLayerSensor(
            orientation: LayerEntranceOrientation.up,
            insideZIndex: 1,
            insideLayer: insideLayer,
          )..initialPosition = Vector2(0, 10);
          final behavior = LayerFilteringBehavior();

          await parent.add(behavior);
          await game.ensureAdd(parent);

          when(() => body.linearVelocity).thenReturn(Vector2(0, 1));

          behavior.beginContact(ball, _MockContact());
          verify(() => ball.layer = insideLayer).called(1);
          verify(() => ball.zIndex = 1).called(1);

          when(() => ball.layer).thenReturn(insideLayer);

          behavior.beginContact(ball, _MockContact());
          verify(() => ball.layer = Layer.board);
          verify(() => ball.zIndex = ZIndexes.ballOnBoard).called(1);
        });
      });
    },
  );
}
