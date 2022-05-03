// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
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

    flameTester.test('loads correctly', (game) async {
      final component = LaunchRamp();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(LaunchRamp());
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 4.1;
        await game.ready();
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/launch-ramp.png'),
        );
      },
    );
  });
}
