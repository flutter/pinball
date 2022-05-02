// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Slingshot', () {
    final assets = [
      Assets.images.slingshot.upper.keyName,
      Assets.images.slingshot.lower.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.test('loads correctly', (game) async {
      final component = Slingshots();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(Slingshots());
        game.camera.followVector2(Vector2.zero());
        await game.ready();
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/slingshots.png'),
        );
      },
    );

    flameTester.test('adds BumpingBehavior', (game) async {
      final slingshots = Slingshots();
      await game.ensureAdd(slingshots);
      for (final slingshot in slingshots.children) {
        expect(slingshot.firstChild<BumpingBehavior>(), isNotNull);
      }
    });
  });
}
