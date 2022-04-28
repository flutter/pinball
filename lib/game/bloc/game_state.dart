// ignore_for_file: public_member_api_docs

part of 'game_bloc.dart';

/// Defines bonuses that a player can gain during a PinballGame.
enum GameBonus {
  /// Bonus achieved when the ball activates all Google letters.
  googleWord,

  /// Bonus achieved when the user activates all dash nest bumpers.
  dashNest,

  /// Bonus achieved when a ball enters Sparky's computer.
  sparkyTurboCharge,

  /// Bonus achieved when the ball goes in the dino mouth.
  dinoChomp,

  /// Bonus achieved when a ball enters the android spaceship.
  androidSpaceship,
}

/// {@template game_state}
/// Represents the state of the pinball game.
/// {@endtemplate}
class GameState extends Equatable {
  /// {@macro game_state}
  const GameState({
    required this.score,
    required this.balls,
    required this.bonusHistory,
  })  : assert(score >= 0, "Score can't be negative"),
        assert(balls >= 0, "Number of balls can't be negative");

  const GameState.initial()
      : score = 0,
        balls = 3,
        bonusHistory = const [];

  /// The current score of the game.
  final int score;

  /// The number of balls left in the game.
  ///
  /// When the number of balls is 0, the game is over.
  final int balls;

  /// Holds the history of all the [GameBonus]es earned by the player during a
  /// PinballGame.
  final List<GameBonus> bonusHistory;

  /// Determines when the game is over.
  bool get isGameOver => balls == 0;

  GameState copyWith({
    int? score,
    int? balls,
    List<GameBonus>? bonusHistory,
  }) {
    assert(
      score == null || score >= this.score,
      "Score can't be decreased",
    );

    return GameState(
      score: score ?? this.score,
      balls: balls ?? this.balls,
      bonusHistory: bonusHistory ?? this.bonusHistory,
    );
  }

  @override
  List<Object?> get props => [
        score,
        balls,
        bonusHistory,
      ];
}
