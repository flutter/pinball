// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class TestRampArea extends RampOpening {
  TestRampArea({
    required Vector2 position,
    required RampOrientation orientation,
    required RampType layer,
  })  : _orientation = orientation,
        super(position: position, layer: layer);

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

class TestRampAreaCallback
    extends RampOpeningBallContactCallback<TestRampArea> {
  TestRampAreaCallback() : super();

  final _ballsInside = <Ball>{};

  @override
  Set get ballsInside => _ballsInside;
}

void main() {
  group('RampType', () {
    test('has three values', () {
      expect(RampType.values.length, equals(3));
    });
  });

  group('RampTypeX', () {
    test('all type has default maskBits', () {
      expect(RampType.all.maskBits, equals(Filter().maskBits));
    });

    test('jetpack type has 0x010 maskBits', () {
      expect(RampType.jetpack.maskBits, equals(0x010));
    });

    test('sparky type has 0x0100 maskBits', () {
      expect(RampType.sparky.maskBits, equals(0x0100));
    });
  });

  group('RampArea', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = TestRampArea(
          position: Vector2.zero(),
          orientation: RampOrientation.down,
          layer: RampType.all,
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
          final ramp = TestRampArea(
            position: position,
            orientation: RampOrientation.down,
            layer: RampType.all,
          );
          await game.ensureAdd(ramp);

          game.contains(ramp);
          expect(ramp.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final ramp = TestRampArea(
            position: Vector2.zero(),
            orientation: RampOrientation.down,
            layer: RampType.all,
          );
          await game.ensureAdd(ramp);

          expect(ramp.body.bodyType, equals(BodyType.static));
        },
      );

      group('fixtures', () {
        const layer = RampType.jetpack;

        flameTester.test(
          'exists',
          (game) async {
            final ramp = TestRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              layer: layer,
            );
            await game.ensureAdd(ramp);

            expect(ramp.body.fixtures[0], isA<Fixture>());
          },
        );

        flameTester.test(
          'shape is a polygon',
          (game) async {
            final ramp = TestRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              layer: layer,
            );
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.shape.shapeType, equals(ShapeType.polygon));
          },
        );

        flameTester.test(
          'is sensor',
          (game) async {
            final ramp = TestRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              layer: layer,
            );
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(fixture.isSensor, isTrue);
          },
        );

        flameTester.test(
          'sets filter categoryBits correctly',
          (game) async {
            final ramp = TestRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              layer: layer,
            );

            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures[0];
            expect(
              fixture.filterData.categoryBits,
              equals(layer.maskBits),
            );
          },
        );
      });
    });
  });

  group('RampAreaCallback', () {
    const layer = RampType.jetpack;

    test(
        'a ball enters from bottom into a down oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        layer: layer,
      );
      final callback = TestRampAreaCallback();

      when(() => body.position).thenReturn(Vector2(0, 20));
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.setLayer(layer)).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.setLayer(RampType.all));
    });

    test(
        'a ball enters from up into an up oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.up,
        layer: layer,
      );
      final callback = TestRampAreaCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.setLayer(layer)).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.setLayer(RampType.all));
    });

    test(
        'a ball enters into a down oriented path but falls again outside, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        layer: layer,
      );
      final callback = TestRampAreaCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.setLayer(layer)).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.setLayer(RampType.all));
    });

    test(
        'a ball exits from inside a down oriented path, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        layer: layer,
      );
      final callback = TestRampAreaCallback()..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.isEmpty, isTrue);
      verify(() => ball.setLayer(RampType.all)).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.setLayer(RampType.all)).called(1);
    });

    test(
        'a ball exits from inside an up oriented path, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = TestRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.up,
        layer: layer,
      );
      final callback = TestRampAreaCallback()..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2(0, 20));
      when(() => ball.body).thenReturn(body);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.isEmpty, isTrue);
      verify(() => ball.setLayer(RampType.all)).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.setLayer(RampType.all)).called(1);
    });
  });
}
