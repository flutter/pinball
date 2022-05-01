import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

abstract class AssetsGame extends Forge2DGame {
  AssetsGame({
    List<String>? imagesFileNames,
  }) : _imagesFileNames = imagesFileNames {
    images.prefix = '';
  }

  final List<String>? _imagesFileNames;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (_imagesFileNames != null) {
      await images.loadAll(_imagesFileNames!);
    }
  }
}

abstract class LineGame extends AssetsGame with PanDetector {
  LineGame({
    List<String>? imagesFileNames,
  }) : super(
          imagesFileNames: [
            if (imagesFileNames != null) ...imagesFileNames,
          ],
        );

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
