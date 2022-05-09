import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_bonus_behavior}
/// Increases the score when a [Ball] is shot 10 times into the [SpaceshipRamp].
/// {@endtemplate}
class RampBonusBehavior extends Component with ParentIsA<SpaceshipRamp> {
  /// {@macro ramp_bonus_behavior}
  RampBonusBehavior({
    required Points points,
  })  : _points = points,
        super();

  final Points _points;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<SpaceshipRampCubit, SpaceshipRampState>(
        listenWhen: (previousState, newState) {
          final hasChanged = previousState.hits != newState.hits;
          final hasHit = newState.hits != 0;
          final achievedOneMillionPoints = newState.hits % 10 == 0;

          return hasChanged && hasHit && achievedOneMillionPoints;
        },
        onNewState: (state) {
          parent.add(
            ScoringBehavior(
              points: _points,
              position: Vector2(0, -60),
              duration: 2,
            ),
          );
        },
      ),
    );
  }
}
