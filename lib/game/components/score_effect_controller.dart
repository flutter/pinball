import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

///
class ScoreEffectController extends ComponentController<PinballGame>
    with BlocComponent<GameBloc, GameState> {
  ///
  ScoreEffectController(PinballGame component) : super(component);

  int _lastScore = 0;
  final _rng = Random();

  double _noise() {
    return _rng.nextDouble() * 5 * (_rng.nextBool() ? -1 : 1);
  }

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.score != newState.score;
  }

  @override
  void onNewState(GameState state) {
    final newScore = state.score - _lastScore;

    component.add(
      _Text(
        text: newScore.toString(),
        position: Vector2(
            _noise(),
            _noise() + (-BoardDimensions.bounds.topCenter.dy + 10),
        ),
      ),
    );

    _lastScore = state.score;
  }
}

class _Text extends TextComponent {
  _Text({
    required String text,
    required Vector2 position,
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.center,
          priority: 100,
        );
  late final Effect _effect;

  @override
  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: const TextStyle(color: Colors.pink, fontSize: 4),
    );

    unawaited(
      add(
        _effect = MoveEffect.by(
          Vector2(0, -5),
          EffectController(duration: 1),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_effect.controller.completed) {
      removeFromParent();
    }
  }
}
