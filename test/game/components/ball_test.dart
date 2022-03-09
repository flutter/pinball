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

  group('Ball', () {
    final flameTester = FlameTester(PinballGameX.initial);

    flameTester.test(
      'loads correctly',
      (game) async {
        final ball = Ball(position: Vector2.zero());
        await game.ensureAdd(ball);

        expect(game.contains(ball), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final ball = Ball(position: position);
          await game.ensureAdd(ball);
          game.contains(ball);

          expect(ball.body.position, position);
        },
      );

      flameTester.test(
        'is dynamic',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          expect(ball.body.bodyType, equals(BodyType.dynamic));
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          expect(ball.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'is dense',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final ball = Ball(position: Vector2.zero());
          await game.ensureAdd(ball);

          final fixture = ball.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(1));
        },
      );
    });

    group('resetting a ball', () {
      final gameBloc = MockGameBloc();

      setUp(() {
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final tester = flameBlocTester(gameBloc: gameBloc);

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

          game.children.whereType<Ball>().first.removeFromParent();
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
              bonusLetters: [],
            ),
          );
          await game.ready();

          game.children.whereType<Ball>().first.removeFromParent();
          await tester.pump();

          expect(
            game.children.whereType<Ball>().length,
            equals(0),
          );
        },
      );
    });
  });
}
