// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../helpers/helpers.dart';

void main() {
  group('PinballGame', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(PinballGameTest.create);
    final debugModeFlameTester = FlameTester(DebugPinballGameTest.create);

    // TODO(alestiago): test if [PinballGame] registers
    // [BallScorePointsCallback] once the following issue is resolved:
    // https://github.com/flame-engine/flame/issues/1416
    group('components', () {
      bool Function(Component) componentSelector<T>() =>
          (component) => component is T;

      flameTester.test(
        'has three Walls',
        (game) async {
          await game.ready();
          final walls = game.children
              .where(
                (component) => component is Wall && component is! BottomWall,
              )
              .toList();
          // TODO(allisonryan0002): expect 3 when launch track is added and
          // temporary wall is removed.
          expect(walls.length, 4);
        },
      );

      flameTester.test(
        'has only one BottomWall',
        (game) async {
          await game.ready();

          expect(
            () => game.children.singleWhere(
              componentSelector<BottomWall>(),
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test(
        'has only one Plunger',
        (game) async {
          await game.ready();

          expect(
            () => game.children.singleWhere(
              (component) => component is Plunger,
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test('has only one FlipperGroup', (game) async {
        await game.ready();

        expect(
          () => game.children.singleWhere(
            (component) => component is FlipperGroup,
          ),
          returnsNormally,
        );
      });
    });

    debugModeFlameTester.test('adds a ball on tap up', (game) async {
      await game.ready();

      final eventPosition = MockEventPosition();
      when(() => eventPosition.game).thenReturn(Vector2.all(10));

      final tapUpEvent = MockTapUpInfo();
      when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);

      game.onTapUp(tapUpEvent);
      await game.ready();

      expect(
        game.children.whereType<Ball>().length,
        equals(1),
      );
    });
  });
}
