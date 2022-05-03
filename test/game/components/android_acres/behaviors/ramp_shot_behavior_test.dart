// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
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
  ];

  group('RampShotBehavior', () {
    const shotPoints = Points.fiveThousand;

    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
      assets: assets,
    );

    flameBlocTester.testGameWidget(
      'when hits are not multiple of 10 times '
      'increase multiplier, add score and show score points',
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState.initial(),
        );
        final behavior = RampShotBehavior(
          points: shotPoints,
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        streamController.add(SpaceshipRampState(hits: 1));

        final scores = game.descendants().whereType<ScoreComponent>();
        await game.ready();

        verify(() => gameBloc.add(MultiplierIncreased())).called(1);
        verify(() => gameBloc.add(Scored(points: shotPoints.value))).called(1);
        expect(scores.length, 1);
      },
    );

    flameBlocTester.testGameWidget(
      'when hits multiple of 10 times '
      "doesn't increase multiplier, neither add score or show score points",
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState(hits: 9),
        );
        final behavior = RampShotBehavior(
          points: shotPoints,
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        streamController.add(SpaceshipRampState(hits: 10));

        final scores = game.descendants().whereType<ScoreComponent>();
        await game.ready();

        verifyNever(() => gameBloc.add(MultiplierIncreased()));
        verifyNever(() => gameBloc.add(Scored(points: shotPoints.value)));
        expect(scores.length, 0);
      },
    );
  });
}
