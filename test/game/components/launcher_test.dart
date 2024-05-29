// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.launchRamp.ramp.keyName,
      Assets.images.launchRamp.backgroundRailing.keyName,
      Assets.images.launchRamp.foregroundRailing.keyName,
      Assets.images.flapper.backSupport.keyName,
      Assets.images.flapper.frontSupport.keyName,
      Assets.images.flapper.flap.keyName,
      Assets.images.plunger.plunger.keyName,
      Assets.images.plunger.rocket.keyName,
    ]);
  }

  Future<void> pump(Launcher launchRamp) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [launchRamp],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('Launcher', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = Launcher();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Launcher>().length, equals(1));
      },
    );

    group('loads', () {
      flameTester.testGameWidget(
        'a LaunchRamp',
        setUp: (game, _) async {
          final component = Launcher();
          await game.pump(component);
        },
        verify: (game, _) async {
          final descendantsQuery = game
              .descendants()
              .whereType<Launcher>()
              .single
              .descendants()
              .whereType<LaunchRamp>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.testGameWidget(
        'a Flapper',
        setUp: (game, _) async {
          final component = Launcher();
          await game.pump(component);
        },
        verify: (game, _) async {
          final launcher = game.descendants().whereType<Launcher>().single;
          final descendantsQuery = launcher.descendants().whereType<Flapper>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.testGameWidget(
        'a Plunger',
        setUp: (game, _) async {
          final component = Launcher();
          await game.pump(component);
        },
        verify: (game, _) async {
          final launcher = game.descendants().whereType<Launcher>().single;

          final descendantsQuery = launcher.descendants().whereType<Plunger>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.testGameWidget(
        'a RocketSpriteComponent',
        setUp: (game, _) async {
          final component = Launcher();
          await game.pump(component);
        },
        verify: (game, _) async {
          final launcher = game.descendants().whereType<Launcher>().single;

          final descendantsQuery =
              launcher.descendants().whereType<RocketSpriteComponent>();
          expect(descendantsQuery.length, equals(1));
        },
      );
    });
  });
}
