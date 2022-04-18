import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template score_effect_controller}
/// A [ComponentController] responsible for adding [ScoreText]s
/// on the game screen when the user earns points.
/// {@endtemplate}
class ScoreEffectController extends ComponentController<PinballGame>
    with BlocComponent<GameBloc, GameState> {
  /// {@macro score_effect_controller}
  ScoreEffectController(PinballGame component) : super(component);

  int _lastScore = 0;
  final _random = Random();

  double _noise() {
    return _random.nextDouble() * 5 * (_random.nextBool() ? -1 : 1);
  }

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.score != newState.score;
  }

  @override
  void onNewState(GameState state) {
    final newScore = state.score - _lastScore;
    _lastScore = state.score;

    component.add(
      ScoreText(
        text: newScore.toString(),
        position: Vector2(
          _noise(),
          _noise() + (BoardDimensions.bounds.topCenter.dy + 10),
        ),
      ),
    );
  }
}
