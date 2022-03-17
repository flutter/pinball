import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchTop10Leaderboard() {
    return Future.value([]);
  }

  Future<LeaderboardRanking> addLeaderboardEntry(LeaderboardEntry entry) {
    return Future.value();
  }
}

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc(this._leaderboardRepository)
      : super(const LeaderboardState()) {
    on<Top10Fetched>(_onTop10Fetched);
    on<LeaderboardEntryAdded>(_onLeaderboardEntryAdded);
  }

  final LeaderboardRepository _leaderboardRepository;

  FutureOr<void> _onTop10Fetched(
    Top10Fetched event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    try {
      final top10Leaderboard =
          await _leaderboardRepository.fetchTop10Leaderboard();
      emit(
        state.copyWith(
          status: LeaderboardStatus.success,
          leaderboard: top10Leaderboard,
        ),
      );
    } catch (error, _) {
      emit(state.copyWith(status: LeaderboardStatus.error));
      addError(error);
    }
  }

  FutureOr<void> _onLeaderboardEntryAdded(
    LeaderboardEntryAdded event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    try {
      final ranking =
          await _leaderboardRepository.addLeaderboardEntry(event.entry);
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
