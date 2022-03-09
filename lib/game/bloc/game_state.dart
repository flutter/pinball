part of 'game_bloc.dart';

/// {@template game_state}
/// Represents the state of the pinball game.
/// {@endtemplate}
class GameState extends Equatable {
  /// {@macro game_state}
  const GameState({
    required this.score,
    required this.balls,
    required this.bonusLetter,
  })  : assert(score >= 0, "Score can't be negative"),
        assert(balls >= 0, "Number of balls can't be negative");

  const GameState.initial()
      : score = 0,
        balls = 3,
        bonusLetter = const [];

  /// The current score of the game.
  final int score;

  /// The number of balls left in the game.
  ///
  /// When the number of balls is 0, the game is over.
  final int balls;

  /// Active bonus letters.
  final List<String> bonusLetter;

  /// Determines when the game is over.
  bool get isGameOver => balls == 0;

  /// Determines when the player has only one ball left.
  bool get isLastBall => balls == 1;

  GameState copyWith({
    int? score,
    int? balls,
    List<String>? bonusLetter,
  }) {
    assert(
      score == null || score >= this.score,
      "Score can't be decreased",
    );

    return GameState(
      score: score ?? this.score,
      balls: balls ?? this.balls,
      bonusLetter: bonusLetter ?? this.bonusLetter,
    );
  }

  @override
  List<Object?> get props => [
        score,
        balls,
        bonusLetter,
      ];
}
