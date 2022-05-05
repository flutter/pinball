// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/src/canvas/canvas_component.dart';

class _TestSpriteComponent extends SpriteComponent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CanvasComponent', () {
    final flameTester = FlameTester(FlameGame.new);

    test('can be instantiated', () {
      expect(
        CanvasComponent(),
        isA<CanvasComponent>(),
      );
    });

    flameTester.test('loads correctly', (game) async {
      final component = CanvasComponent();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.test(
      'adds children',
      (game) async {
        final component = Component();
        final canvas = CanvasComponent(
          onSpritePainted: (paint) => paint.filterQuality = FilterQuality.high,
          children: [component],
        );

        await game.ensureAdd(canvas);

        expect(
          canvas.children.contains(component),
          isTrue,
        );
      },
    );

    flameTester.testGameWidget(
      'calls onSpritePainted when paiting a sprite',
      setUp: (game, tester) async {
        final spriteComponent = _TestSpriteComponent();

        final completer = Completer<Image>();
        decodeImageFromList(
          Uint8List.fromList(_image),
          completer.complete,
        );
        spriteComponent.sprite = Sprite(await completer.future);

        var calls = 0;
        final canvas = CanvasComponent(
          onSpritePainted: (paint) => calls++,
          children: [spriteComponent],
        );

        await game.ensureAdd(canvas);
        await tester.pump();

        expect(calls, equals(1));
      },
    );
  });
}

const List<int> _image = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
