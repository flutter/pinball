// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.dash.animatronic.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
    Assets.images.baseboard.left.keyName,
    Assets.images.baseboard.right.keyName,
    Assets.images.flipper.left.keyName,
    Assets.images.flipper.right.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

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

    group('loads', () {
      flameTester.test(
        'one left flipper',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final leftFlippers = board.descendants().whereType<Flipper>().where(
                (flipper) => flipper.side.isLeft,
              );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'one right flipper',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);
          final rightFlippers = board.descendants().whereType<Flipper>().where(
                (flipper) => flipper.side.isRight,
              );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'two Baseboards',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final baseboards = board.descendants().whereType<Baseboard>();
          expect(baseboards.length, equals(2));
        },
      );

      flameTester.test(
        'two Kickers',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final kickers = board.descendants().whereType<Kicker>();
          expect(kickers.length, equals(2));
        },
      );

      flameTester.test(
        'one FlutterForest',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final flutterForest = board.descendants().whereType<FlutterForest>();
          expect(flutterForest.length, equals(1));
        },
      );

      flameTester.test(
        'one ChromeDino',
        (game) async {
          final board = Board();
          await game.ready();
          await game.ensureAdd(board);

          final chromeDino = board.descendants().whereType<ChromeDino>();
          expect(chromeDino.length, equals(1));
        },
      );
    });
  });
}
