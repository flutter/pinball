// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.baseboard.left.keyName,
    Assets.images.baseboard.right.keyName,
    Assets.images.flipper.left.keyName,
    Assets.images.flipper.right.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('BottomGroup', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.addFromBlueprint(BottomGroup());
        await game.ready();
      },
    );

    group('loads', () {
      flameTester.test(
        'one left flipper',
        (game) async {
          await game.addFromBlueprint(BottomGroup());
          await game.ready();

          final leftFlippers = game.descendants().whereType<Flipper>().where(
                (flipper) => flipper.side.isLeft,
              );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'one right flipper',
        (game) async {
          await game.addFromBlueprint(BottomGroup());
          await game.ready();

          final rightFlippers = game.descendants().whereType<Flipper>().where(
                (flipper) => flipper.side.isRight,
              );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'two Baseboards',
        (game) async {
          await game.addFromBlueprint(BottomGroup());
          await game.ready();

          final basebottomGroups = game.descendants().whereType<Baseboard>();
          expect(basebottomGroups.length, equals(2));
        },
      );

      flameTester.test(
        'two Kickers',
        (game) async {
          await game.addFromBlueprint(BottomGroup());
          await game.ready();

          final kickers = game.descendants().whereType<Kicker>();
          expect(kickers.length, equals(2));
        },
      );
    });
  });
}
