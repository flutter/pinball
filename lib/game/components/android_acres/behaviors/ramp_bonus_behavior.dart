import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
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

  /// Creates a [RampBonusBehavior].
  ///
  /// This can be used for testing [RampBonusBehavior] in isolation.
  @visibleForTesting
  RampBonusBehavior.test({
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

          if (achievedOneMillionPoints) {
            parent.add(
              ScoringBehavior(
                points: _points,
                position: Vector2(0, -60),
                duration: 2,
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
