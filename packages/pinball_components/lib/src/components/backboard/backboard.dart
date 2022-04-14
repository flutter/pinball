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
          position: position,
          anchor: Anchor.bottomCenter,
        );

  /// {@macro backboard}
  ///
  /// Returns a [Backboard] initialized in the waiting mode
  factory Backboard.waiting({
    required Vector2 position,
  }) {
    return Backboard(position: position)..waitingMode();
  }

  /// {@macro backboard}
  ///
  /// Returns a [Backboard] initialized in the game over mode
  factory Backboard.gameOver({
    required Vector2 position,
    required int score,
    required BackboardOnSubmit onSubmit,
  }) {
    return Backboard(position: position)
      ..gameOverMode(
        score: score,
        onSubmit: onSubmit,
      );
  }

  /// [TextPaint] used on the [Backboard]
  static final textPaint = TextPaint(
    style: TextStyle(
      fontSize: 6,
      color: Colors.white,
      fontFamily: PinballFonts.pixeloidSans,
    ),
  );

  /// Puts the Backboard in waiting mode, where the scoreboard is shown.
  Future<void> waitingMode() async {
    children.removeWhere((_) => true);
    await add(BackboardWaiting());
  }

  /// Puts the Backboard in game over mode, where the score input is shown.
  Future<void> gameOverMode({
    required int score,
    BackboardOnSubmit? onSubmit,
  }) async {
    children.removeWhere((_) => true);
    await add(
      BackboardGameOver(
        score: score,
        onSubmit: onSubmit,
      ),
    );
  }
}
