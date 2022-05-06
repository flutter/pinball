// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(Assets.images.backbox.marquee.keyName);
  }

  Future<void> pump(
    Iterable<Component> children, {
    PinballPlayer? pinballPlayer,
  }) async {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [
          MultiFlameProvider(
            providers: [
              FlameProvider<PinballPlayer>.value(
                pinballPlayer ?? _MockPinballPlayer(),
              ),
              FlameProvider<theme.CharacterTheme>.value(
                const theme.DashTheme(),
              ),
            ],
            children: children,
          ),
        ],
      ),
    );
  }
}

class _MockPinballPlayer extends Mock implements PinballPlayer {}

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameBlocStatusListener', () {
    test('can be instantiated', () {
      expect(
        GameBlocStatusListener(),
        isA<GameBlocStatusListener>(),
      );
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.test(
      'can be loaded',
      (game) async {
        final component = GameBlocStatusListener();
        await game.pump([component]);
        expect(game.descendants(), contains(component));
      },
    );

    group('listenWhen', () {
      test('is true when the game over state has changed', () {
        const state = GameState(
          totalScore: 0,
          roundScore: 10,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [],
          status: GameStatus.playing,
        );

        const previous = GameState.initial();
        expect(
          GameBlocStatusListener().listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      flameTester.test(
        'changes the backbox display when the game is over',
        (game) async {
          final component = GameBlocStatusListener();
          final repository = _MockLeaderboardRepository();
          final backbox = Backbox(leaderboardRepository: repository);
          final state = const GameState.initial()
            ..copyWith(
              status: GameStatus.gameOver,
            );

          await game.pump([component, backbox]);

          expect(() => component.onNewState(state), returnsNormally);
        },
      );

      flameTester.test(
        'plays the background music on start',
        (game) async {
          final player = _MockPinballPlayer();
          final component = GameBlocStatusListener();
          await game.pump([component], pinballPlayer: player);

          component.onNewState(
            const GameState.initial().copyWith(status: GameStatus.playing),
          );

          verify(() => player.play(PinballAudio.backgroundMusic)).called(1);
        },
      );

      flameTester.test(
        'plays the game over voice over when it is game over',
        (game) async {
          final player = _MockPinballPlayer();
          final component = GameBlocStatusListener();
          final repository = _MockLeaderboardRepository();
          final backbox = Backbox(leaderboardRepository: repository);
          await game.pump([component, backbox], pinballPlayer: player);

          component.onNewState(
            const GameState.initial().copyWith(status: GameStatus.gameOver),
          );

          verify(() => player.play(PinballAudio.gameOverVoiceOver)).called(1);
        },
      );
    });
  });
}
