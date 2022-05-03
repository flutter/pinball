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

  @override
  void onMount() {
    super.onMount();

    parent.bloc.stream.listen((state) {
      if (state.shot) {
        parent.progress();

        gameRef.read<GameBloc>()
          ..add(const MultiplierIncreased())
          ..add(Scored(points: _points.value));
        gameRef.add(
          ScoreComponent(
            points: _points,
            position: _scorePosition,
          ),
        );
      }
    });
  }
}
