import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_shot_behavior}
/// Increases the score when a [Ball] is shot into the [SpaceshipRamp].
/// {@endtemplate}
class RampShotBehavior extends Component
    with ParentIsA<SpaceshipRamp>, FlameBlocReader<GameBloc, GameState> {
  /// {@macro ramp_shot_behavior}
  RampShotBehavior({
    required Points points,
  })  : _points = points,
        super();

  /// Creates a [RampShotBehavior].
  ///
  /// This can be used for testing [RampShotBehavior] in isolation.
  @visibleForTesting
  RampShotBehavior.test({
    required Points points,
    required this.subscription,
  })  : _points = points,
        super();

  final Points _points;

  /// Subscription to [SpaceshipRampState] at [SpaceshipRamp].
  @visibleForTesting
  StreamSubscription? subscription;

  @override
  void onMount() {
    super.onMount();

    subscription = subscription ??
        parent.bloc.stream.listen((state) {
          final achievedOneMillionPoints = state.hits % 10 == 0;

          if (!achievedOneMillionPoints) {
            bloc.add(const MultiplierIncreased());

            parent.add(
              ScoringBehavior(
                points: _points,
                position: Vector2(0, -45),
              ),
            );
          }
        });
  }

  @override
  void onRemove() {
    subscription?.cancel();
    super.onRemove();
  }
}
