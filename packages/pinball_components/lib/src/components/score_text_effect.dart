import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/fonts.gen.dart';

/// {@template score_text_effect}
/// A [TextComponent] that spawns at a given [position]
/// bundles a simples translate effect and is removed
/// once its animation is completed
/// {@endtemplate}
class ScoreTextEffect extends TextComponent {

  /// {@macro score_text_effect}
  ScoreTextEffect({
    required String text,
    required Vector2 position,
    this.color = Colors.black,
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.center,
          priority: 100,
        );
  late final Effect _effect;
  /// The [text] [Color]
  final Color color;

  @override
  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: TextStyle(
          fontFamily: 'packages/pinball_components/${FontFamily.pixeloidMono}',
          color: color,
          fontSize: 4,
      ),
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
