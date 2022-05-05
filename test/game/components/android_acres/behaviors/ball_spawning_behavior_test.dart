import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/ball_spawning_behavior.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/test_games.dart';

class _MockGameState extends Mock implements GameState {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'BallSpawningBehavior',
    () {
      final flameTester = FlameTester(EmptyPinballTestGame.new);

      test('can be instantiated', () {
        expect(
          BallSpawningBehavior(),
          isA<BallSpawningBehavior>(),
        );
      });

      flameTester.test(
        'loads',
        (game) async {
          final behavior = BallSpawningBehavior();
          await game.ensureAdd(behavior);
          expect(game.contains(behavior), isTrue);
        },
      );

      group('listenWhen', () {
        test(
          'never listens when new state not playing',
          () {
            final waiting = const GameState.initial()
              ..copyWith(status: GameStatus.waiting);
            final gameOver = const GameState.initial()
              ..copyWith(status: GameStatus.gameOver);

            final behavior = BallSpawningBehavior();
            expect(behavior.listenWhen(_MockGameState(), waiting), isFalse);
            expect(behavior.listenWhen(_MockGameState(), gameOver), isFalse);
          },
        );

        test(
          'listens when started playing',
          () {
            final waiting =
                const GameState.initial().copyWith(status: GameStatus.waiting);
            final playing =
                const GameState.initial().copyWith(status: GameStatus.playing);

            final behavior = BallSpawningBehavior();
            expect(behavior.listenWhen(waiting, playing), isTrue);
          },
        );

        test(
          'listens when lost rounds',
          () {
            final playing1 = const GameState.initial().copyWith(
              status: GameStatus.playing,
              rounds: 2,
            );
            final playing2 = const GameState.initial().copyWith(
              status: GameStatus.playing,
              rounds: 1,
            );

            final behavior = BallSpawningBehavior();
            expect(behavior.listenWhen(playing1, playing2), isTrue);
          },
        );

        test(
          "doesn't listen when didn't lose any rounds",
          () {
            final playing = const GameState.initial().copyWith(
              status: GameStatus.playing,
              rounds: 2,
            );

            final behavior = BallSpawningBehavior();
            expect(behavior.listenWhen(playing, playing), isFalse);
          },
        );
      });

      flameTester.test(
        'onNewState adds a ball',
        (game) async {
          await game.images.load(theme.Assets.images.dash.ball.keyName);
          final behavior = BallSpawningBehavior();
          await game.ensureAddAll([
            behavior,
            ZCanvasComponent(),
            Plunger.test(compressionDistance: 10),
          ]);
          expect(game.descendants().whereType<Ball>(), isEmpty);

          behavior.onNewState(_MockGameState());
          await game.ready();

          expect(game.descendants().whereType<Ball>(), isNotEmpty);
        },
      );
    },
  );
}
