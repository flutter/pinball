import 'dart:collection';

import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template android_ramp_bonus_behavior}
/// When all [DashNestBumper]s are hit at least once, the [GameBonus.dashNest]
/// is awarded, and the [DashNestBumper.main] releases a new [Ball].
/// {@endtemplate}
class AndroidRampBonusBehavior extends Component
    with ParentIsA<AndroidRamp>, HasGameRef<PinballGame> {
  /// {@macro android_ramp_bonus_behavior}
  AndroidRampBonusBehavior({
    required int shotPoints,
    required int bonusPoints,
  })  : _shotPoints = shotPoints,
        _bonusPoints = bonusPoints;

  final int _shotPoints;
  final int _bonusPoints;

  final Set<Ball> _balls = HashSet();
  int _previousHits = 0;

  @override
  void onMount() {
    super.onMount();

    final sensors = parent.children.whereType<AndroidRampSensor>();
    for (final sensor in sensors) {
      sensor.bloc.stream.listen((state) {
        switch (state.type) {
          case AndroidRampSensorType.door:
            _handleOnDoor(state.ball!);
            break;
          case AndroidRampSensorType.inside:
            _handleOnInside(state.ball!);
            break;
        }
      });
    }
  }

  void _handleOnDoor(Ball ball) {
    print("_handleOnDoor $ball");
    print("$_balls");
    if (!_balls.contains(ball)) {
      _balls.add(ball);
      print("added $_balls");
    }
  }

  void _handleOnInside(Ball ball) {
    print("_handleOnInside $ball");
    print("$_balls");
    if (_balls.contains(ball)) {
      _balls.remove(ball);
      print("removed $_balls");
      _previousHits++;
      shot(_previousHits, ball.body.position);
    }
  }

  final int _oneMillionPointsTarget = 10;

  /// When a [Ball] shot the [SpaceshipRamp] it achieve improvements for the
  /// current game, like multipliers or score.
  void shot(int currentHits, Vector2 position) {
    parent.spaceshipRamp.progress();
    print("SHOT $currentHits");

    print("Score $_shotPoints");
    gameRef.read<GameBloc>().add(Scored(points: _shotPoints));
    gameRef.add(
      ScoreText(
        text: _shotPoints.toString(),
        position: position,
      ),
    );

    final multiplier = gameRef.read<GameBloc>().state.multiplier;
    gameRef.read<GameBloc>().add(const MultiplierIncreased());
    print("Increase multiplier $multiplier");

    if (currentHits % _oneMillionPointsTarget == 0) {
      print("Score $_oneMillionPointsTarget");
      gameRef.read<GameBloc>().add(Scored(points: _bonusPoints));
      gameRef.add(
        ScoreText(
          text: _bonusPoints.toString(),
          position: position + Vector2(-2, -5),
        ),
      );
    }
  }
}
