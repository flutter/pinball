import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/ball_spawning_behavior.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(theme.Assets.images.dash.ball.keyName);
  }

  Future<void> pump(
    List<Component> children, {
    GameBloc? gameBloc,
  }) async {
    await ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: gameBloc ?? GameBloc(),
          ),
          FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
            value: CharacterThemeCubit(),
          ),
        ],
        children: children,
      ),
    );
  }
}

class _MockGameState extends Mock implements GameState {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'BallSpawningBehavior',
    () {
      final flameTester = FlameTester(_TestGame.new);

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
          await game.pump([behavior]);
          expect(game.descendants(), contains(behavior));
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
          final behavior = BallSpawningBehavior();
          await game.pump([
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
