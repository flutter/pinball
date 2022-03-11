// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class MockSparkyRampArea extends Mock implements SparkyRampArea {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGame.new);

  group('SparkyRamp', () {
    group('body', () {
      flameTester.test(
        'has a Pathway.arc at position',
        (game) async {
          final sparkyRamp = SparkyRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(sparkyRamp);
          game.contains(sparkyRamp);
        },
      );

      flameTester.test(
        'has a two sensors for the ramp',
        (game) async {
          final sparkyRamp = SparkyRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(sparkyRamp);

          game.contains(sparkyRamp);
        },
      );

      flameTester.test(
        'sensors and ramp are static',
        (game) async {
          final sparkyRamp = SparkyRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(sparkyRamp);

          game.contains(sparkyRamp);
        },
      );
    });
  });

  group('SparkyRampArea', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = SparkyRampArea(
          position: Vector2.zero(),
          orientation: RampOrientation.down,
        );
        await game.ensureAdd(ramp);

        expect(game.contains(ramp), isTrue);
      },
    );

    flameTester.test(
      'orientation correctly',
      (game) async {
        final position = Vector2.all(10);
        final ramp = SparkyRampArea(
          position: position,
          orientation: RampOrientation.down,
        );
        await game.ensureAdd(ramp);

        game.contains(ramp);
        expect(ramp.orientation, RampOrientation.down);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final ramp = SparkyRampArea(
            position: position,
            orientation: RampOrientation.down,
          );
          await game.ensureAdd(ramp);

          game.contains(ramp);
          expect(ramp.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final ramp = SparkyRampArea(
            position: Vector2.zero(),
            orientation: RampOrientation.down,
          );
          await game.ensureAdd(ramp);

          expect(ramp.body.bodyType, equals(BodyType.static));
        },
      );

      group('fixtures', () {
        flameTester.test(
          'has only one shape',
          (game) async {
            final ramp = SparkyRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
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
            final ramp = SparkyRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
            );
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures.first;
            expect(fixture.isSensor, isTrue);
          },
        );

        flameTester.test(
          'sets correctly filter categoryBits to RampType.sparky',
          (game) async {
            final ramp = SparkyRampArea(
              position: Vector2.zero(),
              orientation: RampOrientation.down,
            );
            await game.ready();
            await game.ensureAdd(ramp);

            final fixture = ramp.body.fixtures.first;
            expect(
              fixture.filterData.categoryBits,
              equals(RampType.sparky.maskBits),
            );
          },
        );
      });
    });
  });

  group('SparkyRampAreaCallback', () {
    test('has no ball inside on creation', () {
      expect(SparkyRampAreaCallback().ballsInside, equals(<Ball>{}));
    });
  });
}
