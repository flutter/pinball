import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball_theme/pinball_theme.dart';

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
          leaderboard: top10Leaderboard,
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

/// {@template leaderboard_entry_data}
/// A model representing a leaderboard entry containing the ranking position,
/// player's initials, score, and chosen character.
///
/// {@endtemplate}
class LeaderboardEntry {
  /// {@macro leaderboard_entry_data}
  LeaderboardEntry({
    required this.rank,
    required this.playerInitials,
    required this.score,
    required this.character,
  });

  /// Ranking position for [LeaderboardEntry].
  final String rank;

  /// Player's chosen initials for [LeaderboardEntry].
  final String playerInitials;

  /// Score for [LeaderboardEntry].
  final int score;

  /// [CharacterTheme] for [LeaderboardEntry].
  final CharacterTheme character;
}

extension on LeaderboardEntryData {
  LeaderboardEntry toEntry(int position) {
    return LeaderboardEntry(
      rank: position.toString(),
      playerInitials: playerInitials,
      score: score,
      character: character.toTheme,
    );
  }
}

/// Converts [CharacterType] to [CharacterTheme] to show on UI character theme
/// from repository.
extension CharacterTypeX on CharacterType {
  /// Conversion method to [CharacterTheme]
  CharacterTheme get toTheme {
    switch (this) {
      case CharacterType.dash:
        return const DashTheme();
      case CharacterType.sparky:
        return const SparkyTheme();
      case CharacterType.android:
        return const AndroidTheme();
      case CharacterType.dino:
        return const DinoTheme();
    }
  }
}

/// Converts [CharacterTheme] to [CharacterType] to persist at repository the
/// character theme from UI.
extension CharacterThemeX on CharacterTheme {
  /// Conversion method to [CharacterType]
  CharacterType get toType {
    switch (runtimeType) {
      case DashTheme:
        return CharacterType.dash;
      case SparkyTheme:
        return CharacterType.sparky;
      case AndroidTheme:
        return CharacterType.android;
      case DinoTheme:
        return CharacterType.dino;
      default:
        return CharacterType.dash;
    }
  }
}
