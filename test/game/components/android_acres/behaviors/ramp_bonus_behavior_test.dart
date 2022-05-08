// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
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
      Assets.images.score.oneMillion.keyName,
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RampBonusBehavior', () {
    const shotPoints = Points.oneMillion;

    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.test(
      'when hits are multiples of 10 times adds a ScoringBehavior',
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        final behavior = RampBonusBehavior(points: shotPoints);
        final parent = SpaceshipRamp.test();

        await game.pump(
          parent,
          gameBloc: gameBloc,
          spaceshipRampCubit: bloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(state.copyWith(hits: 10));

        final scores = game.descendants().whereType<ScoringBehavior>();
        await game.ready();

        expect(scores.length, 1);
      },
    );

    flameTester.test(
      "when hits are not multiple of 10 times doesn't add any ScoringBehavior",
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        final behavior = RampBonusBehavior(points: shotPoints);
        final parent = SpaceshipRamp.test();

        await game.pump(
          parent,
          gameBloc: gameBloc,
          spaceshipRampCubit: bloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(state.copyWith(hits: 9));

        final scores = game.descendants().whereType<ScoringBehavior>();
        await game.ready();

        expect(scores.length, 0);
      },
    );
  });
}
