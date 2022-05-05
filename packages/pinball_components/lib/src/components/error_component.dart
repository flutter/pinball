import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_ui/pinball_ui.dart';

final _labelStrongTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.8,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
    fontWeight: FontWeight.w700,
  ),
);

final _labelTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.8,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
    fontWeight: FontWeight.w400,
  ),
);

/// {@template error_component}
/// A plain visual component used to show errors for the user.
/// {@endtemplate}
class ErrorComponent extends SpriteComponent with HasGameRef {
  /// {@macro error_component}
  ErrorComponent({required this.label, Vector2? position})
      : _textPaint = _labelTextPaint,
        super(
          position: position,
        );

  /// {@macro error_component}
  ErrorComponent.strong({required this.label, Vector2? position})
      : _textPaint = _labelStrongTextPaint,
        super(
          position: position,
        );

  /// Label text that will be show on as the error message.
  final String label;
  final TextPaint _textPaint;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    final sprite = await gameRef.loadSprite(
      Assets.images.errorBackground.keyName,
    );

    size = sprite.originalSize / 20;
    this.sprite = sprite;

    final maxWidth = size.x - 8;
    final lines = <String>[];
    var currentLine = '';
    final words = label.split(' ');
    while (words.isNotEmpty) {
      final word = words.removeAt(0);

      if (_textPaint.measureTextWidth('$currentLine $word') <= maxWidth) {
        currentLine = '$currentLine $word'.trim();
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }

    lines.add(currentLine);

    /// Based on how many lines we have, their size and a small
    /// offset due to the centering, this calculates where the lines
    /// should start on the y axis to be centered
    final yOffset = ((size.y / 2.2) / lines.length) * 1.5;

    for (var i = 0; i < lines.length; i++) {
      await add(
        TextComponent(
          position: Vector2(size.x / 2, yOffset + 2.2 * i),
          size: Vector2(size.x - 4, 2.2),
          text: lines[i],
          textRenderer: _textPaint,
          anchor: Anchor.center,
        ),
      );
    }
  }
}
