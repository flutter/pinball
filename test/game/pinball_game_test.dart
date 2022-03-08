// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('PinballGame', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGame.new);

    // TODO(alestiago): test if [PinballGame] registers
    // [BallScorePointsCallback] once the following issue is resolved:
    // https://github.com/flame-engine/flame/issues/1416
    group(
      'components',
      () {
        group('Flippers', () {
          flameTester.test(
            'has only one left flipper',
            (game) {
              final flipper = game.children.firstWhere(
                (e) => e is Flipper && e.side == BoardSide.left,
              ) as Flipper;

              final anotherFlipper = game.children.lastWhere(
                (e) => e is Flipper && e.side == BoardSide.left,
              ) as Flipper;

              expect(flipper, equals(anotherFlipper));
              expect(flipper.side, equals(BoardSide.left));
            },
          );

          flameTester.test(
            'has only one right flipper',
            (game) {
              final flipper = game.children.firstWhere(
                (e) => e is Flipper && e.side == BoardSide.right,
              ) as Flipper;

              final anotherFlipper = game.children.lastWhere(
                (e) => e is Flipper && e.side == BoardSide.right,
              ) as Flipper;

              expect(flipper, equals(anotherFlipper));
              expect(flipper.side, equals(BoardSide.right));
            },
          );
        });
      },
    );
  });
}
