import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template backboard_game_over}
/// [PositionComponent] that handles the user input on the
/// game over display view.
/// {@endtemplate}
class BackboardGameOver extends PositionComponent
    with HasGameRef, KeyboardHandler {
  /// {@macro backboard_game_over}
  BackboardGameOver({
    required int score,
  }) : _score = score;

  final int _score;

  final _numberFormat = NumberFormat('#,###,###');

  @override
  Future<void> onLoad() async {
    final backgroundSprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardGameOver.keyName,
    );

    unawaited(
      add(
        SpriteComponent(
          sprite: backgroundSprite,
          size: backgroundSprite.originalSize / 10,
          anchor: Anchor.bottomCenter,
        ),
      ),
    );

    final displaySprite = await gameRef.loadSprite(
      Assets.images.backboard.display.keyName,
    );

    unawaited(
      add(
        SpriteComponent(
          sprite: displaySprite,
          size: displaySprite.originalSize / 10,
          anchor: Anchor.bottomCenter,
          position: Vector2(0, -11.5),
        ),
      ),
    );

    unawaited(
      add(
        TextComponent(
          text: _numberFormat.format(_score),
          position: Vector2(-22, -46.5),
          anchor: Anchor.center,
          textRenderer: Backboard.textPaint,
        ),
      ),
    );

    for (var i = 0; i < 3; i++) {
      unawaited(
        add(
          BackboardLetterPrompt(
            position: Vector2(
              20 + (6 * i).toDouble(),
              -46.5,
            ),
            hasFocus: i == 0,
          ),
        ),
      );
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isUp = event is RawKeyUpEvent;

    return true;
  }
}
