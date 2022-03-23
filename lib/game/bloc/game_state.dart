// ignore_for_file: public_member_api_docs

part of 'game_bloc.dart';

/// Defines bonuses that a player can gain during a PinballGame.
enum GameBonus {
  /// Bonus achieved when the user activate all of the bonus
  /// letters on the board, forming the bonus word
  word,

  /// Bonus achieved when the user activates all of the Dash
  /// nests on the board, adding a new ball to the board.
  dashNest,
}

/// {@template game_state}
/// Represents the state of the pinball game.
/// {@endtemplate}
class GameState extends Equatable {
  /// {@macro game_state}
  const GameState({
    required this.score,
    required this.balls,
    required this.activatedBonusLetters,
    required this.bonusHistory,
    required this.activatedDashNests,
  })  : assert(score >= 0, "Score can't be negative"),
        assert(balls >= 0, "Number of balls can't be negative");

  const GameState.initial()
      : score = 0,
        balls = 3,
        activatedBonusLetters = const [],
        activatedDashNests = const {},
        bonusHistory = const [];

  /// The current score of the game.
  final int score;

  /// The number of balls left in the game.
  ///
  /// When the number of balls is 0, the game is over.
  final int balls;

  /// Active bonus letters.
  final List<int> activatedBonusLetters;

  /// Active dash nests.
  final Set<String> activatedDashNests;

  /// Holds the history of all the [GameBonus]es earned by the player during a
  /// PinballGame.
  final List<GameBonus> bonusHistory;

  /// Determines when the game is over.
  bool get isGameOver => balls == 0;

  /// Determines when the player has only one ball left.
  bool get isLastBall => balls == 1;

  /// Shortcut method to check if the given [i]
  /// is activated.
  bool isLetterActivated(int i) => activatedBonusLetters.contains(i);

  GameState copyWith({
    int? score,
    int? balls,
    List<int>? activatedBonusLetters,
    Set<String>? activatedDashNests,
    List<GameBonus>? bonusHistory,
  }) {
    assert(
      score == null || score >= this.score,
      "Score can't be decreased",
    );

    return GameState(
      score: score ?? this.score,
      balls: balls ?? this.balls,
      activatedBonusLetters:
          activatedBonusLetters ?? this.activatedBonusLetters,
      activatedDashNests: activatedDashNests ?? this.activatedDashNests,
      bonusHistory: bonusHistory ?? this.bonusHistory,
    );
  }

  @override
  List<Object?> get props => [
        score,
        balls,
        activatedBonusLetters,
        activatedDashNests,
        bonusHistory,
      ];
}
