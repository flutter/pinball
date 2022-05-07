import 'dart:ui';
import 'package:collection/collection.dart' as collection;

import 'package:flame/components.dart';
import 'package:pinball_flame/src/canvas/canvas_wrapper.dart';

/// {@template z_canvas_component}
/// Draws [ZIndex] components after the all non-[ZIndex] components have been
/// drawn.
/// {@endtemplate}
class ZCanvasComponent extends Component {
  /// {@macro z_canvas_component}
  ZCanvasComponent({
    Iterable<Component>? children,
  })  : _zCanvas = _ZCanvas(),
        super(children: children);

  final _ZCanvas _zCanvas;

  @override
  void renderTree(Canvas canvas) {
    _zCanvas.canvas = canvas;
    super.renderTree(_zCanvas);
    _zCanvas.render();
  }
}

/// Apply to any [Component] that will be rendered according to a
/// [ZIndex.zIndex].
///
/// [ZIndex] components must be descendants of a [ZCanvasComponent].
///
/// {@macro z_canvas.render}
mixin ZIndex on Component {
  /// The z-index of this component.
  ///
  /// The higher the value, the later the component will be drawn. Hence,
  /// rendering in front of [Component]s with lower [zIndex] values.
  int zIndex = 0;

  @override
  void renderTree(
    Canvas canvas,
  ) {
    if (canvas is _ZCanvas) {
      canvas.buffer(this);
    } else {
      super.renderTree(canvas);
    }
  }
}

/// The [_ZCanvas] allows to postpone the rendering of [ZIndex] components.
///
/// You should not use this class directly.
class _ZCanvas extends CanvasWrapper {
  final List<ZIndex> _zBuffer = [];

  /// Postpones the rendering of [ZIndex] component and its children.
  void buffer(ZIndex component) {
    final lowerBound = collection.lowerBound<ZIndex>(
      _zBuffer,
      component,
      compare: (a, b) => a.zIndex.compareTo(b.zIndex),
    );
    _zBuffer.insert(lowerBound, component);
  }

  /// Renders all [ZIndex] components and their children.
  ///
  /// {@template z_canvas.render}
  /// The rendering order is defined by the parent [ZIndex]. The children of
  /// the same parent are rendered in the order they were added.
  ///
  /// If two [Component]s ever overlap each other, and have the same
  /// [ZIndex.zIndex], there is no guarantee that the first one will be rendered
  /// before the second one.
  /// {@endtemplate}
  void render() => _zBuffer
    ..forEach(_render)
    ..clear();

  void _render(Component component) => component.renderTree(canvas);
}
