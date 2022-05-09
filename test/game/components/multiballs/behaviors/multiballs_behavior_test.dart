// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/multiballs/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.multiball.lit.keyName,
      Assets.images.multiball.dimmed.keyName,
    ]);
  }

  Future<void> pump(Multiballs child, {GameBloc? gameBloc}) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc ?? GameBloc(),
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockMultiballCubit extends Mock implements MultiballCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MultiballsBehavior', () {
    final flameTester = FlameTester(_TestGame.new);

    test('can be instantiated', () {
      expect(
        MultiballsBehavior(),
        isA<MultiballsBehavior>(),
      );
    });

    flameTester.test(
      'can be loaded',
      (game) async {
        final parent = Multiballs.test();
        final behavior = MultiballsBehavior();
        await game.pump(parent);
        await parent.ensureAdd(behavior);
        expect(parent.children, contains(behavior));
      },
    );

    group('listenWhen', () {
      test(
        'is true when the bonusHistory has changed '
        'with a new GameBonus.dashNest',
        () {
          final previous = GameState.initial();
          final state = previous.copyWith(
            bonusHistory: [GameBonus.dashNest],
          );

          expect(
            MultiballsBehavior().listenWhen(previous, state),
            isTrue,
          );
        },
      );

      test(
        'is true when the bonusHistory has changed '
        'with a new GameBonus.googleWord',
        () {
          final previous = GameState.initial();
          final state = previous.copyWith(
            bonusHistory: [GameBonus.googleWord],
          );

          expect(
            MultiballsBehavior().listenWhen(previous, state),
            isTrue,
          );
        },
      );

      test(
          'is false when the bonusHistory has changed with a bonus other than '
          'GameBonus.dashNest or GameBonus.googleWord', () {
        final previous =
            GameState.initial().copyWith(bonusHistory: [GameBonus.dashNest]);
        final state = previous.copyWith(
          bonusHistory: [...previous.bonusHistory, GameBonus.androidSpaceship],
        );

        expect(
          MultiballsBehavior().listenWhen(previous, state),
          isFalse,
        );
      });

      test('is false when the bonusHistory state is the same', () {
        final previous = GameState.initial();
        final state = GameState(
          totalScore: 0,
          roundScore: 10,
          multiplier: 1,
          rounds: 0,
          bonusHistory: const [],
          status: GameStatus.playing,
        );

        expect(
          MultiballsBehavior().listenWhen(previous, state),
          isFalse,
        );
      });
    });

    group('onNewState', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = _MockGameBloc();
        whenListen(
          gameBloc,
          Stream<GameState>.empty(),
          initialState: GameState.initial(),
        );
      });

      flameTester.testGameWidget(
        "calls 'onAnimate' once for every multiball",
        setUp: (game, tester) async {
          final behavior = MultiballsBehavior();
          final parent = Multiballs.test();
          final multiballCubit = _MockMultiballCubit();
          final otherMultiballCubit = _MockMultiballCubit();
          final multiballs = [
            Multiball.test(
              bloc: multiballCubit,
            ),
            Multiball.test(
              bloc: otherMultiballCubit,
            ),
          ];

          whenListen(
            multiballCubit,
            const Stream<MultiballState>.empty(),
            initialState: MultiballState.initial(),
          );
          when(multiballCubit.onAnimate).thenAnswer((_) async {});

          whenListen(
            otherMultiballCubit,
            const Stream<MultiballState>.empty(),
            initialState: MultiballState.initial(),
          );
          when(otherMultiballCubit.onAnimate).thenAnswer((_) async {});

          await parent.addAll(multiballs);
          await game.pump(parent, gameBloc: gameBloc);
          await parent.ensureAdd(behavior);

          await tester.pump();

          behavior.onNewState(
            GameState.initial().copyWith(bonusHistory: [GameBonus.dashNest]),
          );

          for (final multiball in multiballs) {
            verify(
              multiball.bloc.onAnimate,
            ).called(1);
          }
        },
      );
    });
  });
}
