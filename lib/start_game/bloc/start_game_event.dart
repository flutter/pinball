part of 'start_game_bloc.dart';

/// {@template start_game_event}
/// Event added during the start game flow.
/// {@endtemplate}
abstract class StartGameEvent extends Equatable {
  /// {@macro start_game_event}
  const StartGameEvent();
}

/// {@template play_tapped}
/// Play tapped event.
/// {@endtemplate}
class PlayTapped extends StartGameEvent {
  /// {@macro play_tapped}
  const PlayTapped();

  @override
  List<Object> get props => [];
}

/// {@template replay_tapped}
/// Replay tapped event.
/// {@endtemplate}
class ReplayTapped extends StartGameEvent {
  /// {@macro replay_tapped}
  const ReplayTapped();

  @override
  List<Object> get props => [];
}

/// {@template character_selected}
/// Character selected event.
/// {@endtemplate}
class CharacterSelected extends StartGameEvent {
  /// {@macro character_selected}
  const CharacterSelected();

  @override
  List<Object> get props => [];
}

/// {@template how_to_play_finished}
/// How to play finished event.
/// {@endtemplate}
class HowToPlayFinished extends StartGameEvent {
  /// {@macro how_to_play_finished}
  const HowToPlayFinished();

  @override
  List<Object> get props => [];
}
