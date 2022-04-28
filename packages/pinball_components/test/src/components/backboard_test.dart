// ignore_for_file: unawaited_futures, cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Backboard', () {
    final characterIconPath = Assets.images.dash.leaderboardIcon.keyName;
    final tester = FlameTester(() => KeyboardTestGame([characterIconPath]));

    group('on waitingMode', () {
      tester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          game.camera.zoom = 2;
          game.camera.followVector2(Vector2.zero());
          await game.ensureAdd(Backboard.waiting(position: Vector2(0, 15)));
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/backboard/waiting.png'),
          );
        },
      );
    });

    group('on gameOverMode', () {
      tester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          game.camera.zoom = 2;
          game.camera.followVector2(Vector2.zero());
          final backboard = Backboard.gameOver(
            position: Vector2(0, 15),
            score: 1000,
            characterIconPath: characterIconPath,
            onSubmit: (_) {},
          );
          await game.ensureAdd(backboard);
        },
        verify: (game, tester) async {
          final prompts =
              game.descendants().whereType<BackboardLetterPrompt>().length;
          expect(prompts, equals(3));

          final score = game.descendants().firstWhere(
                (component) =>
                    component is TextComponent && component.text == '1,000',
              );
          expect(score, isNotNull);
        },
      );

      tester.testGameWidget(
        'can change the initials',
        setUp: (game, tester) async {
          final backboard = Backboard.gameOver(
            position: Vector2(0, 15),
            score: 1000,
            characterIconPath: characterIconPath,
            onSubmit: (_) {},
          );
          await game.ensureAdd(backboard);

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
          final backboard = game
                  .descendants()
                  .firstWhere((component) => component is BackboardGameOver)
              as BackboardGameOver;

          expect(backboard.initials, equals('BCB'));
        },
      );

      String? submitedInitials;
      tester.testGameWidget(
        'submits the initials',
        setUp: (game, tester) async {
          final backboard = Backboard.gameOver(
            position: Vector2(0, 15),
            score: 1000,
            characterIconPath: characterIconPath,
            onSubmit: (value) {
              submitedInitials = value;
            },
          );
          await game.ensureAdd(backboard);

          await tester.sendKeyEvent(LogicalKeyboardKey.enter);
          await tester.pump();
        },
        verify: (game, tester) async {
          expect(submitedInitials, equals('AAA'));
        },
      );
    });
  });

  group('BackboardLetterPrompt', () {
    final tester = FlameTester(KeyboardTestGame.new);

    tester.testGameWidget(
      'cycles the char up and down when it has focus',
      setUp: (game, tester) async {
        await game.ensureAdd(
          BackboardLetterPrompt(hasFocus: true, position: Vector2.zero()),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
      },
      verify: (game, tester) async {
        final prompt = game.firstChild<BackboardLetterPrompt>();
        expect(prompt?.char, equals('C'));
      },
    );

    tester.testGameWidget(
      "does nothing when it doesn't have focus",
      setUp: (game, tester) async {
        await game.ensureAdd(
          BackboardLetterPrompt(position: Vector2.zero()),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
      },
      verify: (game, tester) async {
        final prompt = game.firstChild<BackboardLetterPrompt>();
        expect(prompt?.char, equals('A'));
      },
    );

    tester.testGameWidget(
      'blinks the prompt when it has the focus',
      setUp: (game, tester) async {
        await game.ensureAdd(
          BackboardLetterPrompt(position: Vector2.zero(), hasFocus: true),
        );
      },
      verify: (game, tester) async {
        final underscore = game.descendants().whereType<ShapeComponent>().first;
        expect(underscore.paint.color, Colors.white);

        game.update(2);
        expect(underscore.paint.color, Colors.transparent);
      },
    );
  });
}
