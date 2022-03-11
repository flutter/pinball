// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Baseboard', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final leftBaseboard = Baseboard.left(position: Vector2.zero());
        final rightBaseboard = Baseboard.right(position: Vector2.zero());
        await game.ensureAddAll([leftBaseboard, rightBaseboard]);

        expect(game.contains(leftBaseboard), isTrue);
        expect(game.contains(rightBaseboard), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final baseboard = Baseboard.left(position: position);
          await game.ensureAdd(baseboard);
          game.contains(baseboard);

          expect(baseboard.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final baseboard = Baseboard.left(position: Vector2.zero());
          await game.ensureAdd(baseboard);

          expect(baseboard.body.bodyType, equals(BodyType.static));
        },
      );

      flameTester.test(
        'is at an angle',
        (game) async {
          final leftBaseboard = Baseboard.left(position: Vector2.zero());
          final rightBaseboard = Baseboard.right(position: Vector2.zero());
          await game.ensureAddAll([leftBaseboard, rightBaseboard]);

          expect(leftBaseboard.body.angle, isNegative);
          expect(rightBaseboard.body.angle, isPositive);
        },
      );
    });

    group('fixtures', () {
      flameTester.test(
        'has three',
        (game) async {
          final baseboard = Baseboard.left(position: Vector2.zero());
          await game.ensureAdd(baseboard);

          expect(baseboard.body.fixtures.length, equals(3));
        },
      );
    });
  });
}
