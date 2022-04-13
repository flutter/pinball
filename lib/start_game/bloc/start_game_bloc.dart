import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball/game/game.dart';

part 'start_game_event.dart';
part 'start_game_state.dart';

/// {@template start_game_bloc}
/// Bloc that manages the app flow before the game starts.
/// {@endtemplate}
class StartGameBloc extends Bloc<StartGameEvent, StartGameState> {
  /// {@macro start_game_bloc}
  StartGameBloc({
    required PinballGame game,
  })  : _game = game,
        super(const StartGameState.initial()) {
    on<PlayTapped>(_onPlayTapped);
    on<CharacterSelected>(_onCharacterSelected);
    on<HowToPlayFinished>(_onHowToPlayFinished);
  }

  final PinballGame _game;

  void _onPlayTapped(
    PlayTapped event,
    Emitter<StartGameState> emit,
  ) {
    _game.gameFlowController.start();

    emit(
      state.copyWith(
        status: StartGameStatus.selectCharacter,
      ),
    );
  }

  void _onCharacterSelected(
    CharacterSelected event,
    Emitter<StartGameState> emit,
  ) {
    emit(
      state.copyWith(
        status: StartGameStatus.howToPlay,
      ),
    );
  }

  void _onHowToPlayFinished(
    HowToPlayFinished event,
    Emitter<StartGameState> emit,
  ) {
    emit(
      state.copyWith(
        status: StartGameStatus.play,
      ),
    );
  }
}
