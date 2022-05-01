import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';

/// {@template z_canvas_component}
/// Draws [ZIndex] components after the all non-[ZIndex] components have been
/// drawn.
/// {@endtemplate}
class ZCanvasComponent extends Component {
  /// {@macro z_canvas_component}
  ZCanvasComponent({
    Iterable<Component>? children,
  })  : _zCanvas = ZCanvas(),
        super(children: children);

  final ZCanvas _zCanvas;

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
    if (canvas is ZCanvas) {
      canvas.buffer(this);
    } else {
      super.renderTree(canvas);
    }
  }
}

/// The [ZCanvas] allows to postpone the rendering of [ZIndex] components.
///
/// You should not use this class directly.
class ZCanvas implements Canvas {
  /// The [Canvas] to render to.
  ///
  /// This is set by [ZCanvasComponent] when rendering.
  late Canvas canvas;

  final List<ZIndex> _zBuffer = [];

  /// Postpones the rendering of [ZIndex] component and its children.
  void buffer(ZIndex component) => _zBuffer.add(component);

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
    ..sort((a, b) => a.zIndex.compareTo(b.zIndex))
    ..whereType<Component>().forEach(_render)
    ..clear();

  void _render(Component component) => component.renderTree(canvas);

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) =>
      canvas.clipPath(path, doAntiAlias: doAntiAlias);

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) =>
      canvas.clipRRect(rrect, doAntiAlias: doAntiAlias);

  @override
  void clipRect(
    Rect rect, {
    ClipOp clipOp = ClipOp.intersect,
    bool doAntiAlias = true,
  }) =>
      canvas.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);

  @override
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) =>
      canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

  @override
  void drawAtlas(
    Image atlas,
    List<RSTransform> transforms,
    List<Rect> rects,
    List<Color>? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) =>
      canvas.drawAtlas(
        atlas,
        transforms,
        rects,
        colors,
        blendMode,
        cullRect,
        paint,
      );

  @override
  void drawCircle(Offset c, double radius, Paint paint) => canvas.drawCircle(
        c,
        radius,
        paint,
      );

  @override
  void drawColor(Color color, BlendMode blendMode) =>
      canvas.drawColor(color, blendMode);

  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) =>
      canvas.drawDRRect(outer, inner, paint);

  @override
  void drawImage(Image image, Offset offset, Paint paint) =>
      canvas.drawImage(image, offset, paint);

  @override
  void drawImageNine(Image image, Rect center, Rect dst, Paint paint) =>
      canvas.drawImageNine(image, center, dst, paint);

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) =>
      canvas.drawImageRect(image, src, dst, paint);

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) =>
      canvas.drawLine(p1, p2, paint);

  @override
  void drawOval(Rect rect, Paint paint) => canvas.drawOval(rect, paint);

  @override
  void drawPaint(Paint paint) => canvas.drawPaint(paint);

  @override
  void drawParagraph(Paragraph paragraph, Offset offset) =>
      canvas.drawParagraph(paragraph, offset);

  @override
  void drawPath(Path path, Paint paint) => canvas.drawPath(path, paint);

  @override
  void drawPicture(Picture picture) => canvas.drawPicture(picture);

  @override
  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) =>
      canvas.drawPoints(pointMode, points, paint);

  @override
  void drawRRect(RRect rrect, Paint paint) => canvas.drawRRect(rrect, paint);

  @override
  void drawRawAtlas(
    Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) =>
      canvas.drawRawAtlas(
        atlas,
        rstTransforms,
        rects,
        colors,
        blendMode,
        cullRect,
        paint,
      );

  @override
  void drawRawPoints(PointMode pointMode, Float32List points, Paint paint) =>
      canvas.drawRawPoints(pointMode, points, paint);

  @override
  void drawRect(Rect rect, Paint paint) => canvas.drawRect(rect, paint);

  @override
  void drawShadow(
    Path path,
    Color color,
    double elevation,
    bool transparentOccluder,
  ) =>
      canvas.drawShadow(path, color, elevation, transparentOccluder);

  @override
  void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) =>
      canvas.drawVertices(vertices, blendMode, paint);

  @override
  int getSaveCount() => canvas.getSaveCount();

  @override
  void restore() => canvas.restore();

  @override
  void rotate(double radians) => canvas.rotate(radians);

  @override
  void save() => canvas.save();

  @override
  void saveLayer(Rect? bounds, Paint paint) => canvas.saveLayer(bounds, paint);

  @override
  void scale(double sx, [double? sy]) => canvas.scale(sx, sy);

  @override
  void skew(double sx, double sy) => canvas.skew(sx, sy);

  @override
  void transform(Float64List matrix4) => canvas.transform(matrix4);

  @override
  void translate(double dx, double dy) => canvas.translate(dx, dy);
}
