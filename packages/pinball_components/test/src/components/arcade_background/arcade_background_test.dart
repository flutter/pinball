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

    flameTester.test(
      'loads correctly',
      (game) async {
        final ball = ArcadeBackground();
        await game.ready();
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    flameTester.test(
      'has only one SpriteComponent',
      (game) async {
        final ball = ArcadeBackground();
        await game.ready();
        await game.ensureAdd(ball);

        expect(
          ball.descendants().whereType<SpriteComponent>().length,
          equals(1),
        );
      },
    );

    flameTester.test(
      'ArcadeBackgroundSpriteComponent changes sprite onNewState',
      (game) async {
        final ball = ArcadeBackground();
        await game.ready();
        await game.ensureAdd(ball);

        final ballSprite = ball
            .descendants()
            .whereType<ArcadeBackgroundSpriteComponent>()
            .single;
        final originalSprite = ballSprite.sprite;

        ballSprite.onNewState(
          const ArcadeBackgroundState(characterTheme: theme.DinoTheme()),
        );
        await game.ready();

        final newSprite = ballSprite.sprite;
        expect(newSprite != originalSprite, isTrue);
      },
    );
  });
}
