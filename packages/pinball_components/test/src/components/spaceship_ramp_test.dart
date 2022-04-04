// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SpaceshipRamp', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(TestGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final spaceshipEntranceRamp = SpaceshipRamp();
        await game.addFromBlueprint(spaceshipEntranceRamp);
        await game.ready();

        for (final element in spaceshipEntranceRamp.components) {
          expect(game.contains(element), isTrue);
        }
      },
    );
  });
}
