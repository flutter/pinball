// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
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

    flameTester.test('loads correctly', (game) async {
      final component = Boundaries();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'render correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final canvas = ZCanvasComponent(children: [Boundaries()]);
        await game.ensureAdd(canvas);

        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 3.2;
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
