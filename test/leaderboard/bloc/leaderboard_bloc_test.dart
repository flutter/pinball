// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/leaderboard/leaderboard.dart';

class MockLeaderboardRepository extends Mock implements LeaderboardRepository {}

void main() {
  group('LeaderboardBloc', () {
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      leaderboardRepository = MockLeaderboardRepository();
    });

    test('initial state has state loading no ranking and empty leaderboard',
        () {
      final bloc = LeaderboardBloc(leaderboardRepository);
      expect(bloc.state.status, equals(LeaderboardStatus.loading));
      expect(bloc.state.ranking.ranking, equals(0));
      expect(bloc.state.ranking.outOf, equals(0));
      expect(bloc.state.leaderboard.isEmpty, isTrue);
    });

    group('Top10Fetched', () {
      const top10Scores = [
        2500,
        2200,
        2200,
        2000,
        1800,
        1400,
        1300,
        1000,
        600,
        300,
        100,
      ];

      final top10Leaderboard = top10Scores
          .map(
            (score) => LeaderboardEntry(
              playerInitials: 'user$score',
              score: score,
              character: CharacterType.dash,
            ),
          )
          .toList();

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [loading, success] statuses '
        'when fetchTop10Leaderboard succeeds',
        setUp: () {
          when(() => leaderboardRepository.fetchTop10Leaderboard()).thenAnswer(
            (_) async => top10Leaderboard,
          );
        },
        build: () => LeaderboardBloc(leaderboardRepository),
        act: (bloc) => bloc.add(Top10Fetched()),
        expect: () => [
          LeaderboardState.initial(),
          isA<LeaderboardState>()
            ..having(
              (element) => element.status,
              'status',
              equals(LeaderboardStatus.success),
            )
            ..having(
              (element) => element.leaderboard.length,
              'leaderboard',
              equals(top10Leaderboard.length),
            )
        ],
        verify: (_) =>
            verify(() => leaderboardRepository.fetchTop10Leaderboard())
                .called(1),
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [loading, error] statuses '
        'when fetchTop10Leaderboard fails',
        setUp: () {
          when(() => leaderboardRepository.fetchTop10Leaderboard()).thenThrow(
            Exception(),
          );
        },
        build: () => LeaderboardBloc(leaderboardRepository),
        act: (bloc) => bloc.add(Top10Fetched()),
        expect: () => <LeaderboardState>[
          LeaderboardState.initial(),
          LeaderboardState.initial().copyWith(status: LeaderboardStatus.error),
        ],
        verify: (_) =>
            verify(() => leaderboardRepository.fetchTop10Leaderboard())
                .called(1),
        errors: () => [isA<Exception>()],
      );
    });

    group('LeaderboardEntryAdded', () {
      final leaderboardEntry = LeaderboardEntry(
        playerInitials: 'ABC',
        score: 1500,
        character: CharacterType.dash,
      );

      final ranking = LeaderboardRanking(ranking: 3, outOf: 4);

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [loading, success] statuses '
        'when addLeaderboardEntry succeeds',
        setUp: () {
          when(
            () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          ).thenAnswer(
            (_) async => ranking,
          );
        },
        build: () => LeaderboardBloc(leaderboardRepository),
        act: (bloc) => bloc.add(LeaderboardEntryAdded(entry: leaderboardEntry)),
        expect: () => [
          LeaderboardState.initial(),
          isA<LeaderboardState>()
            ..having(
              (element) => element.status,
              'status',
              equals(LeaderboardStatus.success),
            )
            ..having(
              (element) => element.ranking,
              'ranking',
              equals(ranking),
            )
        ],
        verify: (_) => verify(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
        ).called(1),
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [loading, error] statuses '
        'when addLeaderboardEntry fails',
        setUp: () {
          when(
            () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          ).thenThrow(
            Exception(),
          );
        },
        build: () => LeaderboardBloc(leaderboardRepository),
        act: (bloc) => bloc.add(LeaderboardEntryAdded(entry: leaderboardEntry)),
        expect: () => <LeaderboardState>[
          LeaderboardState.initial(),
          LeaderboardState.initial().copyWith(status: LeaderboardStatus.error),
        ],
        verify: (_) => verify(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
        ).called(1),
        errors: () => [isA<Exception>()],
      );
    });
  });
}
