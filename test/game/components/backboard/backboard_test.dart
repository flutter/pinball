// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

void main() {
  group('Backboard', () {
    final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;
    final assets = [
      characterIconPath,
      Assets.images.backboard.marquee.keyName,
      Assets.images.backboard.displayDivider.keyName,
    ];
    final tester = FlameTester(() => EmptyPinballTestGame(assets: assets));

    tester.test(
      'loads correctly',
      (game) async {
        final backboard = Backboard();
        await game.ensureAdd(backboard);

        expect(game.children, contains(backboard));
      },
    );

    group('renders correctly', () {
      tester.testGameWidget(
        'empty',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          game.camera.zoom = 6;
          game.camera.followVector2(Vector2(0, -130));
          await game.ensureAdd(Backboard());
          await game.ready();
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<EmptyPinballTestGame>(),
            matchesGoldenFile('../golden/backboard/empty.png'),
          );
        },
      );

      tester.testGameWidget(
        'on initialsInput',
        setUp: (game, tester) async {
          await game.mounted;
          await game.images.loadAll(assets);
          game.camera.zoom = 2;
          game.camera.followVector2(Vector2.zero());
          final backboard = Backboard();
          await game.ensureAdd(backboard);
          await backboard.initialsInput(
            score: 1000,
            characterIconPath: characterIconPath,
            onSubmit: (_) {},
          );
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<EmptyPinballTestGame>(),
            matchesGoldenFile('../golden/backboard/initials-input.png'),
          );
        },
      );
    });
  });
}
