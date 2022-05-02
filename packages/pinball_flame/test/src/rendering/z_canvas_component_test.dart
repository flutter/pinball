// ignore_for_file: cascade_invocations

import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestCircleComponent extends CircleComponent with ZIndex {
  _TestCircleComponent(Color color)
      : super(
          paint: Paint()..color = color,
          radius: 10,
        );
}

class _MockCanvas extends Mock implements Canvas {}

class _MockImage extends Mock implements Image {}

class _MockPicture extends Mock implements Picture {}

class _MockParagraph extends Mock implements Paragraph {}

class _MockVertices extends Mock implements Vertices {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(FlameGame.new);
  const goldenPrefix = 'golden/rendering/';

  group('ZCanvasComponent', () {
    flameTester.test('loads correctly', (game) async {
      final component = ZCanvasComponent();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'red circle renders behind blue circle',
      setUp: (game, tester) async {
        final canvas = ZCanvasComponent(
          children: [
            _TestCircleComponent(Colors.blue)..zIndex = 1,
            _TestCircleComponent(Colors.red)..zIndex = 0,
          ],
        );
        await game.ensureAdd(canvas);

        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<FlameGame>(),
          matchesGoldenFile('${goldenPrefix}red_blue.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'blue circle renders behind red circle',
      setUp: (game, tester) async {
        final canvas = ZCanvasComponent(
          children: [
            _TestCircleComponent(Colors.blue)..zIndex = 0,
            _TestCircleComponent(Colors.red)..zIndex = 1
          ],
        );
        await game.ensureAdd(canvas);

        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<FlameGame>(),
          matchesGoldenFile('${goldenPrefix}blue_red.png'),
        );
      },
    );
  });

  group('ZCanvas', () {
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
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.clipPath(path, doAntiAlias: false);
      verify(
        () => canvas.clipPath(path, doAntiAlias: false),
      ).called(1);
    });

    test("clipRRect calls Canvas's clipRRect", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.clipRRect(rRect, doAntiAlias: false);
      verify(
        () => canvas.clipRRect(rRect, doAntiAlias: false),
      ).called(1);
    });

    test("clipRect calls Canvas's clipRect", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.clipRect(rect, doAntiAlias: false);
      verify(
        () => canvas.clipRect(rect, doAntiAlias: false),
      ).called(1);
    });

    test("drawArc calls Canvas's drawArc", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawArc(rect, 0, 1, false, paint);
      verify(
        () => canvas.drawArc(rect, 0, 1, false, paint),
      ).called(1);
    });

    test("drawAtlas calls Canvas's drawAtlas", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawAtlas(atlas, [], [], [], blendMode, rect, paint);
      verify(
        () => canvas.drawAtlas(atlas, [], [], [], blendMode, rect, paint),
      ).called(1);
    });

    test("drawCircle calls Canvas's drawCircle", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawCircle(offset, 0, paint);
      verify(
        () => canvas.drawCircle(offset, 0, paint),
      ).called(1);
    });

    test("drawColor calls Canvas's drawColor", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawColor(color, blendMode);
      verify(
        () => canvas.drawColor(color, blendMode),
      ).called(1);
    });

    test("drawDRRect calls Canvas's drawDRRect", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawDRRect(rRect, rRect, paint);
      verify(
        () => canvas.drawDRRect(rRect, rRect, paint),
      ).called(1);
    });

    test("drawImage calls Canvas's drawImage", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawImage(atlas, offset, paint);
      verify(
        () => canvas.drawImage(atlas, offset, paint),
      ).called(1);
    });

    test("drawImageNine calls Canvas's drawImageNine", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawImageNine(atlas, rect, rect, paint);
      verify(
        () => canvas.drawImageNine(atlas, rect, rect, paint),
      ).called(1);
    });

    test("drawImageRect calls Canvas's drawImageRect", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawImageRect(atlas, rect, rect, paint);
      verify(
        () => canvas.drawImageRect(atlas, rect, rect, paint),
      ).called(1);
    });

    test("drawLine calls Canvas's drawLine", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawLine(offset, offset, paint);
      verify(
        () => canvas.drawLine(offset, offset, paint),
      ).called(1);
    });

    test("drawOval calls Canvas's drawOval", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawOval(rect, paint);
      verify(
        () => canvas.drawOval(rect, paint),
      ).called(1);
    });

    test("drawPaint calls Canvas's drawPaint", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawPaint(paint);
      verify(
        () => canvas.drawPaint(paint),
      ).called(1);
    });

    test("drawParagraph calls Canvas's drawParagraph", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawParagraph(paragraph, offset);
      verify(
        () => canvas.drawParagraph(paragraph, offset),
      ).called(1);
    });

    test("drawPath calls Canvas's drawPath", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawPath(path, paint);
      verify(
        () => canvas.drawPath(path, paint),
      ).called(1);
    });

    test("drawPicture calls Canvas's drawPicture", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawPicture(picture);
      verify(
        () => canvas.drawPicture(picture),
      ).called(1);
    });

    test("drawPoints calls Canvas's drawPoints", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawPoints(PointMode.points, [offset], paint);
      verify(
        () => canvas.drawPoints(PointMode.points, [offset], paint),
      ).called(1);
    });

    test("drawRRect calls Canvas's drawRRect", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawRRect(rRect, paint);
      verify(
        () => canvas.drawRRect(rRect, paint),
      ).called(1);
    });

    test("drawRawAtlas calls Canvas's drawRawAtlas", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawRawAtlas(
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
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawRawPoints(PointMode.points, float32list, paint);
      verify(
        () => canvas.drawRawPoints(PointMode.points, float32list, paint),
      ).called(1);
    });

    test("drawRect calls Canvas's drawRect", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawRect(rect, paint);
      verify(
        () => canvas.drawRect(rect, paint),
      ).called(1);
    });

    test("drawShadow calls Canvas's drawShadow", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawShadow(path, color, 0, false);
      verify(
        () => canvas.drawShadow(path, color, 0, false),
      ).called(1);
    });

    test("drawVertices calls Canvas's drawVertices", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.drawVertices(vertices, blendMode, paint);
      verify(
        () => canvas.drawVertices(vertices, blendMode, paint),
      ).called(1);
    });

    test("getSaveCount calls Canvas's getSaveCount", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      when(() => canvas.getSaveCount()).thenReturn(1);
      zcanvas.getSaveCount();
      verify(() => canvas.getSaveCount()).called(1);
    });

    test("restore calls Canvas's restore", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.restore();
      verify(() => canvas.restore()).called(1);
    });

    test("rotate calls Canvas's rotate", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.rotate(0);
      verify(() => canvas.rotate(0)).called(1);
    });

    test("save calls Canvas's save", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.save();
      verify(() => canvas.save()).called(1);
    });

    test("saveLayer calls Canvas's saveLayer", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.saveLayer(rect, paint);
      verify(() => canvas.saveLayer(rect, paint)).called(1);
    });

    test("scale calls Canvas's scale", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.scale(0, 0);
      verify(() => canvas.scale(0, 0)).called(1);
    });

    test("skew calls Canvas's skew", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.skew(0, 0);
      verify(() => canvas.skew(0, 0)).called(1);
    });

    test("transform calls Canvas's transform", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.transform(float64list);
      verify(() => canvas.transform(float64list)).called(1);
    });

    test("translate calls Canvas's translate", () {
      final zcanvas = ZCanvas()..canvas = canvas;
      zcanvas.translate(0, 0);
      verify(() => canvas.translate(0, 0)).called(1);
    });
  });
}
