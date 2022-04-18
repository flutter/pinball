// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Slingshot', () {
    final flameTester = FlameTester(TestGame.new);
    const length = 2.0;
    const angle = 0.0;
    final spritePath = Assets.images.slingshot.upper.keyName;

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(Slingshots());
        game.camera.followVector2(Vector2.zero());
        await game.ready();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/slingshots.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final slingshot = Slingshot(
          length: length,
          angle: angle,
          spritePath: spritePath,
        );
        await game.ensureAdd(slingshot);

        expect(game.contains(slingshot), isTrue);
      },
    );

    flameTester.test(
      'body is static',
      (game) async {
        final slingshot = Slingshot(
          length: length,
          angle: angle,
          spritePath: spritePath,
        );
        await game.ensureAdd(slingshot);

        expect(slingshot.body.bodyType, equals(BodyType.static));
      },
    );

    flameTester.test(
      'has restitution',
      (game) async {
        final slingshot = Slingshot(
          length: length,
          angle: angle,
          spritePath: spritePath,
        );
        await game.ensureAdd(slingshot);

        final totalRestitution = slingshot.body.fixtures.fold<double>(
          0,
          (total, fixture) => total + fixture.restitution,
        );
        expect(totalRestitution, greaterThan(0));
      },
    );

    flameTester.test(
      'has no friction',
      (game) async {
        final slingshot = Slingshot(
          length: length,
          angle: angle,
          spritePath: spritePath,
        );
        await game.ensureAdd(slingshot);

        final totalFriction = slingshot.body.fixtures.fold<double>(
          0,
          (total, fixture) => total + fixture.friction,
        );
        expect(totalFriction, equals(0));
      },
    );
  });
}
