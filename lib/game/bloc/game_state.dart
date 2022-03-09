part of 'game_bloc.dart';

/// Enum to describe all the available bonuses
/// on the game
enum GameBonuses {
  letterSequence,
}

/// {@template game_state}
/// Represents the state of the pinball game.
/// {@endtemplate}
class GameState extends Equatable {
  /// {@macro game_state}
  const GameState({
    required this.score,
    required this.balls,
    required this.bonusLetters,
    required this.bonusHistory,
  })  : assert(score >= 0, "Score can't be negative"),
        assert(balls >= 0, "Number of balls can't be negative");

  const GameState.initial()
      : score = 0,
        balls = 3,
        bonusLetters = const [],
        bonusHistory = const [];

  /// The current score of the game.
  final int score;

  /// The number of balls left in the game.
  ///
  /// When the number of balls is 0, the game is over.
  final int balls;

  /// Active bonus letters.
  final List<int> bonusLetters;

  /// Holds the history of all the bonuses
  /// that the palyer earned during the play
  final List<GameBonuses> bonusHistory;

  /// Determines when the game is over.
  bool get isGameOver => balls == 0;

  /// Determines when the player has only one ball left.
  bool get isLastBall => balls == 1;

  GameState copyWith({
    int? score,
    int? balls,
    List<int>? bonusLetters,
    List<GameBonuses>? bonusHistory,
  }) {
    assert(
      score == null || score >= this.score,
      "Score can't be decreased",
    );

    return GameState(
      score: score ?? this.score,
      balls: balls ?? this.balls,
      bonusLetters: bonusLetters ?? this.bonusLetters,
      bonusHistory: bonusHistory ?? this.bonusHistory,
    );
  }

  @override
  List<Object?> get props => [
        score,
        balls,
        bonusLetters,
        bonusHistory,
      ];
}
