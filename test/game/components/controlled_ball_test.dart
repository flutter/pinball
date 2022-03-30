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

  group('PlungerBallController', () {
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

      tester.widgetTest(
        'removes ball',
        (game, tester) async {
          await game.add(ball);
          final controller = PlungerBallController(ball);
          await ball.add(controller);
          await game.ready();

          controller.lost();
          await game.ready();

          expect(game.contains(ball), isFalse);
        },
      );

      tester.widgetTest(
        'adds BallLost to GameBloc',
        (game, tester) async {
          final controller = PlungerBallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          controller.lost();

          verify(() => gameBloc.add(const BallLost())).called(1);
        },
      );

      tester.widgetTest(
        'adds a new ball if the game is not over',
        (game, tester) async {
          final controller = PlungerBallController(ball);
          await ball.add(controller);
          await game.add(ball);
          await game.ready();

          final previousBalls = game.descendants().whereType<Ball>();
          controller.lost();
          await game.ready();
          final currentBalls = game.descendants().whereType<Ball>();

          expect(
            previousBalls.length,
            equals(currentBalls.length),
          );
        },
      );

      tester.widgetTest(
        'no ball is added on game over',
        (game, tester) async {
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

          final previousBalls = game.descendants().whereType<Ball>();
          controller.lost();
          await game.ready();
          final currentBalls = game.descendants().whereType<Ball>();

          expect(
            currentBalls.length,
            equals(
              (previousBalls.toList()..remove(ball)).length,
            ),
          );
        },
      );
    });
  });
}
