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
class _WrappedBallController extends BallController {
  _WrappedBallController(Ball<Forge2DGame> ball, this._gameRef) : super(ball);

  final PinballGame _gameRef;

  @override
  PinballGame get gameRef => _gameRef;
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockPinballGame extends Mock implements PinballGame {}

class _MockControlledBall extends Mock implements ControlledBall {}

class _MockBall extends Mock implements Ball {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BallController', () {
    late Ball ball;
    late GameBloc gameBloc;

    setUp(() {
      ball = Ball(baseColor: const Color(0xFF00FFFF));
      gameBloc = _MockGameBloc();
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
        BallController(_MockBall()),
        isA<BallController>(),
      );
    });

    flameBlocTester.testGameWidget(
      "lost doesn't adds RoundLost to GameBloc "
      'when there are balls left',
      setUp: (game, tester) async {
        final controller = BallController(ball);
        await ball.add(controller);
        await game.ensureAdd(ball);

        final otherBall = Ball(baseColor: const Color(0xFF00FFFF));
        final otherController = BallController(otherBall);
        await otherBall.add(otherController);
        await game.ensureAdd(otherBall);

        controller.lost();
        await game.ready();
      },
      verify: (game, tester) async {
        verifyNever(() => gameBloc.add(const RoundLost()));
      },
    );

    flameBlocTester.testGameWidget(
      'lost adds RoundLost to GameBloc '
      'when there are no balls left',
      setUp: (game, tester) async {
        final controller = BallController(ball);
        await ball.add(controller);
        await game.ensureAdd(ball);

        controller.lost();
        await game.ready();
      },
      verify: (game, tester) async {
        verify(() => gameBloc.add(const RoundLost())).called(1);
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
          final gameRef = _MockPinballGame();
          final ball = _MockControlledBall();
          final controller = _WrappedBallController(ball, gameRef);
          when(() => gameRef.read<GameBloc>()).thenReturn(gameBloc);
          when(() => ball.controller).thenReturn(controller);
          when(() => ball.boost(any())).thenAnswer((_) async {});

          await controller.turboCharge();

          verify(ball.stop).called(1);
        },
      );

      flameBlocTester.test(
        'resumes the ball',
        (game) async {
          final gameRef = _MockPinballGame();
          final ball = _MockControlledBall();
          final controller = _WrappedBallController(ball, gameRef);
          when(() => gameRef.read<GameBloc>()).thenReturn(gameBloc);
          when(() => ball.controller).thenReturn(controller);
          when(() => ball.boost(any())).thenAnswer((_) async {});

          await controller.turboCharge();

          verify(ball.resume).called(1);
        },
      );

      flameBlocTester.test(
        'boosts the ball',
        (game) async {
          final gameRef = _MockPinballGame();
          final ball = _MockControlledBall();
          final controller = _WrappedBallController(ball, gameRef);
          when(() => gameRef.read<GameBloc>()).thenReturn(gameBloc);
          when(() => ball.controller).thenReturn(controller);
          when(() => ball.boost(any())).thenAnswer((_) async {});

          await controller.turboCharge();

          verify(() => ball.boost(any())).called(1);
        },
      );
    });
  });
}
