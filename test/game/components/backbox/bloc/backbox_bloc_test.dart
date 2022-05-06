// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

void main() {
  late LeaderboardRepository leaderboardRepository;

  group('BackboxBloc', () {
    blocTest<BackboxBloc, BackboxState>(
      'adds InitialsFormState on PlayerInitialsRequested',
      setUp: () {
        leaderboardRepository = _MockLeaderboardRepository();
      },
      build: () => BackboxBloc(leaderboardRepository: leaderboardRepository),
      act: (bloc) => bloc.add(
        PlayerInitialsRequested(
          score: 100,
          character: AndroidTheme(),
        ),
      ),
      expect: () => [
        InitialsFormState(score: 100, character: AndroidTheme()),
      ],
    );

    group('PlayerInitialsSubmitted', () {
      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, InitialsSuccessState] when submission succeeds',
        setUp: () {
          leaderboardRepository = _MockLeaderboardRepository();
          when(
            () => leaderboardRepository.addLeaderboardEntry(
              LeaderboardEntryData(
                playerInitials: 'AAA',
                score: 10,
                character: CharacterType.dash,
              ),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => BackboxBloc(leaderboardRepository: leaderboardRepository),
        act: (bloc) => bloc.add(
          PlayerInitialsSubmitted(
            score: 10,
            initials: 'AAA',
            character: DashTheme(),
          ),
        ),
        expect: () => [
          LoadingState(),
          InitialsSuccessState(),
        ],
      );

      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, InitialsFailureState] when submission fails',
        setUp: () {
          leaderboardRepository = _MockLeaderboardRepository();
          when(
            () => leaderboardRepository.addLeaderboardEntry(
              LeaderboardEntryData(
                playerInitials: 'AAA',
                score: 10,
                character: CharacterType.dash,
              ),
            ),
          ).thenThrow(Exception('Error'));
        },
        build: () => BackboxBloc(leaderboardRepository: leaderboardRepository),
        act: (bloc) => bloc.add(
          PlayerInitialsSubmitted(
            score: 10,
            initials: 'AAA',
            character: DashTheme(),
          ),
        ),
        expect: () => [
          LoadingState(),
          InitialsFailureState(),
        ],
      );
    });

    group('LeaderboardRequested', () {
      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, LeaderboardSuccessState] when request succeeds',
        setUp: () {
          leaderboardRepository = _MockLeaderboardRepository();
          when(
            () => leaderboardRepository.fetchTop10Leaderboard(),
          ).thenAnswer(
            (_) async => [LeaderboardEntryData.empty],
          );
        },
        build: () => BackboxBloc(leaderboardRepository: leaderboardRepository),
        act: (bloc) => bloc.add(LeaderboardRequested()),
        expect: () => [
          LoadingState(),
          LeaderboardSuccessState(entries: const [LeaderboardEntryData.empty]),
        ],
      );

      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, LeaderboardFailureState] when request fails',
        setUp: () {
          leaderboardRepository = _MockLeaderboardRepository();
          when(
            () => leaderboardRepository.fetchTop10Leaderboard(),
          ).thenThrow(Exception('Error'));
        },
        build: () => BackboxBloc(leaderboardRepository: leaderboardRepository),
        act: (bloc) => bloc.add(LeaderboardRequested()),
        expect: () => [
          LoadingState(),
          LeaderboardFailureState(),
        ],
      );
    });
  });
}
