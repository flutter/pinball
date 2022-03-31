// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  setUpAll(() {
    registerFallbackValue(Offset.zero);
    registerFallbackValue(Paint());
  });

  group('FireEffect', () {
    flameTester.test('is removed once its particles are done', (game) async {
      await game.ensureAdd(
        FireEffect(
          burstPower: 1,
          position: Vector2.zero(),
          direction: Vector2.all(2),
        ),
      );
      await game.ready();
      expect(game.children.whereType<FireEffect>().length, equals(1));
      game.update(5);

      await game.ready();
      expect(game.children.whereType<FireEffect>().length, equals(0));
    });

    flameTester.test('render circles on the canvas', (game) async {
      final effect = FireEffect(
        burstPower: 1,
        position: Vector2.zero(),
        direction: Vector2.all(2),
      );
      await game.ensureAdd(effect);
      await game.ready();

      final canvas = MockCanvas();
      effect.render(canvas);

      verify(() => canvas.drawCircle(any(), any(), any())).called(
        greaterThan(0),
      );
    });
  });
}
