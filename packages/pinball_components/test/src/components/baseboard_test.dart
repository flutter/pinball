// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Baseboard', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(TestGame.new);

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        final leftBaseboard = Baseboard(
          side: BoardSide.left,
        )..initialPosition = Vector2(-20, 0);
        final rightBaseboard = Baseboard(
          side: BoardSide.right,
        )..initialPosition = Vector2(20, 0);

        await game.ensureAddAll([leftBaseboard, rightBaseboard]);
        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/baseboard.png'),
        );
      },
    );

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
        'has seven',
        (game) async {
          final baseboard = Baseboard(
            side: BoardSide.left,
          );
          await game.ensureAdd(baseboard);

          expect(baseboard.body.fixtures.length, equals(7));
        },
      );
    });
  });
}
