import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_progress_behavior}
/// Increases the score when a [Ball] is shot into the [SpaceshipRamp].
/// {@endtemplate}
class RampProgressBehavior extends Component
    with ParentIsA<SpaceshipRamp>, FlameBlocReader<GameBloc, GameState> {
  /// {@macro ramp_shot_behavior}
  RampProgressBehavior() : super();

  /// Creates a [RampProgressBehavior].
  ///
  /// This can be used for testing [RampProgressBehavior] in isolation.
  @visibleForTesting
  RampProgressBehavior.test({
    required this.subscription,
  }) : super();

  /// Subscription to [SpaceshipRampState] at [SpaceshipRamp].
  @visibleForTesting
  StreamSubscription? subscription;

  @override
  void onMount() {
    super.onMount();

    final spaceshipRamp = parent.children.whereType<SpaceshipRamp>().first;

    var previousState = const SpaceshipRampState.initial();

    subscription = subscription ??
        parent.bloc.stream.listen((state) {
          final listenWhen =
              previousState.hits != state.hits && state.hits != 0;
          if (listenWhen) {
            var fullArrowLit = spaceshipRamp.bloc.isFullyProgressed();
            var isMaxMultiplier = bloc.state.multiplier == 6;
            final canProgress =
                !isMaxMultiplier || (isMaxMultiplier && !fullArrowLit);

            if (canProgress) {
              spaceshipRamp.bloc.onProgressed();
            }

            fullArrowLit = spaceshipRamp.bloc.isFullyProgressed();
            isMaxMultiplier = bloc.state.multiplier == 6;

            if (fullArrowLit && !isMaxMultiplier) {
              spaceshipRamp.bloc.onAnimate();
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
