// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class MockSparkyRampArea extends Mock implements SparkyRampOpening {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('SparkyRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = SparkyRamp(
          position: Vector2.zero(),
        );
        await game.ready();
        await game.ensureAdd(ramp);

        expect(game.contains(ramp), isTrue);
      },
    );

    group('constructor', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final ramp = SparkyRamp(
            position: position,
          );
          await game.ensureAdd(ramp);

          expect(ramp.position, equals(position));
        },
      );
    });

    group('children', () {
      flameTester.test(
        'has only one Pathway.arc',
        (game) async {
          final ramp = SparkyRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(ramp);

          expect(
            () => ramp.children.singleWhere(
              (component) => component is Pathway,
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test(
        'has a two sensors for the ramp',
        (game) async {
          final ramp = SparkyRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(ramp);

          final rampAreas =
              ramp.children.whereType<SparkyRampOpening>().toList();
          expect(rampAreas.length, 2);
        },
      );
    });
  });

  group('SparkyRampArea', () {
    flameTester.test(
      'orientation is down',
      (game) async {
        final position = Vector2.all(10);
        final ramp = SparkyRampOpening(
          position: position,
          orientation: RampOrientation.down,
        );
        await game.ready();
        await game.ensureAdd(ramp);

        expect(ramp.orientation, RampOrientation.down);
      },
    );
  });

  group('SparkyRampAreaCallback', () {
    test('has no ball inside on creation', () {
      expect(
          SparkyRampOpeningBallContactCallback().ballsInside, equals(<Ball>{}));
    });
  });
}
