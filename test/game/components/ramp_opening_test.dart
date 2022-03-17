// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class TestRampOpening extends RampOpening {
  TestRampOpening({
    required RampOrientation orientation,
    required Layer pathwayLayer,
  })  : _orientation = orientation,
        super(
          pathwayLayer: pathwayLayer,
        );

  final RampOrientation _orientation;

  @override
  RampOrientation get orientation => _orientation;

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
  final flameTester = FlameTester(PinballGameTest.create);

  group('RampOpening', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = TestRampOpening(
          orientation: RampOrientation.down,
          pathwayLayer: Layer.jetpack,
        )
          ..initialPosition = Vector2.zero()
          ..layer = Layer.board;
        await game.ready();
        await game.ensureAdd(ramp);

        expect(game.contains(ramp), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final ramp = TestRampOpening(
            orientation: RampOrientation.down,
            pathwayLayer: Layer.jetpack,
          )
            ..initialPosition = position
            ..layer = Layer.board;
          await game.ensureAdd(ramp);

          game.contains(ramp);
          expect(ramp.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final ramp = TestRampOpening(
            orientation: RampOrientation.down,
            pathwayLayer: Layer.jetpack,
          )
            ..initialPosition = Vector2.zero()
            ..layer = Layer.board;
          await game.ensureAdd(ramp);

          expect(ramp.body.bodyType, equals(BodyType.static));
        },
      );

      group('fixture', () {
        const pathwayLayer = Layer.jetpack;
        const openingLayer = Layer.opening;

        flameTester.test(
          'exists',
          (game) async {
            final ramp = TestRampOpening(
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
            )
              ..initialPosition = Vector2.zero()
              ..layer = openingLayer;
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
            )
              ..initialPosition = Vector2.zero()
              ..layer = openingLayer;
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
            )
              ..initialPosition = Vector2.zero()
              ..layer = openingLayer;
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );

        flameTester.test(
          'sets filter categoryBits correctly',
          (game) async {
            final ramp = TestRampOpening(
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
            )
              ..initialPosition = Vector2.zero()
              ..layer = openingLayer;

            await game.ready();
            await game.ensureAdd(ramp);
            // TODO(alestiago): modify once component.loaded is available.
            await ramp.mounted;

            final fixture = ramp.body.fixtures[0];
            expect(
              fixture.filterData.categoryBits,
              equals(ramp.layer.maskBits),
            );
          },
        );
      });
    });
  });

  group('RampOpeningBallContactCallback', () {
    test('has no ball inside on creation', () {
      expect(
        RampOpeningBallContactCallback<TestRampOpening>().ballsInside,
        equals(<Ball>{}),
      );
    });

    flameTester.test(
        'a ball enters from bottom into a down oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
      )
        ..initialPosition = Vector2(0, 10)
        ..layer = Layer.board;
      final callback = TestRampOpeningBallContactCallback();

      when(() => ball.body).thenReturn(body);
      when(() => body.position).thenReturn(Vector2(0, 20));

      await game.ready();
      await game.ensureAdd(area);

      expect(callback.ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback.ballsInside.length, equals(1));
      expect(callback.ballsInside.first, ball);
      verify(() => ball.layer = Layer.jetpack).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.layer = Layer.board);
    });

    flameTester.test(
        'a ball enters from up into an up oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.up,
        pathwayLayer: Layer.jetpack,
      )
        ..initialPosition = Vector2(0, 10)
        ..layer = Layer.board;
      final callback = TestRampOpeningBallContactCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);

      await game.ready();
      await game.ensureAdd(area);

      expect(callback.ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback.ballsInside.length, equals(1));
      expect(callback.ballsInside.first, ball);
      verify(() => ball.layer = Layer.jetpack).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.layer = Layer.board);
    });

    flameTester.test(
        'a ball enters into a down oriented path but falls again outside, '
        'is removed from collection and set maskBits to collide all',
        (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
      )
        ..initialPosition = Vector2(0, 10)
        ..layer = Layer.board;
      final callback = TestRampOpeningBallContactCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);

      await game.ready();
      await game.ensureAdd(area);

      expect(callback.ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback.ballsInside.length, equals(1));
      expect(callback.ballsInside.first, ball);
      verify(() => ball.layer = Layer.jetpack).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.layer = Layer.board);
    });

    flameTester.test(
        'a ball exits from inside a down oriented path, '
        'is removed from collection and set maskBits to collide all',
        (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
      )
        ..initialPosition = Vector2(0, 10)
        ..layer = Layer.board;
      final callback = TestRampOpeningBallContactCallback()
        ..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);

      await game.ready();
      await game.ensureAdd(area);

      callback.begin(ball, area, MockContact());

      expect(callback.ballsInside.isEmpty, isTrue);
      verify(() => ball.layer = Layer.board).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.layer = Layer.board).called(1);
    });

    flameTester.test(
        'a ball exits from inside an up oriented path, '
        'is removed from collection and set maskBits to collide all',
        (game) async {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        orientation: RampOrientation.up,
        pathwayLayer: Layer.jetpack,
      )
        ..initialPosition = Vector2(0, 10)
        ..layer = Layer.board;
      final callback = TestRampOpeningBallContactCallback()
        ..ballsInside.add(ball);

      when(() => ball.body).thenReturn(body);
      when(() => body.position).thenReturn(Vector2(0, 20));

      await game.ready();
      await game.ensureAdd(area);

      callback.begin(ball, area, MockContact());

      expect(callback.ballsInside.isEmpty, isTrue);
      verify(() => ball.layer = Layer.board).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.layer = Layer.board).called(1);
    });
  });
}
