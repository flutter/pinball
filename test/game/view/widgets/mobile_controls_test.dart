import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

class _MockPinballGame extends Mock implements PinballGame {}

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpMobileControls(PinballGame game) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        home: Scaffold(
          body: MobileControls(game: game),
        ),
      ),
    );
  }
}

extension _CommonFindersX on CommonFinders {
  Finder byPinballDpadDirection(PinballDpadDirection direction) {
    return byWidgetPredicate((widget) {
      return widget is PinballDpadButton && widget.direction == direction;
    });
  }
}

void main() {
  group('MobileControls', () {
    testWidgets('renders', (tester) async {
      await tester.pumpMobileControls(_MockPinballGame());

      expect(find.byType(PinballButton), findsOneWidget);
      expect(find.byType(MobileDpad), findsOneWidget);
    });

    testWidgets('correctly triggers the arrow up', (tester) async {
      var pressed = false;
      final component = KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowUp: () => pressed = true,
        },
      );
      final game = _MockPinballGame();
      when(game.descendants).thenReturn([component]);

      await tester.pumpMobileControls(game);
      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.up));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('correctly triggers the arrow down', (tester) async {
      var pressed = false;
      final component = KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowDown: () => pressed = true,
        },
      );
      final game = _MockPinballGame();
      when(game.descendants).thenReturn([component]);

      await tester.pumpMobileControls(game);
      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.down));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('correctly triggers the arrow right', (tester) async {
      var pressed = false;
      final component = KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowRight: () => pressed = true,
        },
      );
      final game = _MockPinballGame();
      when(game.descendants).thenReturn([component]);

      await tester.pumpMobileControls(game);
      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.right));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('correctly triggers the arrow left', (tester) async {
      var pressed = false;
      final component = KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowLeft: () => pressed = true,
        },
      );
      final game = _MockPinballGame();
      when(game.descendants).thenReturn([component]);

      await tester.pumpMobileControls(game);
      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.left));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('correctly triggers the enter', (tester) async {
      var pressed = false;
      final component = KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.enter: () => pressed = true,
        },
      );
      final game = _MockPinballGame();
      when(game.descendants).thenReturn([component]);

      await tester.pumpMobileControls(game);
      await tester.tap(find.byType(PinballButton));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
