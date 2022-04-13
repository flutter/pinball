// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Kicker', () {
    final flameTester = FlameTester(TestGame.new);

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        final leftKicker = Kicker(
          side: BoardSide.left,
        )..initialPosition = Vector2(-20, 0);
        final rightKicker = Kicker(
          side: BoardSide.right,
        )..initialPosition = Vector2(20, 0);

        await game.ensureAddAll([leftKicker, rightKicker]);
        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/kickers.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);

        expect(game.contains(kicker), isTrue);
      },
    );

    flameTester.test(
      'body is static',
      (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);

        expect(kicker.body.bodyType, equals(BodyType.static));
      },
    );

    flameTester.test(
      'has restitution',
      (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);

        final totalRestitution = kicker.body.fixtures.fold<double>(
          0,
          (total, fixture) => total + fixture.restitution,
        );
        expect(totalRestitution, greaterThan(0));
      },
    );

    flameTester.test(
      'has no friction',
      (game) async {
        final kicker = Kicker(
          side: BoardSide.left,
        );
        await game.ensureAdd(kicker);

        final totalFriction = kicker.body.fixtures.fold<double>(
          0,
          (total, fixture) => total + fixture.friction,
        );
        expect(totalFriction, equals(0));
      },
    );
  });
}
