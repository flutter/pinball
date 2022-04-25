// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Animation;

/// {@template flame.widgets.sprite_animation_widget}
/// A [StatelessWidget] that renders a [SpriteAnimation].
/// {@endtemplate}
// TODO(arturplaczek): Remove when this PR will be merged.
// https://github.com/flame-engine/flame/pull/1552
class SpriteAnimationWidget extends StatelessWidget {
  /// {@macro flame.widgets.sprite_animation_widget}
  const SpriteAnimationWidget({
    required this.controller,
    this.anchor = Anchor.topLeft,
    Key? key,
  }) : super(key: key);

  /// The positioning [Anchor].
  final Anchor anchor;

  final SpriteAnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(
          painter: SpritePainter(
            controller.animation.getSprite(),
            anchor,
          ),
        );
      },
    );
  }
}

class SpriteAnimationController extends AnimationController {
  SpriteAnimationController({
    required TickerProvider vsync,
    required this.animation,
  }) : super(vsync: vsync) {
    duration = Duration(seconds: animation.totalDuration().ceil());
  }

  final SpriteAnimation animation;

  double? _lastUpdated;

  @override
  void notifyListeners() {
    super.notifyListeners();

    final now = DateTime.now().millisecond.toDouble();
    final dt = max<double>(0, (now - (_lastUpdated ?? 0)) / 1000);
    animation.update(dt);
    _lastUpdated = now;
  }
}

class SpritePainter extends CustomPainter {
  SpritePainter(
    this._sprite,
    this._anchor, {
    double angle = 0,
  }) : _angle = angle;

  final Sprite _sprite;
  final Anchor _anchor;
  final double _angle;

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return oldDelegate._sprite != _sprite ||
        oldDelegate._anchor != _anchor ||
        oldDelegate._angle != _angle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final boxSize = size.toVector2();
    final rate = boxSize.clone()..divide(_sprite.srcSize);
    final minRate = min(rate.x, rate.y);
    final paintSize = _sprite.srcSize * minRate;
    final anchorPosition = _anchor.toVector2();
    final boxAnchorPosition = boxSize.clone()..multiply(anchorPosition);
    final spriteAnchorPosition = anchorPosition..multiply(paintSize);

    canvas
      ..translateVector(boxAnchorPosition..sub(spriteAnchorPosition))
      ..renderRotated(
        _angle,
        spriteAnchorPosition,
        (canvas) => _sprite.render(canvas, size: paintSize),
      );
  }
}
