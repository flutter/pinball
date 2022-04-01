// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('BonusBallController', () {
    late Ball ball;

    setUp(() {
      ball = Ball(baseColor: const Color(0xFF00FFFF));
    });

    test('can be instantiated', () {
      expect(
        BonusBallController(ball),
        isA<BonusBallController>(),
      );
    });

    flameTester.test(
      'lost removes ball',
      (game) async {
        await game.add(ball);
        final controller = BonusBallController(ball);
        await ball.ensureAdd(controller);

        controller.lost();
        await game.ready();

        expect(game.contains(ball), isFalse);
      },
    );
  });

  group('LaunchedBallController', () {
    test('can be instantiated', () {
      expect(
        LaunchedBallController(MockBall()),
        isA<LaunchedBallController>(),
      );
    });

    group('description', () {
      late Ball ball;
      late GameBloc gameBloc;

      setUp(() {
        ball = Ball(baseColor: const Color(0xFF00FFFF));
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
        gameBuilder: PinballGameTest.create,
        blocBuilder: () => gameBloc,
      );

      flameBlocTester.testGameWidget(
        'lost adds BallLost to GameBloc',
        setUp: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await ball.add(controller);
          await game.ensureAdd(ball);

          controller.lost();
        },
        verify: (game, tester) async {
          verify(() => gameBloc.add(const BallLost())).called(1);
        },
      );

      group('listenWhen', () {
        flameBlocTester.testGameWidget(
          'listens when a ball has been lost',
          setUp: (game, tester) async {
            final controller = LaunchedBallController(ball);

            await ball.add(controller);
            await game.ensureAdd(ball);
          },
          verify: (game, tester) async {
            final controller =
                game.descendants().whereType<LaunchedBallController>().first;

            final previousState = MockGameState();
            final newState = MockGameState();
            when(() => previousState.balls).thenReturn(3);
            when(() => newState.balls).thenReturn(2);

            expect(controller.listenWhen(previousState, newState), isTrue);
          },
        );

        flameBlocTester.testGameWidget(
          'does not listen when a ball has not been lost',
          setUp: (game, tester) async {
            final controller = LaunchedBallController(ball);

            await ball.add(controller);
            await game.ensureAdd(ball);
          },
          verify: (game, tester) async {
            final controller =
                game.descendants().whereType<LaunchedBallController>().first;

            final previousState = MockGameState();
            final newState = MockGameState();
            when(() => previousState.balls).thenReturn(3);
            when(() => newState.balls).thenReturn(3);

            expect(controller.listenWhen(previousState, newState), isFalse);
          },
        );
      });

      group('onNewState', () {
        flameBlocTester.testGameWidget(
          'removes ball',
          setUp: (game, tester) async {
            final controller = LaunchedBallController(ball);
            await ball.add(controller);
            await game.ensureAdd(ball);

            final state = MockGameState();
            when(() => state.balls).thenReturn(1);
            controller.onNewState(state);
            await game.ready();
          },
          verify: (game, tester) async {
            expect(game.contains(ball), isFalse);
          },
        );

        flameBlocTester.testGameWidget(
          'spawns a new ball when the ball is not the last one',
          setUp: (game, tester) async {
            final controller = LaunchedBallController(ball);
            await ball.add(controller);
            await game.ensureAdd(ball);

            final state = MockGameState();
            when(() => state.balls).thenReturn(2);

            final previousBalls = game.descendants().whereType<Ball>().toList();
            controller.onNewState(state);
            await game.ready();

            final currentBalls = game.descendants().whereType<Ball>();

            expect(currentBalls.contains(ball), isFalse);
            expect(currentBalls.length, equals(previousBalls.length));
          },
        );

        flameBlocTester.testGameWidget(
          'does not spawn a new ball is the last one',
          setUp: (game, tester) async {
            final controller = LaunchedBallController(ball);
            await ball.add(controller);
            await game.ensureAdd(ball);

            final state = MockGameState();
            when(() => state.balls).thenReturn(1);

            final previousBalls = game.descendants().whereType<Ball>().toList();
            controller.onNewState(state);
            await game.ready();

            final currentBalls = game.descendants().whereType<Ball>();

            expect(currentBalls.contains(ball), isFalse);
            expect(
              currentBalls.length,
              equals((previousBalls..remove(ball)).length),
            );
          },
        );
      });
    });
  });
}
