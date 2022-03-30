// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('Kicker', () {
    // TODO(alestiago): Include golden tests for left and right.
    final flameTester = FlameTester(Forge2DGame.new);

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
