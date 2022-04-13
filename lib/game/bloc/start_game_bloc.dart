import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball/game/game.dart';

part 'start_game_event.dart';
part 'start_game_state.dart';

/// {@template start_game_bloc}
/// Bloc which allows to control user state before launch the game.
/// {@endtemplate}
class StartGameBloc extends Bloc<StartGameEvent, StartGameState> {
  /// {@macro start_game_bloc}
  StartGameBloc({
    required PinballGame game,
  })  : _game = game,
        super(const StartGameState.initial()) {
    on<SelectCharacter>(_onSelectCharacter);
    on<HowToPlay>(_onHowToPlay);
    on<Play>(_onPlay);
  }

  final PinballGame _game;

  Future<void> _onSelectCharacter(
    SelectCharacter event,
    Emitter emit,
  ) async {
    _game.gameFlowController.start();

    emit(
      state.copyWith(
        status: StartGameStatus.selectCharacter,
      ),
    );
  }

  Future<void> _onHowToPlay(
    HowToPlay event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        status: StartGameStatus.howToPlay,
      ),
    );
  }

  Future<void> _onPlay(
    Play event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        status: StartGameStatus.play,
      ),
    );
  }
}
