// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/multipliers/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.multiplier.x2.lit.keyName,
      Assets.images.multiplier.x2.dimmed.keyName,
      Assets.images.multiplier.x3.lit.keyName,
      Assets.images.multiplier.x3.dimmed.keyName,
      Assets.images.multiplier.x4.lit.keyName,
      Assets.images.multiplier.x4.dimmed.keyName,
      Assets.images.multiplier.x5.lit.keyName,
      Assets.images.multiplier.x5.dimmed.keyName,
      Assets.images.multiplier.x6.lit.keyName,
      Assets.images.multiplier.x6.dimmed.keyName,
    ]);
  }

  Future<void> pump(Multipliers child) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockComponent extends Mock implements Component {}

class _MockMultiplierCubit extends Mock implements MultiplierCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MultipliersBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      registerFallbackValue(_MockComponent());
      gameBloc = _MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameTester(_TestGame.new);

    group('listenWhen', () {
      test('is true when the multiplier has changed', () {
        final state = GameState(
          totalScore: 0,
          roundScore: 10,
          multiplier: 2,
          rounds: 0,
          status: GameStatus.playing,
          bonusHistory: const [],
        );
        final previous = GameState.initial();

        expect(
          MultipliersBehavior().listenWhen(previous, state),
          isTrue,
        );
      });

      test('is false when the multiplier state is the same', () {
        final state = GameState(
          totalScore: 0,
          roundScore: 10,
          multiplier: 1,
          rounds: 0,
          status: GameStatus.playing,
          bonusHistory: const [],
        );
        final previous = GameState.initial();

        expect(
          MultipliersBehavior().listenWhen(previous, state),
          isFalse,
        );
      });
    });

    group('onNewState', () {
      flameBlocTester.testGameWidget(
        "calls 'next' once per each multiplier when GameBloc emit state",
        setUp: (game, tester) async {
          await game.onLoad();
          final behavior = MultipliersBehavior();
          final parent = Multipliers.test();
          final multiplierX2Cubit = _MockMultiplierCubit();
          final multiplierX3Cubit = _MockMultiplierCubit();
          final multipliers = [
            Multiplier.test(
              value: MultiplierValue.x2,
              bloc: multiplierX2Cubit,
            ),
            Multiplier.test(
              value: MultiplierValue.x3,
              bloc: multiplierX3Cubit,
            ),
          ];

          whenListen(
            multiplierX2Cubit,
            const Stream<MultiplierState>.empty(),
            initialState: MultiplierState.initial(MultiplierValue.x2),
          );
          when(() => multiplierX2Cubit.next(any())).thenAnswer((_) async {});

          whenListen(
            multiplierX3Cubit,
            const Stream<MultiplierState>.empty(),
            initialState: MultiplierState.initial(MultiplierValue.x2),
          );
          when(() => multiplierX3Cubit.next(any())).thenAnswer((_) async {});

          await parent.addAll(multipliers);
          await game.pump(parent);
          await parent.ensureAdd(behavior);

          await tester.pump();

          behavior.onNewState(
            GameState.initial().copyWith(multiplier: 2),
          );

          for (final multiplier in multipliers) {
            verify(
              () => multiplier.bloc.next(any()),
            ).called(1);
          }
        },
      );
    });
  });
}
