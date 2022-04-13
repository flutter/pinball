// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SparkyComputer', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(SparkyComputer());
        game.camera.followVector2(Vector2(-15, -50));
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky-computer.png'),
        );
      },
    );
  });
}
