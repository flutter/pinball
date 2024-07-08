// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
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
    List<Component> children, {
    required SpaceshipRampCubit bloc,
    required GameBloc gameBloc,
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
          ZCanvasComponent(children: children),
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameBloc gameBloc;

  setUp(() {
    gameBloc = _MockGameBloc();
  });

  group('RampBonusBehavior', () {
    const shotPoints = Points.oneMillion;

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'when hits are multiples of 10 times adds a ScoringBehavior',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );

        final behavior = RampBonusBehavior(points: shotPoints);
        final parent = SpaceshipRamp.test(children: [behavior]);
        await game.pump(
          [parent],
          bloc: bloc,
          gameBloc: gameBloc,
        );

        streamController.add(state.copyWith(hits: 10));

        await game.ready();
      },
      verify: (game, tester) async {
        game.update(0);
        await tester.pump();
        final scores = game.descendants().whereType<ScoringBehavior>();
        expect(scores.length, 1);
      },
    );

    flameTester.testGameWidget(
      "when hits are not multiple of 10 times doesn't add any ScoringBehavior",
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );

        final behavior = RampBonusBehavior(points: shotPoints);
        final parent = SpaceshipRamp.test(children: [behavior]);
        await game.pump(
          [parent],
          bloc: bloc,
          gameBloc: gameBloc,
        );

        streamController.add(state.copyWith(hits: 9));

        await game.ready();
      },
      verify: (game, tester) async {
        game.update(0);
        await tester.pump();
        final scores = game.descendants().whereType<ScoringBehavior>();
        expect(scores.length, 0);
      },
    );
  });
}
