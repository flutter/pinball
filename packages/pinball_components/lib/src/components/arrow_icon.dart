import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// enum with the available directions for an [ArrowIcon].
enum ArrowIconDirection {
  /// Left.
  left,

  /// Right.
  right,
}

/// {@template arrow_icon}
/// A [SpriteComponent] that renders a simple arrow icon.
/// {@endtemplate}
class ArrowIcon extends SpriteComponent with Tappable, HasGameRef {
  /// {@macro arrow_icon}
  ArrowIcon({
    required Vector2 position,
    required this.direction,
    required this.onTap,
  }) : super(position: position);

  final ArrowIconDirection direction;
  final VoidCallback onTap;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    final sprite = Sprite(
      gameRef.images.fromCache(
        direction == ArrowIconDirection.left
            ? Assets.images.displayArrows.arrowLeft.keyName
            : Assets.images.displayArrows.arrowRight.keyName,
      ),
    );

    size = sprite.originalSize / 20;
    this.sprite = sprite;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    onTap();
    return true;
  }
}
