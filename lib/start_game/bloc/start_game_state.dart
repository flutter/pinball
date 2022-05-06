part of 'start_game_bloc.dart';

/// Defines status of start game flow.
enum StartGameStatus {
  /// Initial status.
  initial,

  /// Selection characters status.
  selectCharacter,

  /// How to play status.
  howToPlay,

  /// Play status.
  play,
}

/// {@template start_game_state}
/// Represents the state of flow before the game starts.
/// {@endtemplate}
class StartGameState extends Equatable {
  /// {@macro start_game_state}
  const StartGameState({
    required this.status,
    this.restarted = false,
  });

  /// Initial [StartGameState].
  const StartGameState.initial()
      : this(
          status: StartGameStatus.initial,
          restarted: false,
        );

  /// Status of [StartGameState].
  final StartGameStatus status;

  /// Game has been restarted from game over screen.
  final bool restarted;

  /// Creates a copy of [StartGameState].
  StartGameState copyWith({
    StartGameStatus? status,
    bool? restarted,
  }) {
    return StartGameState(
      status: status ?? this.status,
      restarted: restarted ?? this.restarted,
    );
  }

  @override
  List<Object> get props => [status, restarted];
}
