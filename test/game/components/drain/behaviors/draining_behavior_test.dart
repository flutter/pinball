// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/drain/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(theme.Assets.images.dash.ball.keyName);
  }

  Future<void> pump(
    Drain child, {
    required GameBloc gameBloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'DrainingBehavior',
    () {
      final flameTester = FlameTester(Forge2DGame.new);

      test('can be instantiated', () {
        expect(DrainingBehavior(), isA<DrainingBehavior>());
      });

      flameTester.testGameWidget(
        'loads',
        setUp: (game, _) async {
          await game.onLoad();
          final parent = Drain.test();
          final behavior = DrainingBehavior();
          await parent.add(behavior);
          await game.ensureAdd(parent);
          await game.ready();
        },
        verify: (game, _) async {
          final parent = game.descendants().whereType<Drain>().single;
          expect(
            parent.descendants().whereType<DrainingBehavior>(),
            isNotEmpty,
          );
        },
      );

      group('beginContact', () {
        late GameBloc gameBloc;

        setUp(() {
          gameBloc = _MockGameBloc();
        });

        final flameBlocTester = FlameTester(_TestGame.new);

        flameBlocTester.testGameWidget(
          'adds RoundLost when no balls left',
          setUp: (game, _) async {
            await game.onLoad();
            final drain = Drain.test();
            final behavior = DrainingBehavior();
            final ball = Ball.test();
            await drain.add(behavior);
            await game.pump(
              drain,
              gameBloc: gameBloc,
            );
            await game.ensureAdd(ball);

            behavior.beginContact(ball, _MockContact());
            await game.ready();
          },
          verify: (game, _) async {
            expect(game.descendants().whereType<Ball>(), isEmpty);
            verify(() => gameBloc.add(const RoundLost())).called(1);
          },
        );

        flameBlocTester.testGameWidget(
          "doesn't add RoundLost when there are balls left",
          setUp: (game, _) async {
            await game.onLoad();
            final drain = Drain.test();
            final behavior = DrainingBehavior();
            final ball1 = Ball.test();
            final ball2 = Ball.test();
            await drain.add(behavior);
            await game.pump(
              drain,
              gameBloc: gameBloc,
            );
            await game.ensureAddAll([ball1, ball2]);

            behavior.beginContact(ball1, _MockContact());
            await game.ready();
          },
          verify: (game, _) async {
            expect(game.descendants().whereType<Ball>(), isNotEmpty);
            verifyNever(() => gameBloc.add(const RoundLost()));
          },
        );

        flameBlocTester.testGameWidget(
          'removes the Ball',
          setUp: (game, _) async {
            await game.onLoad();
            final drain = Drain.test();
            final behavior = DrainingBehavior();
            final ball = Ball.test();
            await drain.add(behavior);
            await game.pump(
              drain,
              gameBloc: gameBloc,
            );
            await game.ensureAdd(ball);

            behavior.beginContact(ball, _MockContact());
            await game.ready();
          },
          verify: (game, _) async {
            expect(game.descendants().whereType<Ball>(), isEmpty);
          },
        );
      });
    },
  );
}
