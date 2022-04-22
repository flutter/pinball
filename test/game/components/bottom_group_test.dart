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
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

  group('BottomGroup', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final boattomGroup = BottomGroup();
        await game.ready();
        await game.ensureAdd(boattomGroup);

        expect(game.contains(boattomGroup), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'one left flipper',
        (game) async {
          final boattomGroup = BottomGroup();
          await game.ready();
          await game.ensureAdd(boattomGroup);

          final leftFlippers =
              boattomGroup.descendants().whereType<Flipper>().where(
                    (flipper) => flipper.side.isLeft,
                  );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'one right flipper',
        (game) async {
          final boattomGroup = BottomGroup();
          await game.ready();
          await game.ensureAdd(boattomGroup);
          final rightFlippers =
              boattomGroup.descendants().whereType<Flipper>().where(
                    (flipper) => flipper.side.isRight,
                  );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'two Baseboards',
        (game) async {
          final boattomGroup = BottomGroup();
          await game.ready();
          await game.ensureAdd(boattomGroup);

          final baseboattomGroups =
              boattomGroup.descendants().whereType<Baseboard>();
          expect(baseboattomGroups.length, equals(2));
        },
      );

      flameTester.test(
        'two Kickers',
        (game) async {
          final boattomGroup = BottomGroup();
          await game.ready();
          await game.ensureAdd(boattomGroup);

          final kickers = boattomGroup.descendants().whereType<Kicker>();
          expect(kickers.length, equals(2));
        },
      );
    });
  });
}
