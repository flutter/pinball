part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    required this.score,
    required this.ballsLeft,
  });

  final int score;
  final int ballsLeft;

  bool get isGameOver => ballsLeft == 0;

  GameState copyWith({
    int? score,
    int? ballsLeft,
  }) {
    return GameState(
      score: score ?? this.score,
      ballsLeft: ballsLeft ?? this.ballsLeft,
    );
  }

  @override
  List<Object?> get props => [
        score,
        ballsLeft,
      ];
}
