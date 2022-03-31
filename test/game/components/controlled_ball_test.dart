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

  group('BallController', () {
    late Ball ball;

    setUp(() {
      ball = Ball(baseColor: const Color(0xFF00FFFF));
    });

    flameTester.test(
      'lost removes ball',
      (game) async {
        await game.add(ball);
        final controller = BallController(ball);
        await ball.add(controller);
        await game.ready();

        controller.lost();
        await game.ready();

        expect(game.contains(ball), isFalse);
      },
    );
  });

  group('LaunchedBallController', () {
    group('lost', () {
      late GameBloc gameBloc;
      late Ball ball;

      setUp(() {
        gameBloc = MockGameBloc();
        ball = Ball(baseColor: const Color(0xFF00FFFF));
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

      tester.testGameWidget(
        'removes ball',
        verify: (game, tester) async {
          await game.add(ball);
          final controller = LaunchedBallController(ball);
          await ball.add(controller);
          await game.ready();

          controller.lost();
          await game.ready();

          expect(game.contains(ball), isFalse);
        },
      );

      tester.testGameWidget(
        'adds BallLost to GameBloc',
        verify: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          controller.lost();

          verify(() => gameBloc.add(const BallLost())).called(1);
        },
      );

      tester.testGameWidget(
        'adds a new ball if the game is not over',
        verify: (game, tester) async {
          final controller = LaunchedBallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          final previousBalls = game.descendants().whereType<Ball>().length;
          controller.lost();
          await game.ready();
          final currentBalls = game.descendants().whereType<Ball>().length;

          expect(previousBalls, equals(currentBalls));
        },
      );

      tester.testGameWidget(
        'no ball is added on game over',
        verify: (game, tester) async {
          whenListen(
            gameBloc,
            const Stream<GameState>.empty(),
            initialState: const GameState(
              score: 10,
              balls: 1,
              activatedBonusLetters: [],
              activatedDashNests: {},
              bonusHistory: [],
            ),
          );
          final controller = BallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          final previousBalls = game.descendants().whereType<Ball>().toList();
          controller.lost();
          await game.ready();
          final currentBalls = game.descendants().whereType<Ball>().length;

          expect(
            currentBalls,
            equals((previousBalls..remove(ball)).length),
          );
        },
      );
    });
  });
}
