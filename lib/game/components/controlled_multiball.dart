import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multiball_group_component}
/// A [SpriteGroupComponent] for the multiball over the board.
/// {@endtemplate}
class MultiballGroup extends Component
    with Controls<MultiballController>, HasGameRef<PinballGame> {
  /// {@macro multiball_group_component}
  MultiballGroup()
      : super(
          children: [
            Multiball.a(),
            Multiball.b(),
            Multiball.c(),
            Multiball.d(),
          ],
        ) {
    controller = MultiballController(this);
  }
}

/// {@template multiball_controller}
/// Controller attached to a [MultiballGroup] that handles its game related
/// logic.
/// {@endtemplate}
@visibleForTesting
class MultiballController extends ComponentController<MultiballGroup>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  /// {@macro multiball_controller}
  MultiballController(MultiballGroup multiballGroup) : super(multiballGroup);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.bonusHistory != newState.bonusHistory;
  }

  @override
  void onNewState(GameState state) {
    final isMultiball = state.bonusHistory.contains(GameBonus.dashNest);

    if (isMultiball) {
      component.children.whereType<Multiball>().forEach((element) {
        element.animate();
      });
    }
  }
}
