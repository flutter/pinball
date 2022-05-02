// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.spaceship.saucer.keyName,
    Assets.images.android.spaceship.animatronic.keyName,
    Assets.images.android.spaceship.lightBeam.keyName,
    Assets.images.android.ramp.boardOpening.keyName,
    Assets.images.android.ramp.railingForeground.keyName,
    Assets.images.android.ramp.railingBackground.keyName,
    Assets.images.android.ramp.main.keyName,
    Assets.images.android.ramp.arrow.inactive.keyName,
    Assets.images.android.ramp.arrow.active1.keyName,
    Assets.images.android.ramp.arrow.active2.keyName,
    Assets.images.android.ramp.arrow.active3.keyName,
    Assets.images.android.ramp.arrow.active4.keyName,
    Assets.images.android.ramp.arrow.active5.keyName,
    Assets.images.android.rail.main.keyName,
    Assets.images.android.rail.exit.keyName,
    Assets.images.android.bumper.a.lit.keyName,
    Assets.images.android.bumper.a.dimmed.keyName,
    Assets.images.android.bumper.b.lit.keyName,
    Assets.images.android.bumper.b.dimmed.keyName,
    Assets.images.android.bumper.cow.lit.keyName,
    Assets.images.android.bumper.cow.dimmed.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('AndroidAcres', () {
    flameTester.test('loads correctly', (game) async {
      final component = AndroidAcres();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    group('loads', () {
      flameTester.test(
        'a Spaceship',
        (game) async {
          await game.ensureAdd(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidSpaceship>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a SpaceshipRamp',
        (game) async {
          await game.ensureAdd(AndroidAcres());
          expect(
            game.descendants().whereType<SpaceshipRamp>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a SpaceshipRail',
        (game) async {
          await game.ensureAdd(AndroidAcres());
          expect(
            game.descendants().whereType<SpaceshipRail>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'three AndroidBumper',
        (game) async {
          await game.ensureAdd(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidBumper>().length,
            equals(3),
          );
        },
      );
    });
  });
}
