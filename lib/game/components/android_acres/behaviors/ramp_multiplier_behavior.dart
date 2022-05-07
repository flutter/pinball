import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_multiplier_behavior}
/// Increases the multiplier when a [Ball] is shot 5 times into the
/// [SpaceshipRamp].
/// {@endtemplate}
class RampMultiplierBehavior extends Component
    with ParentIsA<SpaceshipRamp>, FlameBlocReader<GameBloc, GameState> {
  /// {@macro ramp_multiplier_behavior}
  RampMultiplierBehavior() : super();

  /// Creates a [RampMultiplierBehavior].
  ///
  /// This can be used for testing [RampMultiplierBehavior] in isolation.
  @visibleForTesting
  RampMultiplierBehavior.test({
    required this.subscription,
  }) : super();

  /// Subscription to [SpaceshipRampState] at [SpaceshipRamp].
  @visibleForTesting
  StreamSubscription? subscription;

  @override
  void onMount() {
    super.onMount();

    var previousState = const SpaceshipRampState.initial();

    subscription = subscription ??
        parent.bloc.stream.listen((state) {
          final listenWhen =
              previousState.hits != state.hits && state.hits != 0;
          if (listenWhen) {
            final achievedFiveShots = state.hits % 5 == 0;

            if (achievedFiveShots) {
              bloc.add(const MultiplierIncreased());
            }

            previousState = state;
          }
        });
  }

  @override
  void onRemove() {
    subscription?.cancel();
    super.onRemove();
  }
}
