// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('Ball', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final ball = Ball();
        await game.ready();
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is dynamic',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'is dense',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final ball = Ball();
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(1));
        },
      );
    });

    group('lost', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final tester = flameBlocTester(gameBloc: () => gameBloc);

      tester.widgetTest(
        'adds BallLost to GameBloc',
        (game, tester) async {
          await game.ready();

          game.children.whereType<Ball>().first.lost();
          await tester.pump();

          verify(() => gameBloc.add(const BallLost())).called(1);
        },
      );

      tester.widgetTest(
        'resets the ball if the game is not over',
        (game, tester) async {
          await game.ready();

          game.children.whereType<Ball>().first.lost();
          await game.ready(); // Making sure that all additions are done

          expect(
            game.children.whereType<Ball>().length,
            equals(1),
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
              bonusHistory: [],
            ),
          );
          await game.ready();

          game.children.whereType<Ball>().first.lost();
          await tester.pump();

          expect(
            game.children.whereType<Ball>().length,
            equals(0),
          );
        },
      );
    });

    group('stop', () {
      flameTester.test('can be moved', (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);

        game.update(1);
        expect(ball.body.position, isNot(equals(ball.initialPosition)));

        ball.body.linearVelocity.setValues(10, 10);
        game.update(1);
        expect(ball.body.position, isNot(equals(ball.initialPosition)));
      });

      flameTester.test("can't be moved", (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);
        ball.stop();

        game.update(1);
        expect(ball.body.position, equals(ball.initialPosition));

        ball.body.linearVelocity.setValues(10, 10);
        game.update(1);
        expect(ball.body.position, equals(ball.initialPosition));
      });
    });

    group('resume', () {
      flameTester.test('can move when previosusly stopped', (game) async {
        final ball = Ball();
        await game.ensureAdd(ball);
        ball.stop();
        ball.resume();

        game.update(1);
        expect(ball.body.position, isNot(equals(ball.initialPosition)));

        ball.body.linearVelocity.setValues(10, 10);
        game.update(1);
        expect(ball.body.position, isNot(equals(ball.initialPosition)));
      });
    });
  });
}
