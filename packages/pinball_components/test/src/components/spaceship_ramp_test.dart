// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('SpaceshipRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final spaceshipRamp = SpaceshipRamp();
        await game.ensureAdd(spaceshipRamp);

        expect(game.contains(spaceshipRamp), isTrue);
      },
    );

    group('renders correctly', () {
      /*
      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()?.current,
            SpaceshipRampArrowSpriteState.inactive,
          );

          game.camera.followVector2(Vector2(-13, -50));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/inactive.png'),
          );
        },
      );
      */
    });
  });
}
