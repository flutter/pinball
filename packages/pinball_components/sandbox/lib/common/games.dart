import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class BasicGame extends Forge2DGame {
  BasicGame() {
    images.prefix = '';
  }
}

abstract class LineGame extends BasicGame with PanDetector {
  Vector2? _lineEnd;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    unawaited(add(_PreviewLine()));
  }

  @override
  void onPanStart(DragStartInfo info) {
    _lineEnd = info.eventPosition.game;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _lineEnd = info.eventPosition.game;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_lineEnd != null) {
      final line = _lineEnd! - Vector2.zero();
      onLine(line);
      _lineEnd = null;
    }
  }

  void onLine(Vector2 line);
}

class _PreviewLine extends PositionComponent with HasGameRef<LineGame> {
  static final _previewLinePaint = Paint()
    ..color = Colors.pink
    ..strokeWidth = 0.2
    ..style = PaintingStyle.stroke;

  Vector2? lineEnd;

  @override
  void update(double dt) {
    super.update(dt);

    lineEnd = gameRef._lineEnd?.clone()?..multiply(Vector2(1, -1));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (lineEnd != null) {
      canvas.drawLine(
        Vector2.zero().toOffset(),
        lineEnd!.toOffset(),
        _previewLinePaint,
      );
    }
  }
}
