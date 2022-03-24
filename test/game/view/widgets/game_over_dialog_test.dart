// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('GameOverDialog', () {
    testWidgets('renders correctly', (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      await tester.pumpApp(
        const GameOverDialog(
          theme: DashTheme(),
        ),
      );

      expect(find.text(l10n.gameOver), findsOneWidget);
      expect(find.text(l10n.leaderboard), findsOneWidget);
    });

    testWidgets('tapping on leaderboard button navigates to LeaderBoardPage',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        const GameOverDialog(
          theme: DashTheme(),
        ),
        navigator: navigator,
      );

      await tester.tap(find.widgetWithText(TextButton, l10n.leaderboard));

      verify(() => navigator.push<void>(any())).called(1);
    });
  });
}
