// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
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

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = Flapper();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Flapper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final canvas = ZCanvasComponent(children: [Flapper()]);
        await game.world.ensureAdd(canvas);
        game.camera
          ..moveTo(Vector2(3, -70))
          ..viewfinder.zoom = 25;
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
            flapSpriteAnimationComponent.animationTicker!.totalDuration();

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

    flameTester.testGameWidget(
      'adds a FlapperSpinningBehavior to FlapperEntrance',
      setUp: (game, _) async {
        await game.onLoad();
        final flapper = Flapper();
        await game.ensureAdd(flapper);
        await game.ready();
      },
      verify: (game, _) async {
        final flapper = game.descendants().whereType<Flapper>().single;
        final flapperEntrance = flapper.firstChild<FlapperEntrance>()!;
        expect(
          flapperEntrance.firstChild<FlapperSpinningBehavior>(),
          isNotNull,
        );
      },
    );

    flameTester.testGameWidget(
      'flap stops animating after animation completes',
      setUp: (game, _) async {
        await game.onLoad();
        final flapper = Flapper();
        await game.ensureAdd(flapper);
        await game.ready();
      },
      verify: (game, _) async {
        final flapper = game.descendants().whereType<Flapper>().single;

        final flapSpriteAnimationComponent = flapper
            .descendants()
            .whereType<FlapSpriteAnimationComponent>()
            .single;

        flapSpriteAnimationComponent.playing = true;
        game.update(
          flapSpriteAnimationComponent.animationTicker!.totalDuration() + 0.1,
        );

        expect(flapSpriteAnimationComponent.playing, isFalse);
      },
    );
  });
}
