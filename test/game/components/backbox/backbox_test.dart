// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backbox/displays/initials_input_display.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

void main() {
  group('Backbox', () {
    final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;
    final assets = [
      characterIconPath,
      Assets.images.backbox.marquee.keyName,
      Assets.images.backbox.displayDivider.keyName,
    ];
    final tester = FlameTester(() => EmptyPinballTestGame(assets: assets));

    tester.test(
      'loads correctly',
      (game) async {
        final backbox = Backbox();
        await game.ensureAdd(backbox);

        expect(game.children, contains(backbox));
      },
    );

    group('renders correctly', () {
      tester.testGameWidget(
        'empty',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          game.camera.zoom = 6;
          game.camera.followVector2(Vector2(0, -130));
          await game.ensureAdd(Backbox());
          await game.ready();
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<EmptyPinballTestGame>(),
            matchesGoldenFile('../golden/backbox/empty.png'),
          );
        },
      );
    });

    tester.test(
      'initialsInput adds InitialsInputDisplay',
      (game) async {
        final backbox = Backbox();
        await game.ensureAdd(backbox);
        await backbox.initialsInput(
          score: 0,
          characterIconPath: characterIconPath,
          onSubmit: (_) {},
        );
        await game.ready();

        expect(backbox.firstChild<InitialsInputDisplay>(), isNotNull);
      },
    );
  });
}
