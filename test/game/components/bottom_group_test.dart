// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

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
        final bottomGroup = BottomGroup();
        await game.ensureAdd(bottomGroup);

        expect(game.contains(bottomGroup), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'one left flipper',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(bottomGroup);

          final leftFlippers =
              bottomGroup.descendants().whereType<Flipper>().where(
                    (flipper) => flipper.side.isLeft,
                  );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'one right flipper',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(bottomGroup);

          final rightFlippers =
              bottomGroup.descendants().whereType<Flipper>().where(
                    (flipper) => flipper.side.isRight,
                  );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'two Baseboards',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(bottomGroup);

          final basebottomGroups =
              bottomGroup.descendants().whereType<Baseboard>();
          expect(basebottomGroups.length, equals(2));
        },
      );

      flameTester.test(
        'two Kickers',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(bottomGroup);

          final kickers = bottomGroup.descendants().whereType<Kicker>();
          expect(kickers.length, equals(2));
        },
      );
    });
  });
}
