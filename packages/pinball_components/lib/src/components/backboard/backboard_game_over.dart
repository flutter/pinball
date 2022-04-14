import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';

/// Signature for the callback called when the used has
/// submettied their initials on the [BackboardGameOver]
typedef BackboardOnSubmit = void Function(String);

/// {@template backboard_game_over}
/// [PositionComponent] that handles the user input on the
/// game over display view.
/// {@endtemplate}
class BackboardGameOver extends PositionComponent with HasGameRef {
  /// {@macro backboard_game_over}
  BackboardGameOver({
    required int score,
    BackboardOnSubmit? onSubmit,
  })  : _score = score,
        _onSubmit = onSubmit;

  final int _score;
  final BackboardOnSubmit? _onSubmit;

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
          text: _score.formatScore(),
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

    unawaited(
      add(
        KeyboardInputController(
          keyUp: {
            LogicalKeyboardKey.arrowLeft: () => _movePrompt(true),
            LogicalKeyboardKey.arrowRight: () => _movePrompt(false),
            LogicalKeyboardKey.enter: _submit,
          },
        ),
      ),
    );
  }

  /// Returns the current inputed initials
  String get initials => children
      .whereType<BackboardLetterPrompt>()
      .map((prompt) => prompt.char)
      .join();

  bool _submit() {
    _onSubmit?.call(initials);
    return true;
  }

  bool _movePrompt(bool left) {
    final prompts = children.whereType<BackboardLetterPrompt>().toList();

    final current = prompts.firstWhere((prompt) => prompt.hasFocus)
      ..hasFocus = false;
    var index = prompts.indexOf(current) + (left ? -1 : 1);
    index = min(max(0, index), prompts.length - 1);

    prompts[index].hasFocus = true;

    return false;
  }
}
