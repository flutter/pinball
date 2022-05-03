// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
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
      "when not shot doesn't increase multiplier "
      'neither add any score or show any score points',
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        whenListen(
          bloc,
          const Stream<SpaceshipRampState>.empty(),
          initialState: SpaceshipRampState.initial(),
        );
        final behavior = RampShotBehavior(
          points: shotPoints,
          scorePosition: Vector2.zero(),
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        await tester.pump();

        final scores = game.descendants().whereType<ScoreComponent>();
        await game.ready();

        verifyNever(() => gameBloc.add(MultiplierIncreased()));
        verifyNever(() => gameBloc.add(Scored(points: shotPoints.value)));
        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'when shot increase multiplier add score and show score points',
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        whenListen(
          bloc,
          const Stream<SpaceshipRampState>.empty(),
          initialState: SpaceshipRampState.initial().copyWith(
            shot: false,
          ),
        );
        final behavior = RampShotBehavior(
          points: shotPoints,
          scorePosition: Vector2.zero(),
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        await tester.pump();

        final scores = game.descendants().whereType<ScoreComponent>();
        await game.ready();

        verifyNever(() => gameBloc.add(MultiplierIncreased()));
        verifyNever(() => gameBloc.add(Scored(points: shotPoints.value)));
        expect(scores.length, 0);
      },
    );
  });
}
