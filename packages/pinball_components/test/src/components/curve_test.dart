// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('CurveComponent', () {
    testWithFlameGame('is removed once it finishes', (game) async {
      final curve = CurveComponent(curve: Curves.linear, duration: 1);
      await game.ensureAdd(curve);

      expect(game.firstChild<CurveComponent>(), isNotNull);

      game.update(2);
      game.update(0);
      expect(game.firstChild<CurveComponent>(), isNull);
    });

    testWithFlameGame('completed completes once it finishes', (game) async {
      final curve = CurveComponent(curve: Curves.linear, duration: 1);
      await game.ensureAdd(curve);

      final completed = curve.completed;

      game.update(2);
      expect(completed, completes);
    });
  });
}
