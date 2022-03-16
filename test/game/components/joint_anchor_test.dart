// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('JointAnchor', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final anchor = JointAnchor();
        await game.ready();
        await game.ensureAdd(anchor);

        expect(game.contains(anchor), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is static',
        (game) async {
          await game.ready();
          final anchor = JointAnchor();
          await game.ensureAdd(anchor);

          expect(anchor.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixtures', () {
      flameTester.test(
        'has none',
        (game) async {
          final anchor = JointAnchor();
          await game.ensureAdd(anchor);

          expect(anchor.body.fixtures, isEmpty);
        },
      );
    });
  });
}
