// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Baseboard', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.baseboard.left.keyName,
      Assets.images.baseboard.right.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final leftBaseboard = Baseboard(
          side: BoardSide.left,
        )..initialPosition = Vector2(-20, 0);
        final rightBaseboard = Baseboard(
          side: BoardSide.right,
        )..initialPosition = Vector2(20, 0);

        await game.world.ensureAddAll([leftBaseboard, rightBaseboard]);
        game.camera.moveTo(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/baseboard.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.ready();
        final leftBaseboard = Baseboard(
          side: BoardSide.left,
        );
        final rightBaseboard = Baseboard(
          side: BoardSide.right,
        );

        await game.ensureAddAll([leftBaseboard, rightBaseboard]);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Baseboard>().length, equals(2));
      },
    );

    group('body', () {
      flameTester.testGameWidget(
        'is static',
        setUp: (game, _) async {
          final baseboard = Baseboard(
            side: BoardSide.left,
          );

          await game.ensureAdd(baseboard);
        },
        verify: (game, _) async {
          final baseboard = game.descendants().whereType<Baseboard>().single;
          expect(baseboard.body.bodyType, equals(BodyType.static));
        },
      );

      flameTester.testGameWidget(
        'is at an angle',
        setUp: (game, _) async {
          final leftBaseboard = Baseboard(
            side: BoardSide.left,
          );
          final rightBaseboard = Baseboard(
            side: BoardSide.right,
          );
          await game.ensureAddAll([leftBaseboard, rightBaseboard]);
        },
        verify: (game, _) async {
          final baseboards = game.descendants().whereType<Baseboard>().toList();

          expect(baseboards[0].body.angle, isPositive);
          expect(baseboards[1].body.angle, isNegative);
        },
      );
    });

    group('fixtures', () {
      flameTester.testGameWidget(
        'has seven',
        setUp: (game, _) async {
          final baseboard = Baseboard(
            side: BoardSide.left,
          );
          await game.ensureAdd(baseboard);
        },
        verify: (game, _) async {
          final baseboard = game.descendants().whereType<Baseboard>().single;
          expect(baseboard.body.fixtures.length, equals(7));
        },
      );
    });
  });
}
