// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.launchRamp.ramp.keyName,
    Assets.images.launchRamp.backgroundRailing.keyName,
    Assets.images.launchRamp.foregroundRailing.keyName,
    Assets.images.flapper.backSupport.keyName,
    Assets.images.flapper.frontSupport.keyName,
    Assets.images.flapper.flap.keyName,
    Assets.images.plunger.plunger.keyName,
    Assets.images.plunger.rocket.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('Launcher', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final launcher = Launcher();
        await game.ensureAdd(launcher);

        expect(game.contains(launcher), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'a LaunchRamp',
        (game) async {
          final launcher = Launcher();
          await game.ensureAdd(launcher);

          final descendantsQuery =
              launcher.descendants().whereType<LaunchRamp>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.test(
        'a Flapper',
        (game) async {
          final launcher = Launcher();
          await game.ensureAdd(launcher);

          final descendantsQuery = launcher.descendants().whereType<Flapper>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.test(
        'a Plunger',
        (game) async {
          final launcher = Launcher();
          await game.ensureAdd(launcher);

          final descendantsQuery = launcher.descendants().whereType<Plunger>();
          expect(descendantsQuery.length, equals(1));
        },
      );

      flameTester.test(
        'a RocketSpriteComponent',
        (game) async {
          final launcher = Launcher();
          await game.ensureAdd(launcher);

          final descendantsQuery =
              launcher.descendants().whereType<RocketSpriteComponent>();
          expect(descendantsQuery.length, equals(1));
        },
      );
    });
  });
}
