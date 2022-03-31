// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class TestRampOpening extends RampOpening {
  TestRampOpening({
    required RampOrientation orientation,
    required Layer pathwayLayer,
  }) : super(
          insideLayer: pathwayLayer,
          orientation: orientation,
        );

  @override
  Shape get shape => PolygonShape()
    ..set([
      Vector2(0, 0),
      Vector2(0, 1),
      Vector2(1, 1),
      Vector2(1, 0),
    ]);
}

class TestRampOpeningBallContactCallback
    extends RampOpeningBallContactCallback<TestRampOpening> {
  TestRampOpeningBallContactCallback() : super();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('RampOpening', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(TestGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = TestRampOpening(
          orientation: RampOrientation.down,
          pathwayLayer: Layer.jetpack,
        );
        await game.ready();
        await game.ensureAdd(ramp);

        expect(game.contains(ramp), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is static',
        (game) async {
          final ramp = TestRampOpening(
            orientation: RampOrientation.down,
            pathwayLayer: Layer.jetpack,
          );
          await game.ensureAdd(ramp);

          expect(ramp.body.bodyType, equals(BodyType.static));
        },
      );

      group('first fixture', () {
        const pathwayLayer = Layer.jetpack;
        const openingLayer = Layer.opening;

        flameTester.test(
          'exists',
          (game) async {
            final ramp = TestRampOpening(
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(ramp);

            expect(ramp.body.fixtures[0], isA<Fixture>());
          },
        );

        flameTester.test(
          'shape is a polygon',
          (game) async {
            final ramp = TestRampOpening(
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          },
        );

        flameTester.test(
          'is sensor',
          (game) async {
            final ramp = TestRampOpening(
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
            )..layer = openingLayer;
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );
      });
    });
  });

  group('RampOpeningBallContactCallback', () {
    flameTester.test(
        'changes ball layer '
        'when a ball enters upwards into a downward ramp opening',
        (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
      );
      final callback = TestRampOpeningBallContactCallback();

      when(() => ball.body).thenReturn(body);
      when(() => ball.priority).thenReturn(1);
      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.layer).thenReturn(Layer.board);

      callback.begin(ball, area, MockContact());
      verify(() => ball.layer = area.insideLayer).called(1);
    });

    flameTester.test(
        'changes ball layer '
        'when a ball enters downwards into a upward ramp opening',
        (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.up,
        pathwayLayer: Layer.jetpack,
      );
      final callback = TestRampOpeningBallContactCallback();

      when(() => ball.body).thenReturn(body);
      when(() => ball.priority).thenReturn(1);
      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.layer).thenReturn(Layer.board);

      callback.begin(ball, area, MockContact());
      verify(() => ball.layer = area.insideLayer).called(1);
    });

    flameTester.test(
        'changes ball layer '
        'when a ball exits from a downward oriented ramp', (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
      )..initialPosition = Vector2(0, 10);
      final callback = TestRampOpeningBallContactCallback();

      when(() => ball.body).thenReturn(body);
      when(() => ball.priority).thenReturn(1);
      when(() => body.position).thenReturn(Vector2.zero());
      when(() => body.linearVelocity).thenReturn(Vector2(0, -1));
      when(() => ball.layer).thenReturn(Layer.board);

      callback.begin(ball, area, MockContact());
      verify(() => ball.layer = area.insideLayer).called(1);

      callback.end(ball, area, MockContact());
      verify(() => ball.layer = Layer.board);
    });

    flameTester.test(
        'changes ball layer '
        'when a ball exits from a upward oriented ramp', (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.up,
        pathwayLayer: Layer.jetpack,
      )..initialPosition = Vector2(0, 10);
      final callback = TestRampOpeningBallContactCallback();

      when(() => ball.body).thenReturn(body);
      when(() => ball.priority).thenReturn(1);
      when(() => body.position).thenReturn(Vector2.zero());
      when(() => body.linearVelocity).thenReturn(Vector2(0, 1));
      when(() => ball.layer).thenReturn(Layer.board);

      callback.begin(ball, area, MockContact());
      verify(() => ball.layer = area.insideLayer).called(1);

      callback.end(ball, area, MockContact());
      verify(() => ball.layer = Layer.board);
    });

    flameTester.test(
        'change ball layer from pathwayLayer to Layer.board '
        'when a ball enters and exits from ramp', (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
      )..initialPosition = Vector2(0, 10);
      final callback = TestRampOpeningBallContactCallback();

      when(() => ball.body).thenReturn(body);
      when(() => ball.priority).thenReturn(1);
      when(() => body.position).thenReturn(Vector2.zero());
      when(() => body.linearVelocity).thenReturn(Vector2(0, 1));
      when(() => ball.layer).thenReturn(Layer.board);

      callback.begin(ball, area, MockContact());
      verify(() => ball.layer = area.insideLayer).called(1);

      callback.end(ball, area, MockContact());
      verifyNever(() => ball.layer = Layer.board);

      callback.begin(ball, area, MockContact());
      verifyNever(() => ball.layer = area.insideLayer);

      callback.end(ball, area, MockContact());
      verify(() => ball.layer = Layer.board);
    });
  });
}
