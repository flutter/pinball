import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_bonus_behavior}
/// When a [Ball] shot inside the [SpaceshipRamp] 10 times increases score.
/// {@endtemplate}
class RampBonusBehavior extends Component
    with ParentIsA<SpaceshipRamp>, HasGameRef<PinballGame> {
  /// {@macro ramp_bonus_behavior}
  RampBonusBehavior({
    required Points points,
    required Vector2 scorePosition,
  })  : _points = points,
        _scorePosition = scorePosition,
        super();

  final int _oneMillionPointsTimes = 10;
  final Points _points;
  final Vector2 _scorePosition;

  final Set<Ball> _balls = HashSet();
  int _previousHits = 0;

  @override
  void onMount() {
    super.onMount();

    final sensors = parent.descendants().whereType<RampSensor>();

    for (final sensor in sensors) {
      sensor.bloc.stream.listen((state) {
        switch (state.type) {
          case RampSensorType.door:
            return _handleOnDoor(state.ball!);
          case RampSensorType.inside:
            return _handleOnInside(state.ball!);
        }
      });
    }
  }

  void _handleOnDoor(Ball ball) {
    if (!_balls.contains(ball)) {
      _balls.add(ball);
    }
  }

  void _handleOnInside(Ball ball) {
    if (_balls.contains(ball)) {
      _balls.remove(ball);
      _previousHits++;
      _shot(_previousHits);
    }
  }

  /// When a [Ball] shot the [SpaceshipRamp] it achieve improvements for the
  /// current game, like multipliers or score.
  void _shot(int currentHits) {
    if (currentHits % _oneMillionPointsTimes == 0) {
      gameRef.read<GameBloc>().add(Scored(points: _points.value));
      gameRef.add(
        ScoreComponent(
          points: _points,
          position: _getRandomPosition,
        ),
      );
    }
  }

  Vector2 get _getRandomPosition {
    final randomX = Random().nextInt(2);
    final randomY = Random().nextInt(2);
    final sign = randomX + randomY % 2;

    return _scorePosition +
        Vector2(sign * randomX.toDouble(), sign * randomY.toDouble());
  }
}
