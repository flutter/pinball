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
  final flameTester = FlameTester(EmptyPinballGameTest.new);

  group('BonusBallController', () {
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

    final flameBlocTester = FlameBlocTester(
      gameBuilder: EmptyPinballGameTest.new,
      blocBuilder: () => gameBloc,
    );

    test('can be instantiated', () {
      expect(
        BonusBallController(ball),
        isA<BonusBallController>(),
      );
    });

    flameBlocTester.testGameWidget(
      'lost removes ball',
      setUp: (game, tester) async {
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
        gameBuilder: EmptyPinballGameTest.new,
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
    });
  });
}
