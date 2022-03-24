import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/leaderboard/leaderboard.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

/// {@template leaderboard_bloc}
/// Manages leaderboard events.
///
/// Uses a [LeaderboardRepository] to request and update players participations.
/// {@endtemplate}
class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  /// {@macro leaderboard_bloc}
  LeaderboardBloc(this._leaderboardRepository)
      : super(const LeaderboardState.initial()) {
    on<Top10Fetched>(_onTop10Fetched);
    on<LeaderboardEntryAdded>(_onLeaderboardEntryAdded);
  }

  final LeaderboardRepository _leaderboardRepository;

  Future<void> _onTop10Fetched(
    Top10Fetched event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    try {
      final top10Leaderboard =
          await _leaderboardRepository.fetchTop10Leaderboard();

      final leaderboardEntries = <LeaderboardEntry>[];
      top10Leaderboard.asMap().forEach(
            (index, value) => leaderboardEntries.add(value.toEntry(index + 1)),
          );

      emit(
        state.copyWith(
          status: LeaderboardStatus.success,
          leaderboard: leaderboardEntries,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: LeaderboardStatus.error));
      addError(error);
    }
  }

  Future<void> _onLeaderboardEntryAdded(
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
    } catch (error) {
      emit(state.copyWith(status: LeaderboardStatus.error));
      addError(error);
    }
  }
}
