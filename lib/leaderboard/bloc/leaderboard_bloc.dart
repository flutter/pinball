import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardRepository {
  Future<List<Competitor>> fetchRanking() {
    return Future.value([]);
  }
}

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc(this._leaderboardRepository)
      : super(const LeaderboardState()) {
    on<LeaderboardRequested>(_onLeaderboardRequested);
  }

  final LeaderboardRepository _leaderboardRepository;

  FutureOr<void> _onLeaderboardRequested(
    LeaderboardRequested event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    try {
      final ranking = await _leaderboardRepository.fetchRanking();
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
