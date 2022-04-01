// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DinoWalls', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(TestGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final dinoWalls = DinoWalls(position: Vector2.zero());
        await game.addFromBlueprint(dinoWalls);
        await game.ready();

        for (final wall in dinoWalls.components) {
          expect(game.contains(wall), isTrue);
        }
      },
    );

    group('DinoTopWall', () {
      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          await game.ensureAdd(
            DinoTopWall()..initialPosition = Vector2(0, -50),
          );
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<Forge2DGame>(),
            matchesGoldenFile('golden/dino-top-wall.png'),
          );
        },
      );
    });

    group('DinoBottomWall', () {
      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          await game.ensureAdd(
            DinoBottomWall()..initialPosition = Vector2(0, -12),
          );
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<Forge2DGame>(),
            matchesGoldenFile('golden/dino-bottom-wall.png'),
          );
        },
      );
    });
  });
}
