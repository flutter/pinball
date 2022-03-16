// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('BottomGroup', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final bottomGroup = BottomGroup(position: Vector2.zero(), spacing: 0);
        await game.ready();
        await game.ensureAdd(bottomGroup);

        expect(game.contains(bottomGroup), isTrue);
      },
    );

    group('children', () {
      flameTester.test(
        'has one left flipper',
        (game) async {
          final bottomGroup = BottomGroup(position: Vector2.zero(), spacing: 0);
          await game.ready();
          await game.ensureAdd(bottomGroup);

          final leftFlippers = bottomGroup.findNestedChildren<Flipper>(
            condition: (flipper) => flipper.side.isLeft,
          );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'has one right flipper',
        (game) async {
          final bottomGroup = BottomGroup(position: Vector2.zero(), spacing: 0);
          await game.ready();
          await game.ensureAdd(bottomGroup);

          final rightFlippers = bottomGroup.findNestedChildren<Flipper>(
            condition: (flipper) => flipper.side.isRight,
          );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'has two Baseboards',
        (game) async {
          final bottomGroup = BottomGroup(position: Vector2.zero(), spacing: 0);
          await game.ready();
          await game.ensureAdd(bottomGroup);

          final baseboards = bottomGroup.findNestedChildren<Baseboard>();
          expect(baseboards.length, equals(2));
        },
      );

      flameTester.test(
        'has two SlingShots',
        (game) async {
          final bottomGroup = BottomGroup(position: Vector2.zero(), spacing: 0);
          await game.ready();
          await game.ensureAdd(bottomGroup);

          final slingShots = bottomGroup.findNestedChildren<SlingShot>();
          expect(slingShots.length, equals(2));
        },
      );
    });
  });
}
