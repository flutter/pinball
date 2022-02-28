part of 'game_bloc.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

class BallLost extends GameEvent {
  const BallLost();
}

class Scored extends GameEvent {
  const Scored(this.points);

  final int points;
}
