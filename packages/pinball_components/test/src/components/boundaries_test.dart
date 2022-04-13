// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Boundaries', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'render correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(Boundaries());
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 3.9;
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
