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
    required GameBloc gameBloc,
    required SpaceshipRampCubit bloc,
  }) async {
    await ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: gameBloc,
          ),
          FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
            value: bloc,
          ),
        ],
        children: [
          ZCanvasComponent(children: [child]),
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RampResetBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.test(
      'calls onReset when round lost',
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = GameState.initial();
        final streamController = StreamController<GameState>();
        whenListen(
          gameBloc,
          streamController.stream,
          initialState: state,
        );
        final behavior = RampResetBehavior();
        final parent = SpaceshipRamp.test(
          children: [behavior],
        );

        await game.pump(
          parent,
          gameBloc: gameBloc,
          bloc: bloc,
        );

        streamController.add(state.copyWith(rounds: state.rounds - 1));
        await Future<void>.delayed(Duration.zero);

        verify(bloc.onReset).called(1);
      },
    );

    flameTester.test(
      "doesn't call onReset when round stays the same",
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = GameState.initial();
        final streamController = StreamController<GameState>();
        whenListen(
          gameBloc,
          streamController.stream,
          initialState: state,
        );
        final behavior = RampResetBehavior();
        final parent = SpaceshipRamp.test(
          children: [behavior],
        );

        await game.pump(
          parent,
          gameBloc: gameBloc,
          bloc: bloc,
        );

        streamController
            .add(state.copyWith(roundScore: state.roundScore + 100));
        await Future<void>.delayed(Duration.zero);

        verifyNever(bloc.onReset);
      },
    );
  });
}
