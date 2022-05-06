// ignore_for_file: cascade_invocations

import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

void main() {
  final flameTester = FlameTester(
    () => PinballForge2DGame(gravity: Vector2.zero()),
  );

  group('PinballForge2DGame', () {
    test('can instantiate', () {
      expect(
        () => PinballForge2DGame(gravity: Vector2.zero()),
        returnsNormally,
      );
    });

    flameTester.test(
      'screenToFlameWorld throws UnimpelementedError',
      (game) async {
        expect(
          () => game.screenToFlameWorld(Vector2.zero()),
          throwsUnimplementedError,
        );
      },
    );

    flameTester.test(
      'screenToWorld throws UnimpelementedError',
      (game) async {
        expect(
          () => game.screenToWorld(Vector2.zero()),
          throwsUnimplementedError,
        );
      },
    );

    flameTester.test(
      'worldToScreen throws UnimpelementedError',
      (game) async {
        expect(
          () => game.worldToScreen(Vector2.zero()),
          throwsUnimplementedError,
        );
      },
    );

    group('clampDt', () {
      test('returns dt', () {
        const dt = 0.0001;
        expect(PinballForge2DGame.clampDt(dt), equals(dt));
      });

      test('returns result of 1/60 as dt is to high', () {
        const dt = 1.0;
        expect(PinballForge2DGame.clampDt(dt), equals(1 / 60));
      });
    });
  });
}
