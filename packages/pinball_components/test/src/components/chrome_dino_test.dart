// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dino.animatronic.mouth.keyName,
    Assets.images.dino.animatronic.head.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('ChromeDino', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);

        expect(game.contains(chromeDino), isTrue);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(ChromeDino());
        game.camera.followVector2(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        final sweepAnimationDuration = game
                .descendants()
                .whereType<SpriteAnimationComponent>()
                .first
                .animation!
                .totalDuration() /
            2;

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/chrome_dino/up.png'),
        );

        game.update(sweepAnimationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/chrome_dino/middle.png'),
        );

        game.update(sweepAnimationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/chrome_dino/down.png'),
        );
      },
    );

    group('swivels', () {
      flameTester.test(
        'up',
        (game) async {
          final chromeDino = ChromeDino();
          await game.ensureAdd(chromeDino);
          game.camera.followVector2(Vector2.zero());

          final sweepAnimationDuration = game
                  .descendants()
                  .whereType<SpriteAnimationComponent>()
                  .first
                  .animation!
                  .totalDuration() /
              2;
          game.update(sweepAnimationDuration * 1.5);

          expect(chromeDino.body.angularVelocity, isPositive);
        },
      );

      flameTester.test(
        'down',
        (game) async {
          final chromeDino = ChromeDino();
          await game.ensureAdd(chromeDino);
          game.camera.followVector2(Vector2.zero());

          final sweepAnimationDuration = game
                  .descendants()
                  .whereType<SpriteAnimationComponent>()
                  .first
                  .animation!
                  .totalDuration() /
              2;
          game.update(sweepAnimationDuration * 0.5);

          expect(chromeDino.body.angularVelocity, isNegative);
        },
      );
    });
  });
}
