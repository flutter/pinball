// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DinoWalls', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(TestGame.new);

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(DinoWalls());
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 6.5;
        await game.ready();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/dino-walls.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final dinoWalls = DinoWalls();
        await game.addFromBlueprint(dinoWalls);
        await game.ready();

        for (final wall in dinoWalls.components) {
          expect(game.contains(wall), isTrue);
        }
      },
    );
  });
}
