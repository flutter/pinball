import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

export 'backboard_game_over.dart';
export 'backboard_letter_prompt.dart';
export 'backboard_waiting.dart';

/// {@template backboard}
/// The [Backboard] of the pinball machine.
/// {@endtemplate}
class Backboard extends PositionComponent with HasGameRef {
  /// {@macro backboard}
  Backboard({
    required Vector2 position,
  }) : super(
          // TODO(erickzanardo): remove multiply after
          // https://github.com/flame-engine/flame/pull/1506 is merged
          position: position..clone().multiply(Vector2(1, -1)),
          anchor: Anchor.bottomCenter,
        );

  /// [TextPaint] used on the [Backboard]
  static final textPaint = TextPaint(
    style: TextStyle(
      fontSize: 6,
      color: Colors.white,
      fontFamily: PinballFonts.pixeloidSans,
    ),
  );

  /// {@macro backboard}
  ///
  /// Returns a [Backboard] initialized in the waiting mode
  factory Backboard.waiting({
    required Vector2 position,
  }) {
    return Backboard(position: position)
        ..waitingMode();
  }

  /// {@macro backboard}
  ///
  /// Returns a [Backboard] initialized in the game over mode
  factory Backboard.gameOver({
    required Vector2 position,
    required int score,
  }) {
    return Backboard(position: position)
        ..gameOverMode(score: score);
  }

  /// Puts the Backboard in waiting mode, where the scoreboard is shown.
  Future<void> waitingMode() async {
    children.removeWhere((element) => true);
    await add(BackboardWaiting());
  }

  /// Puts the Backboard in game over mode, where the score input is shown.
  Future<void> gameOverMode({ required int score}) async {
    children.removeWhere((element) => true);
    await add(BackboardGameOver(score: score));
  }
}
