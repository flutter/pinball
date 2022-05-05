// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/initials_input_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get score => '';

  @override
  String get name => '';

  @override
  String get enterInitials => '';

  @override
  String get arrows => '';

  @override
  String get andPress => '';

  @override
  String get enterReturn => '';

  @override
  String get toSubmit => '';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;
  final assets = [
    characterIconPath,
    Assets.images.backbox.displayDivider.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyKeyboardPinballTestGame(
      assets: assets,
      l10n: _MockAppLocalizations(),
    ),
  );

  group('InitialsInputDisplay', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final initialsInputDisplay = InitialsInputDisplay(
          score: 0,
          characterIconPath: characterIconPath,
          onSubmit: (_) {},
        );
        await game.ensureAdd(initialsInputDisplay);

        expect(game.children, contains(initialsInputDisplay));
      },
    );

    flameTester.testGameWidget(
      'can change the initials',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final initialsInputDisplay = InitialsInputDisplay(
          score: 1000,
          characterIconPath: characterIconPath,
          onSubmit: (_) {},
        );
        await game.ensureAdd(initialsInputDisplay);

        // Focus is on the first letter
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // Move to the next an press down again
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // One more time
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // Back to the previous and press down again
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
      },
      verify: (game, tester) async {
        final initialsInputDisplay =
            game.descendants().whereType<InitialsInputDisplay>().single;

        expect(initialsInputDisplay.initials, equals('BCB'));
      },
    );

    String? submitedInitials;
    flameTester.testGameWidget(
      'submits the initials',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
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

    group('BackboardLetterPrompt', () {
      flameTester.testGameWidget(
        'cycles the char up and down when it has focus',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            InitialsLetterPrompt(hasFocus: true, position: Vector2.zero()),
          );
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.pump();
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.pump();
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.pump();
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
          await tester.pump();
        },
        verify: (game, tester) async {
          final prompt = game.firstChild<InitialsLetterPrompt>();
          expect(prompt?.char, equals('C'));
        },
      );

      flameTester.testGameWidget(
        "does nothing when it doesn't have focus",
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            InitialsLetterPrompt(position: Vector2.zero()),
          );
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
          await tester.pump();
        },
        verify: (game, tester) async {
          final prompt = game.firstChild<InitialsLetterPrompt>();
          expect(prompt?.char, equals('A'));
        },
      );

      flameTester.testGameWidget(
        'blinks the prompt when it has the focus',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            InitialsLetterPrompt(position: Vector2.zero(), hasFocus: true),
          );
        },
        verify: (game, tester) async {
          final underscore =
              game.descendants().whereType<ShapeComponent>().first;
          expect(underscore.paint.color, Colors.white);

          game.update(2);
          expect(underscore.paint.color, Colors.transparent);
        },
      );
    });
  });
}
