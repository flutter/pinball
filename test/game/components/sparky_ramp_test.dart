// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class MockLauncherRampArea extends Mock implements LauncherRampOpening {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('LauncherRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = LauncherRamp(
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
          final ramp = LauncherRamp(
            position: position,
          );
          await game.ensureAdd(ramp);

          expect(ramp.position, equals(position));
        },
      );
    });

    group('children', () {
      flameTester.test(
        'has two Pathway',
        (game) async {
          final ramp = LauncherRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(ramp);

          final pathways = ramp.children.whereType<Pathway>().toList();
          expect(pathways.length, 2);
        },
      );

      flameTester.test(
        'has a two sensors for the ramp',
        (game) async {
          final ramp = LauncherRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(ramp);

          final rampAreas =
              ramp.children.whereType<LauncherRampOpening>().toList();
          expect(rampAreas.length, 2);
        },
      );
    });
  });

  group('LauncherRampOpening', () {
    flameTester.test(
      'orientation is down',
      (game) async {
        final position = Vector2.all(10);
        final ramp = LauncherRampOpening(
          position: position,
          orientation: RampOrientation.down,
        );
        await game.ready();
        await game.ensureAdd(ramp);

        expect(ramp.orientation, RampOrientation.down);
      },
    );
  });

  group('LauncherRampOpeningBallContactCallback', () {
    test('has no ball inside on creation', () {
      expect(
        LauncherRampOpeningBallContactCallback().ballsInside,
        equals(<Ball>{}),
      );
    });
  });
}
