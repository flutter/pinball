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

    flameTester.test(
      'lost removes ball',
      (game) async {
        await game.add(ball);
        final controller = BonusBallController(ball);
        await ball.add(controller);
        await game.ready();

        controller.lost();
        await game.ready();

        expect(game.contains(ball), isFalse);
      },
    );
  });

  group('LaunchedBallController', () {
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

    final tester = flameBlocTester<PinballGame>(
      game: PinballGameTest.create,
      gameBloc: () => gameBloc,
    );

    flameTester.testGameWidget(
      'lost adds BallLost to GameBloc',
      setUp: (game, tester) async {
        final controller = LaunchedBallController(ball);
        await ball.add(controller);
        await game.add(ball);
        await game.ready();

        controller.lost();
      },
      verify: (game, tester) async {
        verify(() => gameBloc.add(const BallLost())).called(1);
      },
    );

    group('listenWhen', () {
      flameTester.testGameWidget(
        'listens when a ball has been lost',
        verify: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          final previousState = MockGameState();
          final newState = MockGameState();
          when(() => previousState.balls).thenReturn(3);
          when(() => newState.balls).thenReturn(2);

          expect(controller.listenWhen(previousState, newState), isTrue);
        },
      );

      flameTester.testGameWidget(
        'does not listen when a ball has not been lost',
        verify: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          final previousState = MockGameState();
          final newState = MockGameState();
          when(() => previousState.balls).thenReturn(3);
          when(() => newState.balls).thenReturn(3);

          expect(controller.listenWhen(previousState, newState), isTrue);
        },
      );
    });

    group('onNewState', () {
      setUp(() {
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      tester.testGameWidget(
        'removes ball',
        setUp: (game, _) => game.ready(),
        verify: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await game.add(ball);
          await game.ready();

          final state = MockGameState();
          when(() => state.balls).thenReturn(any());
          controller.onNewState(MockGameState());

          expect(game.contains(ball), isFalse);
        },
      );

      tester.testGameWidget(
        'spawns a new ball when the ball is not the last one',
        setUp: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await game.add(ball);
          await game.ready();

          final state = MockGameState();
          when(() => state.balls).thenReturn(2);

          controller.onNewState(state);
        },
        verify: (game, tester) async {
          expect(game.contains(ball), isFalse);
        },
      );

      tester.testGameWidget(
        'does not spawn a new ball is the last one',
        setUp: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await game.add(ball);
          await game.ready();

          final state = MockGameState();
          when(() => state.balls).thenReturn(1);

          controller.onNewState(state);
        },
        verify: (game, tester) async {
          expect(game.contains(ball), isFalse);
        },
      );
    });
  });
}
