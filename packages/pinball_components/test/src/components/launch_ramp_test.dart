// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LaunchRamp', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.launchRamp.ramp.keyName,
      Assets.images.launchRamp.backgroundRailing.keyName,
      Assets.images.launchRamp.foregroundRailing.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = LaunchRamp();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<LaunchRamp>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.world.ensureAdd(LaunchRamp());
        game.camera.moveTo(Vector2.zero());
        game.camera.viewfinder.zoom = 4.1;
        await game.ready();
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/launch_ramp.png'),
        );
      },
    );
  });
}
