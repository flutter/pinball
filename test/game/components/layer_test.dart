// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class TestRampOpening extends RampOpening {
  TestRampOpening({
    required Vector2 position,
    required RampOrientation orientation,
    required Layer pathwayLayer,
    required Layer openingLayer,
  })  : _orientation = orientation,
        super(
          position: position,
          pathwayLayer: pathwayLayer,
          openingLayer: openingLayer,
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

  final _ballsInside = <Ball>{};

  @override
  Set get ballsInside => _ballsInside;
}

void main() {
  group('Layer', () {
    test('has four values', () {
      expect(Layer.values.length, equals(5));
    });
  });

  group('LayerX', () {
    test('all types are different', () {
      expect(Layer.all.maskBits, isNot(equals(Layer.board.maskBits)));
      expect(Layer.board.maskBits, isNot(equals(Layer.opening.maskBits)));
      expect(Layer.opening.maskBits, isNot(equals(Layer.jetpack.maskBits)));
      expect(Layer.jetpack.maskBits, isNot(equals(Layer.launcher.maskBits)));
      expect(Layer.launcher.maskBits, isNot(equals(Layer.board.maskBits)));
    });

    test('all type has 0xFFFF maskBits', () {
      expect(Layer.all.maskBits, equals(0xFFFF));
    });
    test('board type has 0x0001 maskBits', () {
      expect(Layer.board.maskBits, equals(0x0001));
    });

    test('opening type has 0x0007 maskBits', () {
      expect(Layer.opening.maskBits, equals(0x0007));
    });

    test('jetpack type has 0x0002 maskBits', () {
      expect(Layer.jetpack.maskBits, equals(0x0002));
    });

    test('launcher type has 0x0005 maskBits', () {
      expect(Layer.launcher.maskBits, equals(0x0005));
    });
  });

  group('RampOpening', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = TestRampOpening(
          position: Vector2.zero(),
          orientation: RampOrientation.down,
          pathwayLayer: Layer.jetpack,
          openingLayer: Layer.board,
        );
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
            position: position,
            orientation: RampOrientation.down,
            pathwayLayer: Layer.jetpack,
            openingLayer: Layer.board,
          );
          await game.ensureAdd(ramp);

          game.contains(ramp);
          expect(ramp.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final ramp = TestRampOpening(
            position: Vector2.zero(),
            orientation: RampOrientation.down,
            pathwayLayer: Layer.jetpack,
            openingLayer: Layer.board,
          );
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
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
              openingLayer: openingLayer,
            );
            await game.ensureAdd(ramp);

            expect(ramp.body.fixtures[0], isA<Fixture>());
          },
        );

        flameTester.test(
          'shape is a polygon',
          (game) async {
            final ramp = TestRampOpening(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
              openingLayer: openingLayer,
            );
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          },
        );

        flameTester.test(
          'is sensor',
          (game) async {
            final ramp = TestRampOpening(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
              openingLayer: openingLayer,
            );
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );

        flameTester.test(
          'sets filter categoryBits correctly',
          (game) async {
            final ramp = TestRampOpening(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              pathwayLayer: pathwayLayer,
              openingLayer: openingLayer,
            );

            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(
              fixture.filterData.categoryBits,
              equals(ramp.openingLayer.maskBits),
            );
          },
        );
      });
    });
  });

  group('RampOpeningBallContactCallback', () {
    test(
        'a ball enters from bottom into a down oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
        openingLayer: Layer.board,
      );
      final callback = TestRampOpeningBallContactCallback();

      when(() => body.position).thenReturn(Vector2(0, 20));
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.layer = Layer.jetpack).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.layer = Layer.board);
    });

    test(
        'a ball enters from up into an up oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        position: Vector2(0, 10),
        orientation: RampOrientation.up,
        pathwayLayer: Layer.jetpack,
        openingLayer: Layer.board,
      );
      final callback = TestRampOpeningBallContactCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.layer = Layer.jetpack).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.layer = Layer.board);
    });

    test(
        'a ball enters into a down oriented path but falls again outside, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
        openingLayer: Layer.board,
      );
      final callback = TestRampOpeningBallContactCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.layer = Layer.jetpack).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.layer = Layer.board);
    });

    test(
        'a ball exits from inside a down oriented path, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        pathwayLayer: Layer.jetpack,
        openingLayer: Layer.board,
      );
      final callback = TestRampOpeningBallContactCallback()
        ..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.isEmpty, isTrue);
      verify(() => ball.layer = Layer.board).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.layer = Layer.board).called(1);
    });

    test(
        'a ball exits from inside an up oriented path, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampOpening(
        position: Vector2(0, 10),
        orientation: RampOrientation.up,
        pathwayLayer: Layer.jetpack,
        openingLayer: Layer.board,
      );
      final callback = TestRampOpeningBallContactCallback()
        ..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2(0, 20));
      when(() => ball.body).thenReturn(body);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.isEmpty, isTrue);
      verify(() => ball.layer = Layer.board).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.layer = Layer.board).called(1);
    });
  });
}
