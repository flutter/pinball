// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.android.ramp.boardOpening.keyName,
      Assets.images.android.ramp.railingForeground.keyName,
      Assets.images.android.ramp.railingBackground.keyName,
      Assets.images.android.ramp.main.keyName,
      Assets.images.android.ramp.arrow.inactive.keyName,
      Assets.images.android.ramp.arrow.active1.keyName,
      Assets.images.android.ramp.arrow.active2.keyName,
      Assets.images.android.ramp.arrow.active3.keyName,
      Assets.images.android.ramp.arrow.active4.keyName,
      Assets.images.android.ramp.arrow.active5.keyName,
      Assets.images.android.rail.main.keyName,
      Assets.images.android.rail.exit.keyName,
      Assets.images.score.fiveThousand.keyName,
    ]);
  }

  Future<void> pump(
    SpaceshipRamp child, {
    required SpaceshipRampCubit spaceshipRampCubit,
    required GameBloc gameBloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [
          FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
            value: spaceshipRampCubit,
            children: [
              ZCanvasComponent(children: [child]),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _FakeGameState extends Fake implements GameState {}

class _FakeGameEvent extends Fake implements GameEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RampMultiplierBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      registerFallbackValue(_FakeGameState());
      registerFallbackValue(_FakeGameEvent());
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.test(
      'adds MultiplierIncreased '
      'when hits are multiples of 5 times and multiplier is less than 6',
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final event = MultiplierIncreased();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        when(() => gameBloc.state).thenReturn(
          GameState.initial().copyWith(
            multiplier: 5,
          ),
        );
        when(() => gameBloc.add(event)).thenAnswer((_) async {});

        final behavior = RampMultiplierBehavior();
        final parent = SpaceshipRamp.test();

        await game.pump(
          parent,
          gameBloc: gameBloc,
          spaceshipRampCubit: bloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(state.copyWith(hits: 5));

        verify(() => gameBloc.add(event)).called(1);
      },
    );

    flameTester.test(
      "doesn't add MultiplierIncreased "
      'when hits are multiples of 5 times but multiplier is 6',
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        when(() => gameBloc.state).thenReturn(
          GameState.initial().copyWith(
            multiplier: 6,
          ),
        );

        final behavior = RampMultiplierBehavior();
        final parent = SpaceshipRamp.test();

        await game.pump(
          parent,
          gameBloc: gameBloc,
          spaceshipRampCubit: bloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(state.copyWith(hits: 5));

        verifyNever(() => gameBloc.add(const MultiplierIncreased()));
      },
    );

    flameTester.test(
      "doesn't add MultiplierIncreased "
      "when hits aren't multiples of 5 times",
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        when(() => gameBloc.state).thenReturn(
          GameState.initial().copyWith(
            multiplier: 5,
          ),
        );

        final behavior = RampMultiplierBehavior();
        final parent = SpaceshipRamp.test();

        await game.pump(
          parent,
          gameBloc: gameBloc,
          spaceshipRampCubit: bloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(state.copyWith(hits: 1));

        verifyNever(() => gameBloc.add(const MultiplierIncreased()));
      },
    );
  });
}
