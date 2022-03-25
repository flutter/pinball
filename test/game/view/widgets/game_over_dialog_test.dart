// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('GameOverDialog', () {
    testWidgets('renders GameOverDialogView', (tester) async {
      await tester.pumpApp(
        GameOverDialog(
          score: 1000,
          theme: DashTheme(),
        ),
      );

      expect(find.byType(GameOverDialogView), findsOneWidget);
    });

    group('GameOverDialogView', () {
      late LeaderboardBloc leaderboardBloc;

      setUp(() {
        leaderboardBloc = MockLeaderboardBloc();
      });

      testWidgets('renders input text view when bloc emits [loading]',
          (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        when(() => leaderboardBloc.state)
            .thenReturn(LeaderboardState.initial());

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: 10000,
              theme: DashTheme(),
            ),
          ),
        );

        expect(find.text(l10n.addUser), findsOneWidget);
      });

      testWidgets('renders error view when bloc emits [error]', (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardState.initial().copyWith(status: LeaderboardStatus.error),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: 10000,
              theme: DashTheme(),
            ),
          ),
        );

        expect(find.text(l10n.error), findsOneWidget);
      });

      testWidgets('renders success view when bloc emits [success]',
          (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardState(
            status: LeaderboardStatus.success,
            ranking: LeaderboardRanking(ranking: 1, outOf: 2),
            leaderboard: [
              LeaderboardEntry(
                rank: '1',
                playerInitials: 'ABC',
                score: 5000,
                character: DashTheme().characterAsset,
              ),
            ],
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: 10000,
              theme: DashTheme(),
            ),
          ),
        );

        expect(find.text(l10n.leaderboard), findsOneWidget);
      });
    });
  });
}
