// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
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

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = AndroidAcres();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<AndroidAcres>(), isNotEmpty);
      },
    );

    group('loads', () {
      flameTester.testGameWidget(
        'an AndroidSpaceship',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<AndroidSpaceship>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'an AndroidAnimatronic',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<AndroidAnimatronic>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'a SpaceshipRamp',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SpaceshipRamp>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'a SpaceshipRail',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SpaceshipRail>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'three AndroidBumper',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<AndroidBumper>().length,
            equals(3),
          );
        },
      );

      flameTester.testGameWidget(
        'three AndroidBumpers with BumperNoiseBehavior',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          final bumpers = game.descendants().whereType<AndroidBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isA<BumperNoiseBehavior>(),
            );
          }
        },
      );

      flameTester.testGameWidget(
        'one AndroidBumper with CowBumperNoiseBehavior',
        setUp: (game, _) async {
          final component = AndroidAcres();
          await game.pump(component);
        },
        verify: (game, _) async {
          final bumpers = game.descendants().whereType<AndroidBumper>();

          expect(
            bumpers.singleWhere(
              (bumper) => bumper.firstChild<CowBumperNoiseBehavior>() != null,
            ),
            isA<AndroidBumper>(),
          );
        },
      );
    });

    flameTester.testGameWidget(
      'adds a FlameBlocProvider',
      setUp: (game, _) async {
        final component = AndroidAcres();
        await game.pump(component);
      },
      verify: (game, _) async {
        final androidAcres =
            game.descendants().whereType<AndroidAcres>().single;
        expect(
          androidAcres.children
              .whereType<
                  FlameBlocProvider<AndroidSpaceshipCubit,
                      AndroidSpaceshipState>>()
              .single,
          isNotNull,
        );
      },
    );

    flameTester.testGameWidget(
      'adds an AndroidSpaceshipBonusBehavior',
      setUp: (game, _) async {
        final component = AndroidAcres();
        await game.pump(component);
      },
      verify: (game, _) async {
        final androidAcres =
            game.descendants().whereType<AndroidAcres>().single;
        final provider = androidAcres.children
            .whereType<
                FlameBlocProvider<AndroidSpaceshipCubit,
                    AndroidSpaceshipState>>()
            .single;
        expect(
          provider.children.whereType<AndroidSpaceshipBonusBehavior>().single,
          isNotNull,
        );
      },
    );
  });
}
