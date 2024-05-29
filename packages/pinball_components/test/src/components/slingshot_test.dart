// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
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

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = Slingshots();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Slingshots>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.world.ensureAdd(Slingshots());
        game.camera.moveTo(Vector2.zero());
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

    flameTester.testGameWidget(
      'adds BumpingBehavior',
      setUp: (game, _) async {
        final slingshots = Slingshots();
        await game.ensureAdd(slingshots);
      },
      verify: (game, _) async {
        final slingshots = game.descendants().whereType<Slingshots>().single;
        for (final slingshot in slingshots.children) {
          expect(slingshot.firstChild<BumpingBehavior>(), isNotNull);
        }
      },
    );
  });
}
