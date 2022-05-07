import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/src/canvas/canvas_wrapper.dart';

class _MockCanvas extends Mock implements Canvas {}

class _MockImage extends Mock implements Image {}

class _MockPicture extends Mock implements Picture {}

class _MockParagraph extends Mock implements Paragraph {}

class _MockVertices extends Mock implements Vertices {}

void main() {
  group('CanvasWrapper', () {
    group('CanvasWrapper', () {
      late Canvas canvas;
      late Path path;
      late RRect rRect;
      late Rect rect;
      late Paint paint;
      late Image atlas;
      late BlendMode blendMode;
      late Color color;
      late Offset offset;
      late Float64List float64list;
      late Float32List float32list;
      late Int32List int32list;
      late Picture picture;
      late Paragraph paragraph;
      late Vertices vertices;

      setUp(() {
        canvas = _MockCanvas();
        path = Path();
        rRect = RRect.zero;
        rect = Rect.zero;
        paint = Paint();
        atlas = _MockImage();
        blendMode = BlendMode.clear;
        color = Colors.black;
        offset = Offset.zero;
        float64list = Float64List(1);
        float32list = Float32List(1);
        int32list = Int32List(1);
        picture = _MockPicture();
        paragraph = _MockParagraph();
        vertices = _MockVertices();
      });

      test("clipPath calls Canvas's clipPath", () {
        CanvasWrapper()
          ..canvas = canvas
          ..clipPath(path, doAntiAlias: false);
        verify(
          () => canvas.clipPath(path, doAntiAlias: false),
        ).called(1);
      });

      test("clipRRect calls Canvas's clipRRect", () {
        CanvasWrapper()
          ..canvas = canvas
          ..clipRRect(rRect, doAntiAlias: false);
        verify(
          () => canvas.clipRRect(rRect, doAntiAlias: false),
        ).called(1);
      });

      test("clipRect calls Canvas's clipRect", () {
        CanvasWrapper()
          ..canvas = canvas
          ..clipRect(rect, doAntiAlias: false);
        verify(
          () => canvas.clipRect(rect, doAntiAlias: false),
        ).called(1);
      });

      test("drawArc calls Canvas's drawArc", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawArc(rect, 0, 1, false, paint);
        verify(
          () => canvas.drawArc(rect, 0, 1, false, paint),
        ).called(1);
      });

      test("drawAtlas calls Canvas's drawAtlas", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawAtlas(atlas, [], [], [], blendMode, rect, paint);
        verify(
          () => canvas.drawAtlas(atlas, [], [], [], blendMode, rect, paint),
        ).called(1);
      });

      test("drawCircle calls Canvas's drawCircle", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawCircle(offset, 0, paint);
        verify(
          () => canvas.drawCircle(offset, 0, paint),
        ).called(1);
      });

      test("drawColor calls Canvas's drawColor", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawColor(color, blendMode);
        verify(
          () => canvas.drawColor(color, blendMode),
        ).called(1);
      });

      test("drawDRRect calls Canvas's drawDRRect", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawDRRect(rRect, rRect, paint);
        verify(
          () => canvas.drawDRRect(rRect, rRect, paint),
        ).called(1);
      });

      test("drawImage calls Canvas's drawImage", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawImage(atlas, offset, paint);
        verify(
          () => canvas.drawImage(atlas, offset, paint),
        ).called(1);
      });

      test("drawImageNine calls Canvas's drawImageNine", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawImageNine(atlas, rect, rect, paint);
        verify(
          () => canvas.drawImageNine(atlas, rect, rect, paint),
        ).called(1);
      });

      test("drawImageRect calls Canvas's drawImageRect", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawImageRect(atlas, rect, rect, paint);
        verify(
          () => canvas.drawImageRect(atlas, rect, rect, paint),
        ).called(1);
      });

      test("drawLine calls Canvas's drawLine", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawLine(offset, offset, paint);
        verify(
          () => canvas.drawLine(offset, offset, paint),
        ).called(1);
      });

      test("drawOval calls Canvas's drawOval", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawOval(rect, paint);
        verify(
          () => canvas.drawOval(rect, paint),
        ).called(1);
      });

      test("drawPaint calls Canvas's drawPaint", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawPaint(paint);
        verify(
          () => canvas.drawPaint(paint),
        ).called(1);
      });

      test("drawParagraph calls Canvas's drawParagraph", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawParagraph(paragraph, offset);
        verify(
          () => canvas.drawParagraph(paragraph, offset),
        ).called(1);
      });

      test("drawPath calls Canvas's drawPath", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawPath(path, paint);
        verify(
          () => canvas.drawPath(path, paint),
        ).called(1);
      });

      test("drawPicture calls Canvas's drawPicture", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawPicture(picture);
        verify(
          () => canvas.drawPicture(picture),
        ).called(1);
      });

      test("drawPoints calls Canvas's drawPoints", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawPoints(PointMode.points, [offset], paint);
        verify(
          () => canvas.drawPoints(PointMode.points, [offset], paint),
        ).called(1);
      });

      test("drawRRect calls Canvas's drawRRect", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawRRect(rRect, paint);
        verify(
          () => canvas.drawRRect(rRect, paint),
        ).called(1);
      });

      test("drawRawAtlas calls Canvas's drawRawAtlas", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawRawAtlas(
            atlas,
            float32list,
            float32list,
            int32list,
            BlendMode.clear,
            rect,
            paint,
          );
        verify(
          () => canvas.drawRawAtlas(
            atlas,
            float32list,
            float32list,
            int32list,
            BlendMode.clear,
            rect,
            paint,
          ),
        ).called(1);
      });

      test("drawRawPoints calls Canvas's drawRawPoints", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawRawPoints(PointMode.points, float32list, paint);
        verify(
          () => canvas.drawRawPoints(PointMode.points, float32list, paint),
        ).called(1);
      });

      test("drawRect calls Canvas's drawRect", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawRect(rect, paint);
        verify(
          () => canvas.drawRect(rect, paint),
        ).called(1);
      });

      test("drawShadow calls Canvas's drawShadow", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawShadow(path, color, 0, false);
        verify(
          () => canvas.drawShadow(path, color, 0, false),
        ).called(1);
      });

      test("drawVertices calls Canvas's drawVertices", () {
        CanvasWrapper()
          ..canvas = canvas
          ..drawVertices(vertices, blendMode, paint);
        verify(
          () => canvas.drawVertices(vertices, blendMode, paint),
        ).called(1);
      });

      test("getSaveCount calls Canvas's getSaveCount", () {
        final canvasWrapper = CanvasWrapper()..canvas = canvas;
        when(() => canvas.getSaveCount()).thenReturn(1);
        canvasWrapper.getSaveCount();
        verify(() => canvas.getSaveCount()).called(1);
        expect(canvasWrapper.getSaveCount(), 1);
      });

      test("restore calls Canvas's restore", () {
        CanvasWrapper()
          ..canvas = canvas
          ..restore();
        verify(() => canvas.restore()).called(1);
      });

      test("rotate calls Canvas's rotate", () {
        CanvasWrapper()
          ..canvas = canvas
          ..rotate(0);
        verify(() => canvas.rotate(0)).called(1);
      });

      test("save calls Canvas's save", () {
        CanvasWrapper()
          ..canvas = canvas
          ..save();
        verify(() => canvas.save()).called(1);
      });

      test("saveLayer calls Canvas's saveLayer", () {
        CanvasWrapper()
          ..canvas = canvas
          ..saveLayer(rect, paint);
        verify(() => canvas.saveLayer(rect, paint)).called(1);
      });

      test("scale calls Canvas's scale", () {
        CanvasWrapper()
          ..canvas = canvas
          ..scale(0, 0);
        verify(() => canvas.scale(0, 0)).called(1);
      });

      test("skew calls Canvas's skew", () {
        CanvasWrapper()
          ..canvas = canvas
          ..skew(0, 0);
        verify(() => canvas.skew(0, 0)).called(1);
      });

      test("transform calls Canvas's transform", () {
        CanvasWrapper()
          ..canvas = canvas
          ..transform(float64list);
        verify(() => canvas.transform(float64list)).called(1);
      });

      test("translate calls Canvas's translate", () {
        CanvasWrapper()
          ..canvas = canvas
          ..translate(0, 0);
        verify(() => canvas.translate(0, 0)).called(1);
      });
    });
  });
}
