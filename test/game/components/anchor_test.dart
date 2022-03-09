// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Anchor', () {
    final flameTester = FlameTester(PinballGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        final anchor = Anchor(position: Vector2.zero());
        await game.ensureAdd(anchor);

        expect(game.contains(anchor), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final anchor = Anchor(position: position);
          await game.ensureAdd(anchor);
          game.contains(anchor);

          expect(anchor.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final anchor = Anchor(position: Vector2.zero());
          await game.ensureAdd(anchor);

          expect(anchor.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixtures', () {
      flameTester.test(
        'has none',
        (game) async {
          final anchor = Anchor(position: Vector2.zero());
          await game.ensureAdd(anchor);

          expect(anchor.body.fixtures, isEmpty);
        },
      );
    });
  });
}
