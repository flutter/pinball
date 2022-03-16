// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('Baseboard', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(Forge2DGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final leftBaseboard = Baseboard(
          side: BoardSide.left,
        );
        final rightBaseboard = Baseboard(
          side: BoardSide.right,
        );

        await game.ensureAddAll([leftBaseboard, rightBaseboard]);

        expect(game.contains(leftBaseboard), isTrue);
        expect(game.contains(rightBaseboard), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is static',
        (game) async {
          final baseboard = Baseboard(
            side: BoardSide.left,
          );

          await game.ensureAdd(baseboard);

          expect(baseboard.body.bodyType, equals(BodyType.static));
        },
      );

      flameTester.test(
        'is at an angle',
        (game) async {
          final leftBaseboard = Baseboard(
            side: BoardSide.left,
          );
          final rightBaseboard = Baseboard(
            side: BoardSide.right,
          );
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
          final baseboard = Baseboard(
            side: BoardSide.left,
          );
          await game.ensureAdd(baseboard);

          expect(baseboard.body.fixtures.length, equals(3));
        },
      );
    });
  });
}
