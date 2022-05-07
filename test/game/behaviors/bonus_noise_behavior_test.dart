// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    BonusNoiseBehavior child, {
    required PinballAudioPlayer player,
    required GameBloc bloc,
  }) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: bloc,
        children: [
          FlameProvider<PinballAudioPlayer>.value(
            player,
            children: [
              child,
            ],
          ),
        ],
      ),
    );
  }
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BonusNoiseBehavior', () {
    late PinballAudioPlayer player;
    late GameBloc bloc;
    final flameTester = FlameTester(_TestGame.new);

    setUpAll(() {
      registerFallbackValue(PinballAudio.google);
    });

    setUp(() {
      player = _MockPinballAudioPlayer();
      when(() => player.play(any())).thenAnswer((_) {});
      bloc = _MockGameBloc();
    });

    flameTester.testGameWidget(
      'plays google sound',
      setUp: (game, _) async {
        const state = GameState(
          totalScore: 0,
          roundScore: 0,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [GameBonus.googleWord],
          status: GameStatus.playing,
        );
        const initialState = GameState.initial();
        whenListen(
          bloc,
          Stream.fromIterable([initialState, state]),
          initialState: initialState,
        );
        final behavior = BonusNoiseBehavior();
        await game.pump(behavior, player: player, bloc: bloc);
      },
      verify: (_, __) async {
        verify(() => player.play(PinballAudio.google)).called(1);
      },
    );

    flameTester.testGameWidget(
      'plays sparky sound',
      setUp: (game, _) async {
        const state = GameState(
          totalScore: 0,
          roundScore: 0,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [GameBonus.sparkyTurboCharge],
          status: GameStatus.playing,
        );
        const initialState = GameState.initial();
        whenListen(
          bloc,
          Stream.fromIterable([initialState, state]),
          initialState: initialState,
        );
        final behavior = BonusNoiseBehavior();
        await game.pump(behavior, player: player, bloc: bloc);
      },
      verify: (_, __) async {
        verify(() => player.play(PinballAudio.sparky)).called(1);
      },
    );

    flameTester.testGameWidget(
      'plays dino chomp sound',
      setUp: (game, _) async {
        const state = GameState(
          totalScore: 0,
          roundScore: 0,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [GameBonus.dinoChomp],
          status: GameStatus.playing,
        );
        const initialState = GameState.initial();
        whenListen(
          bloc,
          Stream.fromIterable([initialState, state]),
          initialState: initialState,
        );
        final behavior = BonusNoiseBehavior();
        await game.pump(behavior, player: player, bloc: bloc);
      },
      verify: (_, __) async {
        verify(() => player.play(PinballAudio.dino)).called(1);
      },
    );

    flameTester.testGameWidget(
      'plays android spaceship sound',
      setUp: (game, _) async {
        const state = GameState(
          totalScore: 0,
          roundScore: 0,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [GameBonus.androidSpaceship],
          status: GameStatus.playing,
        );
        const initialState = GameState.initial();
        whenListen(
          bloc,
          Stream.fromIterable([initialState, state]),
          initialState: initialState,
        );
        final behavior = BonusNoiseBehavior();
        await game.pump(behavior, player: player, bloc: bloc);
      },
      verify: (_, __) async {
        verify(() => player.play(PinballAudio.android)).called(1);
      },
    );

    flameTester.testGameWidget(
      'plays dash nest sound',
      setUp: (game, _) async {
        const state = GameState(
          totalScore: 0,
          roundScore: 0,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [GameBonus.dashNest],
          status: GameStatus.playing,
        );
        const initialState = GameState.initial();
        whenListen(
          bloc,
          Stream.fromIterable([initialState, state]),
          initialState: initialState,
        );
        final behavior = BonusNoiseBehavior();
        await game.pump(behavior, player: player, bloc: bloc);
      },
      verify: (_, __) async {
        verify(() => player.play(PinballAudio.dash)).called(1);
      },
    );
  });
}
