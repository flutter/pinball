// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/dash_bumper/behaviors/behaviors.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.dash.bumper.main.active.keyName,
      Assets.images.dash.bumper.main.inactive.keyName,
      Assets.images.dash.bumper.a.active.keyName,
      Assets.images.dash.bumper.a.inactive.keyName,
      Assets.images.dash.bumper.b.active.keyName,
      Assets.images.dash.bumper.b.inactive.keyName,
    ]);
  }

  Future<void> pump(DashBumper child) async {
    await ensureAdd(
      FlameBlocProvider<DashBumpersCubit, DashBumpersState>.value(
        value: DashBumpersCubit(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('DashBumper', () {
    flameTester.testGameWidget(
      '"main" can be added',
      setUp: (game, _) async {
        final bumper = DashBumper.main();
        await game.pump(bumper);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<DashBumper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      '"a" can be added',
      setUp: (game, _) async {
        final bumper = DashBumper.a();
        await game.pump(bumper);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<DashBumper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      '"b" can be added',
      setUp: (game, _) async {
        final bumper = DashBumper.b();
        await game.pump(bumper);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<DashBumper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'adds a DashBumperBallContactBehavior',
      setUp: (game, _) async {
        final bumper = DashBumper.a();
        await game.pump(bumper);
      },
      verify: (game, _) async {
        final bumper = game.descendants().whereType<DashBumper>().single;
        expect(
          bumper.children.whereType<DashBumperBallContactBehavior>().single,
          isNotNull,
        );
      },
    );

    group("'main' adds", () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          final component = Component();
          final bumper = DashBumper.main(
            children: [component],
          );
          await game.pump(bumper);
        },
        verify: (game, _) async {
          final bumper = game.descendants().whereType<DashBumper>().single;
          expect(bumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          final bumper = DashBumper.main();
          await game.pump(bumper);
        },
        verify: (game, _) async {
          final bumper = game.descendants().whereType<DashBumper>().single;
          expect(
            bumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );
    });

    group("'a' adds", () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          final component = Component();
          final bumper = DashBumper.a(
            children: [component],
          );
          await game.pump(bumper);
        },
        verify: (game, _) async {
          final bumper = game.descendants().whereType<DashBumper>().single;
          expect(bumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          final bumper = DashBumper.a();
          await game.pump(bumper);
        },
        verify: (game, _) async {
          final bumper = game.descendants().whereType<DashBumper>().single;
          expect(
            bumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );
    });

    group("'b' adds", () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          final component = Component();
          final bumper = DashBumper.b(
            children: [component],
          );
          await game.pump(bumper);
        },
        verify: (game, _) async {
          final bumper = game.descendants().whereType<DashBumper>().single;
          expect(bumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          final bumper = DashBumper.b();
          await game.pump(bumper);
        },
        verify: (game, _) async {
          final bumper = game.descendants().whereType<DashBumper>().single;
          expect(
            bumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );
    });

    group('SpriteGroupComponent', () {
      const mainBumperActivatedState = DashBumpersState(
        bumperSpriteStates: {
          DashBumperId.main: DashBumperSpriteState.active,
          DashBumperId.a: DashBumperSpriteState.inactive,
          DashBumperId.b: DashBumperSpriteState.inactive,
        },
      );

      group('listenWhen', () {
        flameTester.testGameWidget(
          'is true when the sprite state for the given ID has changed',
          setUp: (game, _) async {
            final bumper = DashBumper.main();
            await game.pump(bumper);
          },
          verify: (game, _) async {
            final bumper = game.descendants().whereType<DashBumper>().single;
            final listenWhen =
                bumper.firstChild<DashBumperSpriteGroupComponent>()!.listenWhen(
                      DashBumpersState.initial(),
                      mainBumperActivatedState,
                    );

            expect(listenWhen, isTrue);
          },
        );

        flameTester.testGameWidget(
          'onNewState updates the current sprite',
          setUp: (game, _) async {
            final bumper = DashBumper.main();
            await game.pump(bumper);
            await game.ready();
          },
          verify: (game, _) async {
            final bumper = game.descendants().whereType<DashBumper>().single;
            final spriteGroupComponent =
                bumper.firstChild<DashBumperSpriteGroupComponent>()!;
            final originalSprite = spriteGroupComponent.current;
            spriteGroupComponent.onNewState(mainBumperActivatedState);
            game.update(0);
            final newSprite = spriteGroupComponent.current;
            expect(newSprite, isNot(equals(originalSprite)));
          },
        );
      });
    });
  });
}
