// ignore_for_file: public_member_api_docs

import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multipliers_group_component}
/// A [SpriteGroupComponent] for the multiplier over the board.
/// {@endtemplate}
class Multipliers extends Component
    with Controls<MultipliersController>, HasGameRef<PinballGame> {
  /// {@macro multipliers_group_component}
  Multipliers()
      : x2multiplier = Multiplier(
          value: 2,
          position: Vector2(-19.5, -2),
          rotation: -15 * math.pi / 180,
        ),
        x3multiplier = Multiplier(
          value: 3,
          position: Vector2(13, -9.5),
          rotation: 15 * math.pi / 180,
        ),
        x4multiplier = Multiplier(
          value: 4,
          position: Vector2(0, -21),
        ),
        x5multiplier = Multiplier(
          value: 5,
          position: Vector2(-8.5, -28),
          rotation: -3 * math.pi / 180,
        ),
        x6multiplier = Multiplier(
          value: 6,
          position: Vector2(10, -31),
          rotation: 8 * math.pi / 180,
        ),
        super() {
    controller = MultipliersController(this);
  }

  final Multiplier x2multiplier;

  final Multiplier x3multiplier;

  final Multiplier x4multiplier;

  final Multiplier x5multiplier;

  final Multiplier x6multiplier;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await addAll([
      x2multiplier,
      x3multiplier,
      x4multiplier,
      x5multiplier,
      x6multiplier,
    ]);
  }
}

/// {@template multipliers_controller}
/// Controller attached to a [Multipliers] that handles its game related
/// logic.
/// {@endtemplate}
@visibleForTesting
class MultipliersController extends ComponentController<Multipliers>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  /// {@macro multipliers_controller}
  MultipliersController(Multipliers multipliersGroup) : super(multipliersGroup);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    // TODO(ruimiguel): use here GameState.multiplier when merged
    // https://github.com/VGVentures/pinball/pull/213.
    return previousState?.score != newState.score;
  }

  @override
  void onNewState(GameState state) {
    // TODO(ruimiguel): use here GameState.multiplier when merged
    // https://github.com/VGVentures/pinball/pull/213.
    final currentMultiplier = state.score.bitLength % 6 + 1;

    component.x2multiplier.toggle(currentMultiplier);
    component.x3multiplier.toggle(currentMultiplier);
    component.x4multiplier.toggle(currentMultiplier);
    component.x5multiplier.toggle(currentMultiplier);
    component.x6multiplier.toggle(currentMultiplier);
  }
}
