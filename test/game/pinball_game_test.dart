// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
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
          bool Function(Component) flipperSelector(BoardSide side) =>
              (component) => component is Flipper && component.side == side;

          flameTester.test(
            'has only one left Flipper',
            (game) async {
              await game.ready();

              expect(
                () => game.children.singleWhere(
                  flipperSelector(BoardSide.left),
                ),
                returnsNormally,
              );
            },
          );

          flameTester.test(
            'has only one right Flipper',
            (game) async {
              await game.ready();

              expect(
                () => game.children.singleWhere(
                  flipperSelector(BoardSide.right),
                ),
                returnsNormally,
              );
            },
          );
        });
      },
    );
  });
}
