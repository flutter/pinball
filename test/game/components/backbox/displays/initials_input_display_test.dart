// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/bloc/game_bloc.dart';
import 'package:pinball/game/components/backbox/displays/initials_input_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame with HasKeyboardHandlerComponents {
  final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = '';
    await images.loadAll(
      [
        characterIconPath,
        Assets.images.backbox.displayDivider.keyName,
      ],
    );
  }

  Future<void> pump(InitialsInputDisplay component) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [
          FlameProvider.value(
            _MockAppLocalizations(),
            children: [component],
          ),
        ],
      ),
    );
  }
}

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

  final flameTester = FlameTester(_TestGame.new);

  group('InitialsInputDisplay', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final component = InitialsInputDisplay(
          score: 0,
          characterIconPath: game.characterIconPath,
          onSubmit: (_) {},
        );
        await game.pump(component);
        expect(game.descendants(), contains(component));
      },
    );

    flameTester.testGameWidget(
      'can change the initials',
      setUp: (game, tester) async {
        await game.onLoad();
        final component = InitialsInputDisplay(
          score: 1000,
          characterIconPath: game.characterIconPath,
          onSubmit: (_) {},
        );
        await game.pump(component);

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
        final component =
            game.descendants().whereType<InitialsInputDisplay>().single;

        expect(component.initials, equals('BCB'));
      },
    );

    String? submitedInitials;
    flameTester.testGameWidget(
      'submits the initials',
      setUp: (game, tester) async {
        await game.onLoad();
        final component = InitialsInputDisplay(
          score: 1000,
          characterIconPath: game.characterIconPath,
          onSubmit: (value) {
            submitedInitials = value;
          },
        );
        await game.pump(component);

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
          await game.onLoad();
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
          await game.onLoad();
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
          await game.onLoad();
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
