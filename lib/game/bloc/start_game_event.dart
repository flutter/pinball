part of 'start_game_bloc.dart';

/// {@template start_game_event}
/// Event added when user is staring the game.
/// {@endtemplate}
abstract class StartGameEvent extends Equatable {
  /// {@macro start_game_event}
  const StartGameEvent();
}

/// {@template select_character}
/// Select character event.
/// {@endtemplate}
class SelectCharacter extends StartGameEvent {
  /// {@macro select_character}
  const SelectCharacter();

  @override
  List<Object> get props => [];
}

/// {@template how_to_play}
/// How to play event.
/// {@endtemplate}
class HowToPlay extends StartGameEvent {
  /// {@macro how_to_play}
  const HowToPlay();

  @override
  List<Object> get props => [];
}

/// {@template play}
/// Play event.
/// {@endtemplate}
class Play extends StartGameEvent {
  /// {@macro play}
  const Play();

  @override
  List<Object> get props => [];
}
