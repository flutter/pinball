// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestCircleComponent extends CircleComponent with ZIndex {
  _TestCircleComponent(Color color)
      : super(
          paint: Paint()..color = color,
          radius: 10,
        );
}

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
}
