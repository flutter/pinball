// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball_theme/pinball_theme.dart';

class MockLeaderboardRepository extends Mock implements LeaderboardRepository {}

void main() {
  group('LeaderboardBloc', () {
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      leaderboardRepository = MockLeaderboardRepository();
    });

    test('initial state has state loading and empty ranking', () {
      final bloc = LeaderboardBloc(leaderboardRepository);
      expect(bloc.state.status, equals(LeaderboardStatus.loading));
      expect(bloc.state.ranking.isEmpty, isTrue);
    });

    group('LeaderboardRequested', () {
      final ranking = <Competitor>[
        Competitor(
          rank: 1,
          characterTheme: DashTheme(),
          initials: 'ABC',
          score: 100,
        ),
        Competitor(
          rank: 2,
          characterTheme: SparkyTheme(),
          initials: 'DEF',
          score: 200,
        ),
        Competitor(
          rank: 3,
          characterTheme: AndroidTheme(),
          initials: 'GHI',
          score: 300,
        ),
        Competitor(
          rank: 4,
          characterTheme: DinoTheme(),
          initials: 'JKL',
          score: 400,
        ),
      ];

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [loading, success] statuses '
        'when fetchRanking succeeds',
        setUp: () {
          when(() => leaderboardRepository.fetchRanking()).thenAnswer(
            (_) async => ranking,
          );
        },
        build: () => LeaderboardBloc(leaderboardRepository),
        act: (bloc) => bloc.add(LeaderboardRequested()),
        expect: () => [
          const LeaderboardState(),
          isA<LeaderboardState>()
            ..having(
              (element) => element.status,
              'status',
              equals(LeaderboardStatus.success),
            )
            ..having(
              (element) => element.ranking.length,
              'ranking',
              equals(ranking.length),
            )
        ],
        verify: (_) =>
            verify(() => leaderboardRepository.fetchRanking()).called(1),
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [loading, error] statuses '
        'when fetchRanking fails',
        setUp: () {
          when(() => leaderboardRepository.fetchRanking()).thenThrow(
            Exception(),
          );
        },
        build: () => LeaderboardBloc(leaderboardRepository),
        act: (bloc) => bloc.add(LeaderboardRequested()),
        expect: () => <LeaderboardState>[
          const LeaderboardState(),
          const LeaderboardState(status: LeaderboardStatus.error),
        ],
        verify: (_) =>
            verify(() => leaderboardRepository.fetchRanking()).called(1),
        errors: () => [isA<Exception>()],
      );
    });
  });
}
