// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('SlingShot', () {
    // TODO(alestiago): Include golden tests for left and right.
    final flameTester = FlameTester(Forge2DGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final slingShot = SlingShot(
          side: BoardSide.left,
        );
        await game.ensureAdd(slingShot);

        expect(game.contains(slingShot), isTrue);
      },
    );

    flameTester.test(
      'body is static',
      (game) async {
        final slingShot = SlingShot(
          side: BoardSide.left,
        );
        await game.ensureAdd(slingShot);

        expect(slingShot.body.bodyType, equals(BodyType.static));
      },
    );

    flameTester.test(
      'has restitution',
      (game) async {
        final slingShot = SlingShot(
          side: BoardSide.left,
        );
        await game.ensureAdd(slingShot);

        final totalRestitution = slingShot.body.fixtures.fold<double>(
          0,
          (total, fixture) => total + fixture.restitution,
        );
        expect(totalRestitution, greaterThan(0));
      },
    );

    flameTester.test(
      'has no friction',
      (game) async {
        final slingShot = SlingShot(
          side: BoardSide.left,
        );
        await game.ensureAdd(slingShot);

        final totalFriction = slingShot.body.fixtures.fold<double>(
          0,
          (total, fixture) => total + fixture.friction,
        );
        expect(totalFriction, equals(0));
      },
    );
  });
}
