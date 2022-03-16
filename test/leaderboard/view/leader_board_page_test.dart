// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    LeaderboardPage.route(
                      theme: DashTheme(),
                    ),
                  );
                },
                child: const Text('Tap me'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(find.byType(LeaderboardPage), findsOneWidget);
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

      expect(find.text(l10n.leadersBoard), findsOneWidget);
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
}
