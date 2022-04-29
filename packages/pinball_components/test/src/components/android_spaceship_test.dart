// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AndroidSpaceship', () {
    group('Spaceship', () {
      final assets = [
        Assets.images.android.spaceship.saucer.keyName,
        Assets.images.android.spaceship.animatronic.keyName,
        Assets.images.android.spaceship.lightBeam.keyName,
      ];
      final flameTester = FlameTester(() => TestGame(assets));

      flameTester.test('loads correctly', (game) async {
        await game.addFromBlueprint(AndroidSpaceship(position: Vector2.zero()));
        await game.ready();
      });

      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game
              .addFromBlueprint(AndroidSpaceship(position: Vector2.zero()));
          game.camera.followVector2(Vector2.zero());
          await game.ready();
          await tester.pump();
        },
        verify: (game, tester) async {
          final animationDuration = game
              .descendants()
              .whereType<SpriteAnimationComponent>()
              .last
              .animation!
              .totalDuration();

          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/android_spaceship/start.png'),
          );

          game.update(animationDuration * 0.5);
          await tester.pump();
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/android_spaceship/middle.png'),
          );

          game.update(animationDuration * 0.5);
          await tester.pump();
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/android_spaceship/end.png'),
          );
        },
      );
    });
  });
}
