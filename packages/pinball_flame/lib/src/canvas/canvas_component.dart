import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pinball_flame/src/canvas/canvas_wrapper.dart';

/// Called right before [Canvas.drawImageRect] is called.
///
/// This is useful since [Sprite.render] uses [Canvas.drawImageRect] to draw
/// the sprite.
typedef PaintFunction = void Function(Paint)?;

/// {@template canvas}
/// Allows listening before the rendering of [Sprite]s.
/// {@endtemplate}
class CanvasComponent extends Component {
  /// {@macro canvas}
  CanvasComponent(
    PaintFunction? beforePainting,
    Iterable<Component>? children,
  )   : _canvas = _Canvas(beforePainting: beforePainting),
        super(children: children);

  final _Canvas _canvas;

  @override
  void renderTree(Canvas canvas) {
    _canvas.canvas = canvas;
    super.renderTree(_canvas);
  }
}

class _Canvas extends CanvasWrapper {
  _Canvas({PaintFunction beforePainting}) : _beforePainting = beforePainting;

  final PaintFunction _beforePainting;

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {
    _beforePainting?.call(paint);
    super.drawImageRect(image, src, dst, paint);
  }
}
