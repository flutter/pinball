import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';

class MockPinballGame extends Mock implements PinballGame {}

class MockWall extends Mock implements Wall {}

class MockBall extends Mock implements Ball {}

class MockContact extends Mock implements Contact {}

class MockGameBloc extends Mock implements GameBloc {}

void main() {
  // TODO(alestiago): test if [PinballGame] registers
  // [BallScorePointsCallback] once the following issue is resolved:
  // https://github.com/flame-engine/flame/issues/1416
  group('PinballGame', () {
    group('BallWallContactCallback', () {
      test('removes the ball on begin contact', () {
        final game = MockPinballGame();
        final wall = MockWall();
        final ball = MockBall();

        when(() => ball.gameRef).thenReturn(game);

        BallWallContactCallback()
          // Remove once https://github.com/flame-engine/flame/pull/1415
          // is merged
          ..end(MockBall(), MockWall(), MockContact())
          ..begin(ball, wall, MockContact());

        verify(() => ball.shouldRemove = true).called(1);
      });
    });

    group('resetting a ball', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      FlameTester(
        PinballGame.new,
        pumpWidget: (gameWidget, tester) async {
          await tester.pumpWidget(
            BlocProvider.value(
              value: gameBloc,
              child: gameWidget,
            ),
          );
        },
      )
        ..widgetTest('adds BallLost to GameBloc', (game, tester) async {
          await game.ready();

          game.children.whereType<Ball>().first.removeFromParent();
          await tester.pump();

          verify(() => gameBloc.add(const BallLost())).called(1);
        })
        ..widgetTest(
          'resets the ball if the game is not over',
          (game, tester) async {
            await game.ready();

            game.children.whereType<Ball>().first.removeFromParent();
            await game.ready(); // Making sure that all additions are done

            expect(
              game.children.whereType<Ball>().length,
              equals(1),
            );
          },
        )
        ..widgetTest(
          'no ball is added on game over',
          (game, tester) async {
            whenListen(
              gameBloc,
              const Stream<GameState>.empty(),
              initialState: const GameState(score: 10, balls: 1),
            );
            await game.ready();

            game.children.whereType<Ball>().first.removeFromParent();
            await tester.pump();

            expect(
              game.children.whereType<Ball>().length,
              equals(0),
            );
          },
        );
    });
  });
}
