// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('Board', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final board = Board();
        await game.ready();
        await game.ensureAdd(board);

        expect(game.contains(board), isTrue);
      },
    );

    group('children', () {
      flameTester.test(
        'has one left flipper',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final leftFlippers = board.findNestedChildren<Flipper>(
            condition: (flipper) => flipper.side.isLeft,
          );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'has one right flipper',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final rightFlippers = board.findNestedChildren<Flipper>(
            condition: (flipper) => flipper.side.isRight,
          );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'has two Baseboards',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final baseboards = board.findNestedChildren<Baseboard>();
          expect(baseboards.length, equals(2));
        },
      );

      flameTester.test(
        'has two Kickers',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final kickers = board.findNestedChildren<Kicker>();
          expect(kickers.length, equals(2));
        },
      );

      flameTester.test(
        'has three RoundBumpers',
        (game) async {
          // TODO(alestiago): change to [NestBumpers] once provided.
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final roundBumpers = board.findNestedChildren<RoundBumper>();
          expect(roundBumpers.length, equals(3));
        },
      );
    });
  });
}
