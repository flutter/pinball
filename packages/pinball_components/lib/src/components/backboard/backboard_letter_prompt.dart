import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

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
  static const _alphabetLength = 25;
  var _charIndex = 0;

  bool _hasFocus;

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
      text: 'A',
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

    unawaited(
      add(
        KeyboardInputController(
          keyUp: {
            LogicalKeyboardKey.arrowUp: () => _cycle(true),
            LogicalKeyboardKey.arrowDown: () => _cycle(false),
          },
        ),
      ),
    );
  }

  /// Returns the current selected character
  String get char => String.fromCharCode(_alphabetCode + _charIndex);

  bool _cycle(bool up) {
    if (_hasFocus) {
      final newCharCode =
          min(max(_charIndex + (up ? 1 : -1), 0), _alphabetLength);
      _input.text = String.fromCharCode(_alphabetCode + newCharCode);
      _charIndex = newCharCode;

      return false;
    }
    return true;
  }

  /// Returns if this prompt has focus on it
  bool get hasFocus => _hasFocus;

  /// Updates this prompt focus
  set hasFocus(bool hasFocus) {
    if (hasFocus) {
      _underscoreBlinker.timer.resume();
    } else {
      _underscoreBlinker.timer.pause();
    }
    _underscore.paint.color = Colors.white;
    _hasFocus = hasFocus;
  }
}
