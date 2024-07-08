// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SpaceshipRail', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.android.rail.main.keyName,
      Assets.images.android.rail.exit.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = SpaceshipRail();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SpaceshipRail>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.world.ensureAdd(SpaceshipRail());
        await tester.pump();

        game.camera.moveTo(Vector2.zero());
        game.camera.viewfinder.zoom = 8;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/spaceship_rail.png'),
        );
      },
    );
  });
}
