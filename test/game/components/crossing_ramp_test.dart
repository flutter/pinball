// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class FakeRampArea extends RampArea {
  FakeRampArea({
    required Vector2 position,
    required RampOrientation orientation,
    required int categoryBits,
  })  : _orientation = orientation,
        super(position: position, categoryBits: categoryBits);

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

class FakeRampAreaCallback extends RampAreaCallback<FakeRampArea> {
  FakeRampAreaCallback() : super();

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
        final ramp = FakeRampArea(
          position: Vector2.zero(),
          orientation: RampOrientation.down,
          categoryBits: RampType.all.maskBits,
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
          final ramp = FakeRampArea(
            position: position,
            orientation: RampOrientation.down,
            categoryBits: RampType.all.maskBits,
          );
          await game.ensureAdd(ramp);

          game.contains(ramp);
          expect(ramp.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final ramp = FakeRampArea(
            position: Vector2.zero(),
            orientation: RampOrientation.down,
            categoryBits: RampType.all.maskBits,
          );
          await game.ensureAdd(ramp);

          expect(ramp.body.bodyType, equals(BodyType.static));
        },
      );

      group('fixtures', () {
        flameTester.test(
          'has only one shape',
          (game) async {
            final ramp = FakeRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              categoryBits: RampType.all.maskBits,
            );
            await game.ensureAdd(ramp);

            expect(ramp.body.fixtures.length, 1);

            for (final fixture in ramp.body.fixtures) {
              expect(fixture, isA<Fixture>());
              expect(fixture.shape, isA<PolygonShape>());
            }
          },
        );
        flameTester.test(
          'is sensor',
          (game) async {
            final ramp = FakeRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              categoryBits: RampType.all.maskBits,
            );
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures.first;
            expect(fixture.isSensor, isTrue);
          },
        );

        flameTester.test(
          'sets correctly filter categoryBits ',
          (game) async {
            const maskBits = 1234;
            final ramp = FakeRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
              categoryBits: maskBits,
            );
            await game.ready();
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures.first;
            expect(
              fixture.filterData.categoryBits,
              equals(maskBits),
            );
          },
        );
      });
    });
  });

  group('RampAreaCallback', () {
    const categoryBits = 1234;

    test(
        'a ball enters from bottom into a down oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', () {
      final ball = MockBall();
      final body = MockBody();
      final area = FakeRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        categoryBits: categoryBits,
      );
      final callback = FakeRampAreaCallback();

      when(() => body.position).thenReturn(Vector2(0, 20));
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.setMaskBits(categoryBits)).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.setMaskBits(RampType.all.maskBits));
    });

    test(
        'a ball enters from up into an up oriented path and keeps inside, '
        'is saved into collection and set maskBits to path', () {
      final ball = MockBall();
      final body = MockBody();
      final area = FakeRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.up,
        categoryBits: categoryBits,
      );
      final callback = FakeRampAreaCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.setMaskBits(categoryBits)).called(1);

      callback.end(ball, area, MockContact());

      verifyNever(() => ball.setMaskBits(RampType.all.maskBits));
    });

    test(
        'a ball enters into a down oriented path but falls again outside, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = FakeRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        categoryBits: categoryBits,
      );
      final callback = FakeRampAreaCallback();

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);
      expect(callback._ballsInside.isEmpty, isTrue);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.length, equals(1));
      expect(callback._ballsInside.first, ball);
      verify(() => ball.setMaskBits(categoryBits)).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.setMaskBits(RampType.all.maskBits));
    });

    test(
        'a ball exits from inside a down oriented path, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = FakeRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.down,
        categoryBits: categoryBits,
      );
      final callback = FakeRampAreaCallback()..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2.zero());
      when(() => ball.body).thenReturn(body);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.isEmpty, isTrue);
      verify(() => ball.setMaskBits(RampType.all.maskBits)).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.setMaskBits(RampType.all.maskBits)).called(1);
    });

    test(
        'a ball exits from inside an up oriented path, '
        'is removed from collection and set maskBits to collide all', () {
      final ball = MockBall();
      final body = MockBody();
      final area = FakeRampArea(
        position: Vector2(0, 10),
        orientation: RampOrientation.up,
        categoryBits: categoryBits,
      );
      final callback = FakeRampAreaCallback()..ballsInside.add(ball);

      when(() => body.position).thenReturn(Vector2(0, 20));
      when(() => ball.body).thenReturn(body);

      callback.begin(ball, area, MockContact());

      expect(callback._ballsInside.isEmpty, isTrue);
      verify(() => ball.setMaskBits(RampType.all.maskBits)).called(1);

      callback.end(ball, area, MockContact());

      verify(() => ball.setMaskBits(RampType.all.maskBits)).called(1);
    });
  });
}
