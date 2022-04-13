part of 'start_game_bloc.dart';

/// {@template start_game_event}
/// Event added when user is staring the game.
/// {@endtemplate}
abstract class StartGameEvent extends Equatable {
  /// {@macro start_game_event}
  const StartGameEvent();

  @override
  List<Object> get props => [];
}

/// Select character event.
class SelectCharacter extends StartGameEvent {}

/// How to play event.
class HowToPlay extends StartGameEvent {}

/// Play event.
class Play extends StartGameEvent {}
