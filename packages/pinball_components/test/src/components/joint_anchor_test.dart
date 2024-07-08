// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('JointAnchor', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final anchor = JointAnchor();
        await game.ready();
        await game.ensureAdd(anchor);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<JointAnchor>().length, equals(1));
      },
    );

    group('body', () {
      flameTester.testGameWidget(
        'is static',
        setUp: (game, _) async {
          await game.ready();
          final anchor = JointAnchor();
          await game.ensureAdd(anchor);
        },
        verify: (game, _) async {
          final anchor = game.descendants().whereType<JointAnchor>().single;

          expect(anchor.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixtures', () {
      flameTester.testGameWidget(
        'has none',
        setUp: (game, _) async {
          final anchor = JointAnchor();
          await game.ensureAdd(anchor);
        },
        verify: (game, _) async {
          final anchor = game.descendants().whereType<JointAnchor>().single;

          expect(anchor.body.fixtures, isEmpty);
        },
      );
    });
  });
}
