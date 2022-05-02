import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_shot_behavior}
/// When a [Ball] shot inside the [SpaceshipRamp] it achieve improvements for
/// the current game, like multipliers or score.
/// {@endtemplate}
class RampShotBehavior extends Component
    with ParentIsA<SpaceshipRamp>, HasGameRef<PinballGame> {
  /// {@macro ramp_shot_behavior}
  RampShotBehavior({
    required Points points,
    required Vector2 scorePosition,
  })  : _points = points,
        _scorePosition = scorePosition,
        super();

  final Points _points;
  final Vector2 _scorePosition;

  final Set<Ball> _balls = HashSet();

  @override
  void onMount() {
    super.onMount();

    final sensors = parent.descendants().whereType<RampSensor>();

    for (final sensor in sensors) {
      sensor.bloc.stream.listen((state) {
        switch (state.type) {
          case RampSensorType.door:
            _handleOnDoor(state.ball!);
            break;
          case RampSensorType.inside:
            _handleOnInside(state.ball!);
            break;
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
      _shot();
    }
  }

  void _shot() {
    parent.progress();

    gameRef.read<GameBloc>()
      ..add(const MultiplierIncreased())
      ..add(Scored(points: _points.value));
    gameRef.add(
      ScoreComponent(
        points: _points,
        position: _getRandomPosition,
      ),
    );
  }

  Vector2 get _getRandomPosition {
    final randomX = Random().nextInt(3);
    final randomY = Random().nextInt(3);
    final sign = randomX + randomY % 2;

    return _scorePosition +
        Vector2(sign * randomX.toDouble(), sign * randomY.toDouble());
  }
}
