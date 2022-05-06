// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/bumper_noise_behavior.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
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
    ]);
  }

  Future<void> pump(AndroidAcres child) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidAcres', () {
    final flameTester = FlameTester(_TestGame.new);

    flameTester.test('loads correctly', (game) async {
      final component = AndroidAcres();
      await game.pump(component);
      expect(game.descendants(), contains(component));
    });

    group('loads', () {
      flameTester.test(
        'an  AndroidSpaceship',
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidSpaceship>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'an AndroidAnimatronic',
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidAnimatronic>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a SpaceshipRamp',
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<SpaceshipRamp>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a SpaceshipRail',
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<SpaceshipRail>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'three AndroidBumper',
        (game) async {
          await game.pump(AndroidAcres());
          expect(
            game.descendants().whereType<AndroidBumper>().length,
            equals(3),
          );
        },
      );

      flameTester.test(
        'three AndroidBumpers with BumperNoiseBehavior',
        (game) async {
          await game.pump(AndroidAcres());
          final bumpers = game.descendants().whereType<AndroidBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isNotNull,
            );
          }
        },
      );
    });

    flameTester.test('adds an AndroidSpaceshipBonusBehavior', (game) async {
      final androidAcres = AndroidAcres();
      await game.pump(androidAcres);
      expect(
        androidAcres.children.whereType<AndroidSpaceshipBonusBehavior>().single,
        isNotNull,
      );
    });
  });
}
