import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pinball_flame/src/canvas/canvas_wrapper.dart';

/// Called right before [Canvas.drawImageRect] is called.
///
/// This is useful since [Sprite.render] uses [Canvas.drawImageRect] to draw
/// the [Sprite].
typedef PaintFunction = void Function(Paint);

/// {@template canvas_component}
/// Allows listening before the rendering of [Sprite]s.
///
/// The existance of this class is to hack around the fact that Flame doesn't
/// provide a global way to modify the default [Paint] before rendering a
/// [Sprite].
/// {@endtemplate}
class CanvasComponent extends Component {
  /// {@macro canvas_component}
  CanvasComponent({
    PaintFunction? onSpritePainted,
    Iterable<Component>? children,
  })  : _canvas = _Canvas(onSpritePainted: onSpritePainted),
        super(children: children);

  final _Canvas _canvas;

  @override
  void renderTree(Canvas canvas) {
    _canvas.canvas = canvas;
    super.renderTree(_canvas);
  }
}

class _Canvas extends CanvasWrapper {
  _Canvas({PaintFunction? onSpritePainted})
      : _onSpritePainted = onSpritePainted;

  final PaintFunction? _onSpritePainted;

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {
    _onSpritePainted?.call(paint);
    super.drawImageRect(image, src, dst, paint);
  }
}
