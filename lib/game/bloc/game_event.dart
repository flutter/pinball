part of 'game_bloc.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

/// Event added when a user drops a ball off the screen.
class BallLost extends GameEvent {
  const BallLost();
}

/// Event added when a user increases their score.
class Scored extends GameEvent {
  const Scored({
    required this.points,
  }) : assert(points > 0, 'Points must be greater than 0');

  final int points;
}
