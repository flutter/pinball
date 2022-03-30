// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
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

      final leaderboard = [
        LeaderboardEntry(
          rank: '1',
          playerInitials: 'ABC',
          score: 5000,
          character: DashTheme().characterAsset,
        ),
      ];
      final entryData = LeaderboardEntryData(
        playerInitials: 'VGV',
        score: 10000,
        character: CharacterType.dash,
      );

      setUp(() {
        leaderboardBloc = MockLeaderboardBloc();
        whenListen(
          leaderboardBloc,
          const Stream<LeaderboardState>.empty(),
          initialState: const LeaderboardState.initial(),
        );
      });

      testWidgets('renders input text view when bloc emits [loading]',
          (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: entryData.score,
              theme: entryData.character.toTheme,
            ),
          ),
        );

        expect(find.widgetWithText(TextButton, l10n.addUser), findsOneWidget);
      });

      testWidgets('renders error view when bloc emits [error]', (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        whenListen(
          leaderboardBloc,
          const Stream<LeaderboardState>.empty(),
          initialState: LeaderboardState.initial()
              .copyWith(status: LeaderboardStatus.error),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: entryData.score,
              theme: entryData.character.toTheme,
            ),
          ),
        );

        expect(find.text(l10n.error), findsOneWidget);
      });

      testWidgets('renders success view when bloc emits [success]',
          (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        whenListen(
          leaderboardBloc,
          const Stream<LeaderboardState>.empty(),
          initialState: LeaderboardState(
            status: LeaderboardStatus.success,
            ranking: LeaderboardRanking(ranking: 1, outOf: 2),
            leaderboard: leaderboard,
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: entryData.score,
              theme: entryData.character.toTheme,
            ),
          ),
        );

        expect(
          find.widgetWithText(TextButton, l10n.leaderboard),
          findsOneWidget,
        );
      });

      testWidgets('adds LeaderboardEntryAdded when tap on add user button',
          (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        whenListen(
          leaderboardBloc,
          const Stream<LeaderboardState>.empty(),
          initialState: LeaderboardState.initial(),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: entryData.score,
              theme: entryData.character.toTheme,
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('player_initials_text_field')),
          entryData.playerInitials,
        );

        final button = find.widgetWithText(TextButton, l10n.addUser);
        await tester.ensureVisible(button);
        await tester.tap(button);

        verify(
          () => leaderboardBloc.add(LeaderboardEntryAdded(entry: entryData)),
        ).called(1);
      });

      testWidgets('navigates to LeaderboardPage when tap on leaderboard button',
          (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));
        final navigator = MockNavigator();
        when(() => navigator.push<void>(any())).thenAnswer((_) async {});
        whenListen(
          leaderboardBloc,
          const Stream<LeaderboardState>.empty(),
          initialState: LeaderboardState(
            status: LeaderboardStatus.success,
            ranking: LeaderboardRanking(ranking: 1, outOf: 2),
            leaderboard: leaderboard,
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: leaderboardBloc,
            child: GameOverDialogView(
              score: entryData.score,
              theme: entryData.character.toTheme,
            ),
          ),
          navigator: navigator,
        );

        final button = find.widgetWithText(TextButton, l10n.leaderboard);
        await tester.ensureVisible(button);
        await tester.tap(button);

        verify(() => navigator.push<void>(any())).called(1);
      });
    });
  });
}
