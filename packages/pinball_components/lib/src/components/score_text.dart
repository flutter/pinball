import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template score_text}
/// A [TextComponent] that spawns at a given [position] with a moving animation.
/// {@endtemplate}
class ScoreText extends TextComponent with Rendering {
  /// {@macro score_text}
  ScoreText({
    required String text,
    required Vector2 position,
    this.color = Colors.black,
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.center,
        ) {
    zIndex = RenderPriority.scoreText;
  }

  late final Effect _effect;

  /// The [text]'s [Color].
  final Color color;

  @override
  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: TextStyle(
        fontFamily: PinballFonts.pixeloidMono,
        color: color,
        fontSize: 4,
      ),
    );

    await add(
      _effect = MoveEffect.by(
        Vector2(0, -5),
        EffectController(duration: 1),
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
