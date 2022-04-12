import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template backboard_letter_prompt}
/// A [PositionComponent] that renders a letter prompt used
/// on the [BackboardGameOver]
/// {@endtemplate}
class BackboardLetterPrompt extends PositionComponent {
  /// {@macro backboard_letter_prompt}
  BackboardLetterPrompt({
    required Vector2 position,
    bool hasFocus = false,
  })  : _hasFocus = hasFocus,
        super(
          position: position,
        );

  static const _alphabetCode = 65;
  static const _alphabetLength = 26;

  bool _hasFocus;
  String _char = '';

  late RectangleComponent _underscore;
  late TextComponent _input;
  late TimerComponent _underscoreBlinker;

  @override
  Future<void> onLoad() async {
    _underscore = RectangleComponent(
      size: Vector2(
        4,
        1.2,
      ),
      anchor: Anchor.center,
      position: Vector2(0, 4),
    );

    unawaited(add(_underscore));

    _input = TextComponent(
        text: _hasFocus ? 'A' : '',
        textRenderer: Backboard.textPaint,
        anchor: Anchor.center,
    );
    unawaited(add(_input));

    _underscoreBlinker = TimerComponent(
      period: 0.6,
      repeat: true,
      autoStart: _hasFocus,
      onTick: () {
        _underscore.paint.color = (_underscore.paint.color == Colors.white)
            ? Colors.transparent
            : Colors.white;
      },
    );

    unawaited(add(_underscoreBlinker));
  }

  void up() {
  }

  void down() {
  }

  void nextPrompt() {
  }
}
