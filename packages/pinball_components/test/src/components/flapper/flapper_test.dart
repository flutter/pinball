// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/flapper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Flapper', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.flapper.flap.keyName,
      Assets.images.flapper.backSupport.keyName,
      Assets.images.flapper.frontSupport.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.test('loads correctly', (game) async {
      final component = Flapper();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final canvas = ZCanvasComponent(children: [Flapper()]);
        await game.ensureAdd(canvas);
        game.camera
          ..followVector2(Vector2(3, -70))
          ..zoom = 25;
        await tester.pump();
      },
      verify: (game, tester) async {
        const goldenFilePath = '../golden/flapper/';
        final flapSpriteAnimationComponent = game
            .descendants()
            .whereType<FlapSpriteAnimationComponent>()
            .first
          ..playing = true;
        final animationDuration =
            flapSpriteAnimationComponent.animation!.totalDuration();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('${goldenFilePath}start.png'),
        );

        game.update(animationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('${goldenFilePath}middle.png'),
        );

        game.update(animationDuration * 0.75);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('${goldenFilePath}end.png'),
        );
      },
    );

    flameTester.test('adds a FlapperSpinningBehavior to FlapperEntrance',
        (game) async {
      final flapper = Flapper();
      await game.ensureAdd(flapper);

      final flapperEntrance = flapper.firstChild<FlapperEntrance>()!;
      expect(
        flapperEntrance.firstChild<FlapperSpinningBehavior>(),
        isNotNull,
      );
    });

    flameTester.test(
      'flap stops animating after animation completes',
      (game) async {
        final flapper = Flapper();
        await game.ensureAdd(flapper);

        final flapSpriteAnimationComponent =
            flapper.firstChild<FlapSpriteAnimationComponent>()!;

        flapSpriteAnimationComponent.playing = true;
        game.update(
          flapSpriteAnimationComponent.animation!.totalDuration() + 0.1,
        );

        expect(flapSpriteAnimationComponent.playing, isFalse);
      },
    );
  });
}
