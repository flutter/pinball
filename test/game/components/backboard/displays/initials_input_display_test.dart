// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backboard/displays/displays.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

void main() {
  group('InitialsInputDisplay', () {
    final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;
    final assets = [
      characterIconPath,
      Assets.images.backboard.displayDivider.keyName,
    ];
    final tester = FlameTester(() => EmptyPinballTestGame(assets: assets));

    tester.testGameWidget(
      'changes the initials with arrow keys',
      setUp: (game, tester) async {
        final initialsInputDisplay = InitialsInputDisplay(
          score: 1000,
          characterIconPath: characterIconPath,
          onSubmit: (_) {},
        );
        await game.ensureAdd(initialsInputDisplay);

        // Focus is already on the first letter
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        // Move to the next an press up again
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        // One more time
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        // Back to the previous and increase one more
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
      },
      verify: (game, tester) async {
        final initialsInputDisplay =
            game.descendants().whereType<InitialsInputDisplay>().first;

        expect(initialsInputDisplay.initials, equals('BCB'));
      },
    );

    String? submitedInitials;
    tester.testGameWidget(
      'enter submits the initials',
      setUp: (game, tester) async {
        final initialsInputDisplay = InitialsInputDisplay(
          score: 1000,
          characterIconPath: characterIconPath,
          onSubmit: (value) {
            submitedInitials = value;
          },
        );
        await game.ensureAdd(initialsInputDisplay);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
      },
      verify: (game, tester) async {
        expect(submitedInitials, equals('AAA'));
      },
    );
  });
}

  // group('BackboardLetterPrompt', () {
  //   final tester = FlameTester(KeyboardTestGame.new);

  //   tester.testGameWidget(
  //     'cycles the char up and down when it has focus',
  //     setUp: (game, tester) async {
  //       await game.ensureAdd(
  //         BackboardLetterPrompt(hasFocus: true, position: Vector2.zero()),
  //       );
  //       await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
  //       await tester.pump();
  //       await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
  //       await tester.pump();
  //       await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
  //       await tester.pump();
  //       await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  //       await tester.pump();
  //     },
  //     verify: (game, tester) async {
  //       final prompt = game.firstChild<BackboardLetterPrompt>();
  //       expect(prompt?.char, equals('C'));
  //     },
  //   );

  //   tester.testGameWidget(
  //     "does nothing when it doesn't have focus",
  //     setUp: (game, tester) async {
  //       await game.ensureAdd(
  //         BackboardLetterPrompt(position: Vector2.zero()),
  //       );
  //       await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
  //       await tester.pump();
  //     },
  //     verify: (game, tester) async {
  //       final prompt = game.firstChild<BackboardLetterPrompt>();
  //       expect(prompt?.char, equals('A'));
  //     },
  //   );

  //   tester.testGameWidget(
  //     'blinks the prompt when it has the focus',
  //     setUp: (game, tester) async {
  //       await game.ensureAdd(
  //         BackboardLetterPrompt(position: Vector2.zero(), hasFocus: true),
  //       );
  //     },
  //     verify: (game, tester) async {
  //       final underscore = game.descendants().whereType<ShapeComponent>().first;
  //       expect(underscore.paint.color, Colors.white);

  //       game.update(2);
  //       expect(underscore.paint.color, Colors.transparent);
  //     },
  //   );
  // });
  
