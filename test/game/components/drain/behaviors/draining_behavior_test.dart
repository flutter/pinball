// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/drain/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

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

      flameTester.test(
        'loads',
        (game) async {
          final parent = Drain.test();
          final behavior = DrainingBehavior();
          await parent.add(behavior);
          await game.ensureAdd(parent);
          expect(parent.contains(behavior), isTrue);
        },
      );

      group('beginContact', () {
        final asset = theme.Assets.images.dash.ball.keyName;
        late GameBloc gameBloc;

        setUp(() {
          gameBloc = _MockGameBloc();
          whenListen(
            gameBloc,
            const Stream<GameState>.empty(),
          );
        });

        final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
          gameBuilder: EmptyPinballTestGame.new,
          blocBuilder: () => gameBloc,
        );

        flameBlocTester.testGameWidget(
          'adds RoundLost when no balls left',
          setUp: (game, tester) async {
            await game.images.load(asset);

            final drain = Drain.test();
            final behavior = DrainingBehavior();
            final ball = Ball.test();
            await drain.add(behavior);
            await game.ensureAddAll([drain, ball]);

            behavior.beginContact(ball, _MockContact());
            await game.ready();

            expect(game.descendants().whereType<Ball>(), isEmpty);
            verify(() => gameBloc.add(const RoundLost())).called(1);
          },
        );

        flameBlocTester.testGameWidget(
          "doesn't add RoundLost when there are balls left",
          setUp: (game, tester) async {
            await game.images.load(asset);

            final drain = Drain.test();
            final behavior = DrainingBehavior();
            final ball1 = Ball.test();
            final ball2 = Ball.test();
            await drain.add(behavior);
            await game.ensureAddAll([
              drain,
              ball1,
              ball2,
            ]);

            behavior.beginContact(ball1, _MockContact());
            await game.ready();

            expect(game.descendants().whereType<Ball>(), isNotEmpty);
            verifyNever(() => gameBloc.add(const RoundLost()));
          },
        );

        flameBlocTester.testGameWidget(
          'removes the Ball',
          setUp: (game, tester) async {
            await game.images.load(asset);
            final drain = Drain.test();
            final behavior = DrainingBehavior();
            final ball = Ball.test();
            await drain.add(behavior);
            await game.ensureAddAll([drain, ball]);

            behavior.beginContact(ball, _MockContact());
            await game.ready();

            expect(game.descendants().whereType<Ball>(), isEmpty);
          },
        );
      });
    },
  );
}
