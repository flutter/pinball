import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_bonus_behavior}
/// Increases the score when a [Ball] is shot 10 times into the [SpaceshipRamp].
/// {@endtemplate}
class RampBonusBehavior extends Component
    with ParentIsA<SpaceshipRamp>, HasGameRef<PinballGame> {
  /// {@macro ramp_bonus_behavior}
  RampBonusBehavior({
    required Points points,
  })  : _points = points,
        super();

  final Points _points;

  @override
  void onMount() {
    super.onMount();

    parent.bloc.stream.listen((state) {
      final achievedOneMillionPoints = state.hits % 10 == 0;

      if (achievedOneMillionPoints) {
        gameRef.read<GameBloc>().add(Scored(points: _points.value));
        gameRef.add(
          ScoreComponent(
            points: _points,
            position: Vector2(0, -60),
          ),
        );
      }
    });
  }
}
