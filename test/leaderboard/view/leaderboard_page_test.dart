// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/view/leaderboard_page.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LeaderboardPage', () {
    testWidgets('renders LeaderboardView', (tester) async {
      await tester.pumpApp(
        LeaderboardPage(
          theme: DashTheme(),
        ),
      );

      expect(find.byType(LeaderboardView), findsOneWidget);
    });

    testWidgets('route returns a valid navigation route', (tester) async {
      await expectNavigatesToRoute<LeaderboardPage>(
        tester,
        LeaderboardPage.route(
          theme: DashTheme(),
        ),
      );
    });
  });

  group('LeaderboardView', () {
    testWidgets('renders correctly', (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      await tester.pumpApp(
        LeaderboardPage(
          theme: DashTheme(),
        ),
      );

      expect(find.text(l10n.leadersboard), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('navigates to CharacterSelectionPage when retry is tapped',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        LeaderboardPage(
          theme: DashTheme(),
        ),
        navigator: navigator,
      );
      await tester.ensureVisible(find.byType(TextButton));
      await tester.tap(find.byType(TextButton));

      verify(() => navigator.push<void>(any())).called(1);
    });
  });

  group('CharacterTypeX', () {
    test('converts CharacterType.android to AndroidTheme', () {
      expect(CharacterType.android.theme, equals(AndroidTheme()));
    });

    test('converts CharacterType.dash to DashTheme', () {
      expect(CharacterType.dash.theme, equals(DashTheme()));
    });

    test('converts CharacterType.dino to DinoTheme', () {
      expect(CharacterType.dino.theme, equals(DinoTheme()));
    });

    test('converts CharacterType.sparky to SparkyTheme', () {
      expect(CharacterType.sparky.theme, equals(SparkyTheme()));
    });
  });

  group('CharacterThemeX', () {
    test('converts AndroidTheme to CharacterType.android', () {
      expect(AndroidTheme().toType, equals(CharacterType.android));
    });

    test('converts DashTheme to CharacterType.dash', () {
      expect(DashTheme().toType, equals(CharacterType.dash));
    });

    test('converts DinoTheme to CharacterType.dino', () {
      expect(DinoTheme().toType, equals(CharacterType.dino));
    });

    test('converts SparkyTheme to CharacterType.sparky', () {
      expect(SparkyTheme().toType, equals(CharacterType.sparky));
    });
  });
}
