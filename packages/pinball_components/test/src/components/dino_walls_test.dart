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
    final assets = [
      Assets.images.dino.dinoLandTop.keyName,
      Assets.images.dino.dinoLandBottom.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.addFromBlueprint(DinoWalls());
        await game.ready();

        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 6.5;

        await tester.pump();
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
