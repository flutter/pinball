// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

// TODO(allisonryan0002): remove once
// https://github.com/flame-engine/flame/pull/1520 is merged
class WrappedBallController extends BallController {
  WrappedBallController(Ball<Forge2DGame> ball, this._gameRef) : super(ball);

  final PinballGame _gameRef;

  @override
  PinballGame get gameRef => _gameRef;
}

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
      gameBuilder: EmptyPinballTestGame.new,
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
      setUpAll(() {
        registerFallbackValue(Vector2.zero());
      });

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

      flameBlocTester.test(
        'initially stops the ball',
        (game) async {
          final gameRef = MockPinballGame();
          final ball = MockControlledBall();
          final controller = WrappedBallController(ball, gameRef);
          when(() => gameRef.read<GameBloc>()).thenReturn(gameBloc);
          when(() => ball.controller).thenReturn(controller);

          await controller.turboCharge();

          verify(ball.stop).called(1);
        },
      );

      flameBlocTester.test(
        'resumes the ball',
        (game) async {
          final gameRef = MockPinballGame();
          final ball = MockControlledBall();
          final controller = WrappedBallController(ball, gameRef);
          when(() => gameRef.read<GameBloc>()).thenReturn(gameBloc);
          when(() => ball.controller).thenReturn(controller);

          await controller.turboCharge();

          verify(ball.resume).called(1);
        },
      );

      flameBlocTester.test(
        'boosts the ball',
        (game) async {
          final gameRef = MockPinballGame();
          final ball = MockControlledBall();
          final controller = WrappedBallController(ball, gameRef);
          when(() => gameRef.read<GameBloc>()).thenReturn(gameBloc);
          when(() => ball.controller).thenReturn(controller);

          await controller.turboCharge();

          verify(() => ball.boost(any())).called(1);
        },
      );
    });
  });
}
