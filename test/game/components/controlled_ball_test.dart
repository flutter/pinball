// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BallController', () {
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
      gameBuilder: EmptyPinballGameTest.new,
      blocBuilder: () => gameBloc,
    );

    test('can be instantiated', () {
      expect(
        BallController(MockBall()),
        isA<BallController>(),
      );
    });

    flameBlocTester.testGameWidget(
      'lost adds BallLost to GameBloc',
      setUp: (game, tester) async {
        final controller = BallController(ball);
        await ball.add(controller);
        await game.ensureAdd(ball);

        controller.lost();
      },
      verify: (game, tester) async {
        verify(() => gameBloc.add(const BallLost())).called(1);
      },
    );

    group('turboCharge', () {
      flameBlocTester.testGameWidget(
        'adds TurboChargeActivated',
        setUp: (game, tester) async {
          final controller = BallController(ball);
          await ball.add(controller);
          await game.ensureAdd(ball);

          await controller.turboCharge();
        },
        verify: (game, tester) async {
          verify(() => gameBloc.add(const SparkyTurboChargeActivated()))
              .called(1);
        },
      );

      flameBlocTester.testGameWidget(
        "initially stops the ball's motion",
        setUp: (game, tester) async {
          final controller = BallController(ball);
          await ball.add(controller);
          await game.ensureAdd(ball);

          ball.body.linearVelocity = Vector2.all(10);

          // ignore: unawaited_futures
          controller.turboCharge();

          expect(ball.body.gravityScale, equals(0));
          expect(ball.body.linearVelocity, equals(Vector2.zero()));
          expect(ball.body.angularVelocity, equals(0));
        },
      );

      flameBlocTester.testGameWidget(
        'resumes the ball',
        setUp: (game, tester) async {
          final controller = BallController(ball);
          await ball.add(controller);
          await game.ensureAdd(ball);

          await controller.turboCharge();

          expect(ball.body.gravityScale, equals(1));
          expect(ball.body.linearVelocity, isNot(equals(Vector2.zero())));
        },
      );

      flameBlocTester.testGameWidget(
        'boosts the ball',
        setUp: (game, tester) async {
          final controller = BallController(ball);
          await ball.add(controller);
          await game.ensureAdd(ball);

          await controller.turboCharge();

          expect(ball.body.linearVelocity, equals(Vector2(200, -500)));
        },
      );
    });
  });
}
