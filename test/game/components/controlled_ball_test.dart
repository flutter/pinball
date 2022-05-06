// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(theme.Assets.images.dash.ball.keyName);
  }

  Future<void> pump(Ball child, {required GameBloc gameBloc}) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockBall extends Mock implements Ball {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BallController', () {
    late Ball ball;
    late GameBloc gameBloc;

    setUp(() {
      ball = Ball();
      gameBloc = _MockGameBloc();
    });

    final flameBlocTester = FlameTester(_TestGame.new);

    test('can be instantiated', () {
      expect(
        BallController(_MockBall()),
        isA<BallController>(),
      );
    });

    flameBlocTester.testGameWidget(
      'turboCharge adds TurboChargeActivated',
      setUp: (game, tester) async {
        await game.onLoad();

        final controller = BallController(ball);
        await ball.add(controller);
        await game.pump(ball, gameBloc: gameBloc);

        await controller.turboCharge();
      },
      verify: (game, tester) async {
        verify(() => gameBloc.add(const SparkyTurboChargeActivated()))
            .called(1);
      },
    );
  });
}
