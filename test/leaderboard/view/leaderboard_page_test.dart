// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
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
    late LeaderboardBloc leaderboardBloc;

    setUp(() {
      leaderboardBloc = MockLeaderboardBloc();
    });

    testWidgets('renders correctly', (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      whenListen(
        leaderboardBloc,
        const Stream<LeaderboardState>.empty(),
        initialState: LeaderboardState.initial(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: leaderboardBloc,
          child: LeaderboardView(
            theme: DashTheme(),
          ),
        ),
      );

      expect(find.text(l10n.leaderboard), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('renders loading view when bloc emits [loading]',
        (tester) async {
      whenListen(
        leaderboardBloc,
        const Stream<LeaderboardState>.empty(),
        initialState: LeaderboardState.initial(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: leaderboardBloc,
          child: LeaderboardView(
            theme: DashTheme(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('There was en error loading data!'), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders error view when bloc emits [error]', (tester) async {
      whenListen(
        leaderboardBloc,
        const Stream<LeaderboardState>.empty(),
        initialState: LeaderboardState.initial().copyWith(
          status: LeaderboardStatus.error,
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: leaderboardBloc,
          child: LeaderboardView(
            theme: DashTheme(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('There was en error loading data!'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders success view when bloc emits [success]',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      whenListen(
        leaderboardBloc,
        const Stream<LeaderboardState>.empty(),
        initialState: LeaderboardState(
          status: LeaderboardStatus.success,
          ranking: LeaderboardRanking(ranking: 0, outOf: 0),
          leaderboard: [
            LeaderboardEntry(
              rank: '1',
              playerInitials: 'ABC',
              score: 10000,
              character: DashTheme().character,
            ),
          ],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: leaderboardBloc,
          child: LeaderboardView(
            theme: DashTheme(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('There was en error loading data!'), findsNothing);
      expect(find.text(l10n.rank), findsOneWidget);
      expect(find.text(l10n.character), findsOneWidget);
      expect(find.text(l10n.username), findsOneWidget);
      expect(find.text(l10n.score), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
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
