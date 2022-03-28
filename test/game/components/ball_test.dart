// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Ball', () {
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

          game.children.whereType<Ball>().first.controller.lost();
          await tester.pump();

          verify(() => gameBloc.add(const BallLost())).called(1);
        },
      );

      tester.widgetTest(
        'resets the ball if the game is not over',
        (game, tester) async {
          await game.ready();

          game.children.whereType<Ball>().first.controller.lost();
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
              activatedDashNests: {},
              bonusHistory: [],
            ),
          );
          await game.ready();

          game.children.whereType<Ball>().first.controller.lost();
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
