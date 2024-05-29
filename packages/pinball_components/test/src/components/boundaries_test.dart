// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Boundaries', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final assets = [
      Assets.images.boundary.outer.keyName,
      Assets.images.boundary.outerBottom.keyName,
      Assets.images.boundary.bottom.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = Boundaries();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Boundaries>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'render correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final canvas = ZCanvasComponent(children: [Boundaries()]);
        await game.world.ensureAdd(canvas);

        game.camera.moveTo(Vector2.zero());
        game.camera.viewfinder.zoom = 3.2;
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/boundaries.png'),
        );
      },
    );
  });
}
