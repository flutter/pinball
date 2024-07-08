// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    theme.Assets.images.android.background.keyName,
    theme.Assets.images.dash.background.keyName,
    theme.Assets.images.dino.background.keyName,
    theme.Assets.images.sparky.background.keyName,
  ];

  final flameTester = FlameTester(() => TestGame(assets));

  group('ArcadeBackground', () {
    test(
      'can be instantiated',
      () {
        expect(ArcadeBackground(), isA<ArcadeBackground>());
        expect(ArcadeBackground.test(), isA<ArcadeBackground>());
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final background = ArcadeBackground();
        await game.ready();
        await game.ensureAdd(background);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<ArcadeBackground>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'has only one SpriteComponent',
      setUp: (game, _) async {
        final background = ArcadeBackground();
        await game.ready();
        await game.ensureAdd(background);
      },
      verify: (game, _) async {
        final background =
            game.descendants().whereType<ArcadeBackground>().single;
        expect(
          background.descendants().whereType<SpriteComponent>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'ArcadeBackgroundSpriteComponent changes sprite onNewState',
      setUp: (game, _) async {
        final background = ArcadeBackground();
        await game.onLoad();
        await game.ready();
        await game.ensureAdd(background);
      },
      verify: (game, _) async {
        final background =
            game.descendants().whereType<ArcadeBackground>().single;
        final backgroundSprite = background
            .descendants()
            .whereType<ArcadeBackgroundSpriteComponent>()
            .single;
        final originalSprite = backgroundSprite.sprite;
        backgroundSprite.onNewState(
          const ArcadeBackgroundState(characterTheme: theme.DinoTheme()),
        );
        game.update(0);
        final newSprite = backgroundSprite.sprite;
        expect(newSprite != originalSprite, isTrue);
      },
    );
  });
}
