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
  })  : _leaderboardRepository = leaderboardRepository,
        super(LoadingState()) {
    on<PlayerInitialsRequested>(_onPlayerInitialsRequested);
    on<PlayerInitialsSubmited>(_onPlayerInitialsSubmited);
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

  Future<void> _onPlayerInitialsSubmited(
    PlayerInitialsSubmited event,
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
    } catch (e, s) {
      addError(e, s);
      emit(InitialsFailureState());
    }
  }
}
