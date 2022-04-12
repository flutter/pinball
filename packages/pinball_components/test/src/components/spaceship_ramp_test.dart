// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SpaceshipRamp', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(SpaceshipRamp());
        await game.ready();
        game.camera.followVector2(Vector2(-13, -50));
      },
      // TODO(allisonryan0002): enable test when workflows are fixed.
      // verify: (game, tester) async {
      //   await expectLater(
      //     find.byGame<Forge2DGame>(),
      //     matchesGoldenFile('golden/spaceship-ramp.png'),
      //   );
      // },
    );
  });
}
