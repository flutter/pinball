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
    flameTester.test(
      'loads correctly',
      (game) async {
        final component = Launcher();
        await game.pump(component);
        expect(game.descendants(), contains(component));
      },
    );

    group('loads', () {
      flameTester.test(
        'a LaunchRamp',
        (game) async {
          final component = Launcher();
          await game.pump(component);

          final descendantsQuery =
              component.descendants().whereType<LaunchRamp>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.test(
        'a Flapper',
        (game) async {
          final component = Launcher();
          await game.pump(component);

          final descendantsQuery = component.descendants().whereType<Flapper>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.test(
        'a Plunger',
        (game) async {
          final component = Launcher();
          await game.pump(component);

          final descendantsQuery = component.descendants().whereType<Plunger>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.test(
        'a RocketSpriteComponent',
        (game) async {
          final component = Launcher();
          await game.pump(component);

          final descendantsQuery =
              component.descendants().whereType<RocketSpriteComponent>();
          expect(descendantsQuery.length, equals(1));
        },
      );
    });
  });
}
