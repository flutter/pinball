import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

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
    required String characterIconPath,
    BackboardOnSubmit? onSubmit,
  })  : _onSubmit = onSubmit,
        super(
          children: [
            _BackboardSpriteComponent(),
            _BackboardDisplaySpriteComponent(),
            _ScoreTextComponent(score.formatScore()),
            _CharacterIconSpriteComponent(characterIconPath),
          ],
        );

  final BackboardOnSubmit? _onSubmit;

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < 3; i++) {
      await add(
        BackboardLetterPrompt(
          position: Vector2(
            24.3 + (4.5 * i),
            -45,
          ),
          hasFocus: i == 0,
        ),
      );
    }

    await add(
      KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowLeft: () => _movePrompt(true),
          LogicalKeyboardKey.arrowRight: () => _movePrompt(false),
          LogicalKeyboardKey.enter: _submit,
        },
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

class _BackboardSpriteComponent extends SpriteComponent with HasGameRef {
  _BackboardSpriteComponent() : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.backboardGameOver.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _BackboardDisplaySpriteComponent extends SpriteComponent with HasGameRef {
  _BackboardDisplaySpriteComponent()
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0, -11.5),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.backboard.display.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _ScoreTextComponent extends TextComponent {
  _ScoreTextComponent(String score)
      : super(
          text: score,
          anchor: Anchor.centerLeft,
          position: Vector2(-34, -45),
          textRenderer: Backboard.textPaint,
        );
}

class _CharacterIconSpriteComponent extends SpriteComponent with HasGameRef {
  _CharacterIconSpriteComponent(String characterIconPath)
      : _characterIconPath = characterIconPath,
        super(
          anchor: Anchor.center,
          position: Vector2(18.4, -45),
        );

  final String _characterIconPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(gameRef.images.fromCache(_characterIconPath));
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
