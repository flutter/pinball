// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class MockSparkyRampArea extends Mock implements SparkyRampArea {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('SparkyRamp', () {
    group('body', () {
      bool Function(Component) pathwaySelector(Vector2 position) =>
          (component) =>
              component is Pathway && component.body.position == position;

      flameTester.test(
        'has a Pathway.arc at position',
        (game) async {
          final position = Vector2.all(10);
          final sparkyRamp = SparkyRamp(
            position: position,
          );
          await game.ready();
          await game.ensureAdd(sparkyRamp);

          expect(
            () => sparkyRamp.children.singleWhere(
              pathwaySelector(position),
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test(
        'path is static',
        (game) async {
          final position = Vector2.all(10);
          final sparkyRamp = SparkyRamp(
            position: position,
          );
          await game.ready();
          await game.ensureAdd(sparkyRamp);

          final pathways = game.children.whereType<Pathway>().toList();
          for (final pathway in pathways) {
            expect(pathway.body.bodyType, equals(BodyType.static));
          }
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

          final rampAreas =
              sparkyRamp.children.whereType<SparkyRampArea>().toList();
          expect(rampAreas.length, 2);
        },
      );

      flameTester.test(
        'sensors are static',
        (game) async {
          final sparkyRamp = SparkyRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(sparkyRamp);

          final rampAreas =
              sparkyRamp.children.whereType<SparkyRampArea>().toList();
          for (final rampArea in rampAreas) {
            expect(rampArea.body.bodyType, equals(BodyType.static));
          }
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
        await game.ready();
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
        await game.ready();
        await game.ensureAdd(ramp);

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
          await game.ready();
          await game.ensureAdd(ramp);

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
          await game.ready();
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
            await game.ready();
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
            await game.ready();
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
