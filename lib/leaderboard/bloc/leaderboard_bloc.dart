import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc() : super(const LeaderboardState()) {
    on<LeaderboardRequested>(_onLeaderboardRequested);
  }

  FutureOr<void> _onLeaderboardRequested(
    LeaderboardRequested event,
    Emitter<LeaderboardState> emit,
  ) {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    try {
      const ranking = <Competitor>[
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

      emit(
        state.copyWith(
          status: LeaderboardStatus.success,
          ranking: ranking,
        ),
      );
    } catch (error, _) {
      emit(state.copyWith(status: LeaderboardStatus.error));
      addError(error);
    }
  }
}
