// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LaunchRamp', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(LaunchRamp());
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 4.1;
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
