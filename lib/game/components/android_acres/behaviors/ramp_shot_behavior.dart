import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_shot_behavior}
/// Increases the score when a [Ball] is shot into the [SpaceshipRamp].
/// {@endtemplate}
class RampShotBehavior extends Component
    with ParentIsA<SpaceshipRamp>, HasGameRef<PinballGame> {
  /// {@macro ramp_shot_behavior}
  RampShotBehavior({
    required Points points,
  })  : _points = points,
        super();

  final Points _points;

  @override
  void onMount() {
    super.onMount();

    parent.bloc.stream.listen((state) {
      final achievedOneMillionPoints = state.hits % 10 == 0;

      if (!achievedOneMillionPoints) {
        gameRef.read<GameBloc>()
          ..add(const MultiplierIncreased())
          ..add(Scored(points: _points.value));
        gameRef.add(
          ScoreComponent(
            points: _points,
            position: Vector2(0, -45),
          ),
        );
      }
    });
  }
}
