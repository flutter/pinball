import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Signature for the callback called when the used has
/// submitted their initials on the [InitialsInputDisplay].
typedef InitialsOnSubmit = void Function(String);

final _bodyTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 3,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

final _subtitleTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.8,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template initials_input_display}
/// Display that handles the user input on the game over view.
/// {@endtemplate}
// TODO(allisonryan0002): add mobile input buttons.
class InitialsInputDisplay extends Component with HasGameRef {
  /// {@macro initials_input_display}
  InitialsInputDisplay({
    required int score,
    required String characterIconPath,
    InitialsOnSubmit? onSubmit,
  })  : _onSubmit = onSubmit,
        super(
          children: [
            _ScoreLabelTextComponent(),
            _ScoreTextComponent(score.formatScore()),
            _NameLabelTextComponent(),
            _CharacterIconSpriteComponent(characterIconPath),
            _DividerSpriteComponent(),
            _InstructionsComponent(),
          ],
        );

  final InitialsOnSubmit? _onSubmit;

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < 3; i++) {
      await add(
        _InitialsLetterPrompt(
          position: Vector2(
            11.4 + (2.3 * i),
            -20,
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
      .whereType<_InitialsLetterPrompt>()
      .map((prompt) => prompt.char)
      .join();

  bool _submit() {
    _onSubmit?.call(initials);
    return true;
  }

  bool _movePrompt(bool left) {
    final prompts = children.whereType<_InitialsLetterPrompt>().toList();

    final current = prompts.firstWhere((prompt) => prompt.hasFocus)
      ..hasFocus = false;
    var index = prompts.indexOf(current) + (left ? -1 : 1);
    index = min(max(0, index), prompts.length - 1);

    prompts[index].hasFocus = true;

    return false;
  }
}

class _ScoreLabelTextComponent extends TextComponent with HasGameRef {
  _ScoreLabelTextComponent()
      : super(
          anchor: Anchor.centerLeft,
          position: Vector2(-16.9, -24),
          textRenderer: _bodyTextPaint.copyWith(
            (style) => style.copyWith(
              color: PinballColors.red,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).score;
  }
}

class _ScoreTextComponent extends TextComponent {
  _ScoreTextComponent(String score)
      : super(
          text: score,
          anchor: Anchor.centerLeft,
          position: Vector2(-16.9, -20),
          textRenderer: _bodyTextPaint,
        );
}

class _NameLabelTextComponent extends TextComponent with HasGameRef {
  _NameLabelTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(11.4, -24),
          textRenderer: _bodyTextPaint.copyWith(
            (style) => style.copyWith(
              color: PinballColors.red,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).name;
  }
}

class _CharacterIconSpriteComponent extends SpriteComponent with HasGameRef {
  _CharacterIconSpriteComponent(String characterIconPath)
      : _characterIconPath = characterIconPath,
        super(
          anchor: Anchor.center,
          position: Vector2(8.4, -20),
        );

  final String _characterIconPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(gameRef.images.fromCache(_characterIconPath));
    this.sprite = sprite;
    size = sprite.originalSize / 20;
  }
}

class _InitialsLetterPrompt extends PositionComponent {
  _InitialsLetterPrompt({
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
      size: Vector2(1.9, 0.4),
      anchor: Anchor.center,
      position: Vector2(-0.1, 1.8),
    );

    await add(_underscore);

    _input = TextComponent(
      text: 'A',
      textRenderer: _bodyTextPaint,
      anchor: Anchor.center,
    );
    await add(_input);

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

    await add(_underscoreBlinker);

    await add(
      KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowUp: () => _cycle(true),
          LogicalKeyboardKey.arrowDown: () => _cycle(false),
        },
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

class _DividerSpriteComponent extends SpriteComponent with HasGameRef {
  _DividerSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -17),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(Assets.images.backboard.displayDivider.keyName),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 20;
  }
}

class _InstructionsComponent extends PositionComponent with HasGameRef {
  _InstructionsComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -12.3),
          children: [
            _EnterInitialsTextComponent(),
            _ArrowsTextComponent(),
            _AndPressTextComponent(),
            _EnterReturnTextComponent(),
            _ToSubmitTextComponent(),
          ],
        );
}

class _EnterInitialsTextComponent extends TextComponent with HasGameRef {
  _EnterInitialsTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -2.4),
          textRenderer: _subtitleTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).enterInitials;
  }
}

class _ArrowsTextComponent extends TextComponent with HasGameRef {
  _ArrowsTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-13.2, 0),
          textRenderer: _subtitleTextPaint.copyWith(
            (style) => style.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).arrows;
  }
}

class _AndPressTextComponent extends TextComponent with HasGameRef {
  _AndPressTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-3.7, 0),
          textRenderer: _subtitleTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).andPress;
  }
}

class _EnterReturnTextComponent extends TextComponent with HasGameRef {
  _EnterReturnTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(10, 0),
          textRenderer: _subtitleTextPaint.copyWith(
            (style) => style.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).enterReturn;
  }
}

class _ToSubmitTextComponent extends TextComponent with HasGameRef {
  _ToSubmitTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 2.4),
          textRenderer: _subtitleTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = AppLocalizations.of(gameRef.buildContext!).toSubmit;
  }
}
