// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.spaceship.ramp.boardOpening.keyName,
    Assets.images.spaceship.ramp.railingForeground.keyName,
    Assets.images.spaceship.ramp.railingBackground.keyName,
    Assets.images.spaceship.ramp.main.keyName,
    Assets.images.spaceship.ramp.arrow.inactive.keyName,
    Assets.images.spaceship.ramp.arrow.active1.keyName,
    Assets.images.spaceship.ramp.arrow.active2.keyName,
    Assets.images.spaceship.ramp.arrow.active3.keyName,
    Assets.images.spaceship.ramp.arrow.active4.keyName,
    Assets.images.spaceship.ramp.arrow.active5.keyName,
    Assets.images.spaceship.rail.main.keyName,
    Assets.images.spaceship.rail.exit.keyName,
    Assets.images.androidBumper.a.lit.keyName,
    Assets.images.androidBumper.a.dimmed.keyName,
    Assets.images.androidBumper.b.lit.keyName,
    Assets.images.androidBumper.b.dimmed.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('AndroidAcres', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.addFromBlueprint(AndroidAcres());
        await game.ready();
      },
    );

    group('loads', () {
      flameTester.test(
        'a Spaceship',
        (game) async {
          expect(
            AndroidAcres().blueprints.whereType<Spaceship>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'a SpaceshipRamp',
        (game) async {
          expect(
            AndroidAcres().blueprints.whereType<SpaceshipRamp>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'a SpaceshipRail',
        (game) async {
          expect(
            AndroidAcres().blueprints.whereType<SpaceshipRail>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'two AndroidBumper',
        (game) async {
          final androidZone = AndroidAcres();
          await game.addFromBlueprint(androidZone);
          await game.ready();

          expect(
            game.descendants().whereType<AndroidBumper>().length,
            equals(2),
          );
        },
      );
    });
  });
}
