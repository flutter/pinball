import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/leaderboard/models/leader_board_entry.dart';
import 'package:pinball_theme/pinball_theme.dart';

part 'backbox_event.dart';
part 'backbox_state.dart';

/// {@template backbox_bloc}
/// Bloc which manages the Backbox display.
/// {@endtemplate}
class BackboxBloc extends Bloc<BackboxEvent, BackboxState> {
  /// {@macro backbox_bloc}
  BackboxBloc({
    required LeaderboardRepository leaderboardRepository,
    required List<LeaderboardEntryData>? initialEntries,
  })  : _leaderboardRepository = leaderboardRepository,
        super(
          initialEntries != null
              ? LeaderboardSuccessState(entries: initialEntries)
              : LeaderboardFailureState(),
        ) {
    on<PlayerInitialsRequested>(_onPlayerInitialsRequested);
    on<PlayerInitialsSubmitted>(_onPlayerInitialsSubmitted);
    on<LeaderboardRequested>(_onLeaderboardRequested);
  }

  final LeaderboardRepository _leaderboardRepository;

  void _onPlayerInitialsRequested(
    PlayerInitialsRequested event,
    Emitter<BackboxState> emit,
  ) {
    emit(
      InitialsFormState(
        score: event.score,
        character: event.character,
      ),
    );
  }

  Future<void> _onPlayerInitialsSubmitted(
    PlayerInitialsSubmitted event,
    Emitter<BackboxState> emit,
  ) async {
    try {
      emit(LoadingState());
      await _leaderboardRepository.addLeaderboardEntry(
        LeaderboardEntryData(
          playerInitials: event.initials,
          score: event.score,
          character: event.character.toType,
        ),
      );
      emit(InitialsSuccessState());
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(InitialsFailureState());
    }
  }

  Future<void> _onLeaderboardRequested(
    LeaderboardRequested event,
    Emitter<BackboxState> emit,
  ) async {
    try {
      emit(LoadingState());

      final entries = await _leaderboardRepository.fetchTop10Leaderboard();

      emit(LeaderboardSuccessState(entries: entries));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(LeaderboardFailureState());
    }
  }
}
