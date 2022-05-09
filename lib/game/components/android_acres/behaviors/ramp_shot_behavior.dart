import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template ramp_shot_behavior}
/// Increases the score when a [Ball] is shot into the [SpaceshipRamp].
/// {@endtemplate}
class RampShotBehavior extends Component
    with FlameBlocListenable<SpaceshipRampCubit, SpaceshipRampState> {
  /// {@macro ramp_shot_behavior}
  RampShotBehavior({
    required Points points,
  })  : _points = points,
        super();

  final Points _points;

  @override
  bool listenWhen(
    SpaceshipRampState previousState,
    SpaceshipRampState newState,
  ) {
    return previousState.hits < newState.hits;
  }

  @override
  void onNewState(SpaceshipRampState state) {
    parent!.add(
      ScoringBehavior(
        points: _points,
        position: Vector2(0, -45),
      ),
    );
  }
}
