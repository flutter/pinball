// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DinoWalls', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.dino.topWall.keyName,
      Assets.images.dino.topWallTunnel.keyName,
      Assets.images.dino.bottomWall.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = DinoWalls();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<DinoWalls>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.onLoad();
        await game.images.loadAll(assets);
        await game.world.ensureAdd(DinoWalls());

        game.camera.moveTo(Vector2.zero());
        game.camera.viewfinder.zoom = 6.5;
        await game.ready();
      },
      verify: (game, tester) async {
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/dino_walls.png'),
        );
      },
    );
  });
}
