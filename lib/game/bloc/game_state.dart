part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    required this.score,
    required this.balls,
  });

  final int score;
  final int balls;

  bool get isGameOver => balls == 0;

  GameState copyWith({
    int? score,
    int? balls,
  }) {
    return GameState(
      score: score ?? this.score,
      balls: balls ?? this.balls,
    );
  }

  @override
  List<Object?> get props => [
        score,
        balls,
      ];
}
