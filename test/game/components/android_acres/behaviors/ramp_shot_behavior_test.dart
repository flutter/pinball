// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.spaceship.saucer.keyName,
    Assets.images.android.spaceship.animatronic.keyName,
    Assets.images.android.spaceship.lightBeam.keyName,
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
    Assets.images.android.bumper.a.lit.keyName,
    Assets.images.android.bumper.a.dimmed.keyName,
    Assets.images.android.bumper.b.lit.keyName,
    Assets.images.android.bumper.b.dimmed.keyName,
    Assets.images.android.bumper.cow.lit.keyName,
    Assets.images.android.bumper.cow.dimmed.keyName,
  ];

  group('RampShotBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = MockGameBloc();
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
      "hit on door sensor doesn't increase multiplier "
      'neither add any score or show any score points',
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        const shotPoints = 5000;
        final behavior = RampShotBehavior(
          points: shotPoints,
          scorePosition: Vector2.zero(),
        );
        final parent = AndroidAcres.test();
        final sensors = [
          RampSensor.test(
            type: RampSensorType.door,
            bloc: RampSensorCubit(),
          ),
        ];

        await parent.addAll(sensors);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        for (final sensor in sensors) {
          sensor.bloc.onDoor(ball);
        }
        await tester.pump();

        final scores = game.descendants().whereType<ScoreText>();
        await game.ready();

        verifyNever(() => gameBloc.add(MultiplierIncreased()));
        verifyNever(() => gameBloc.add(Scored(points: shotPoints)));
        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'hit on inside sensor without previous hit on door sensor '
      "doesn't increase multiplier neither add any score or shows score points",
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        const shotPoints = 5000;
        final behavior = RampShotBehavior(
          points: shotPoints,
          scorePosition: Vector2.zero(),
        );
        final parent = AndroidAcres.test();
        final doorSensor = RampSensor.test(
          type: RampSensorType.door,
          bloc: RampSensorCubit(),
        );
        final insideSensor = RampSensor.test(
          type: RampSensorType.inside,
          bloc: RampSensorCubit(),
        );

        await parent.addAll([doorSensor, insideSensor]);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        insideSensor.bloc.onInside(ball);

        await tester.pump();

        final scores = game.descendants().whereType<ScoreText>();
        await game.ready();

        verifyNever(() => gameBloc.add(MultiplierIncreased()));
        verifyNever(() => gameBloc.add(Scored(points: shotPoints)));
        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'hit on inside sensor after hit on door sensor '
      'increase multiplier',
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        const shotPoints = 5000;
        final behavior = RampShotBehavior(
          points: shotPoints,
          scorePosition: Vector2.zero(),
        );
        final parent = AndroidAcres.test();
        final doorSensor = RampSensor.test(
          type: RampSensorType.door,
          bloc: RampSensorCubit(),
        );
        final insideSensor = RampSensor.test(
          type: RampSensorType.inside,
          bloc: RampSensorCubit(),
        );

        await parent.addAll([doorSensor, insideSensor]);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        doorSensor.bloc.onDoor(ball);
        insideSensor.bloc.onInside(ball);

        await tester.pump();

        verify(() => gameBloc.add(MultiplierIncreased())).called(1);
      },
    );

    flameBlocTester.testGameWidget(
      'hit on inside sensor after hit on door sensor '
      'add score and show score points',
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        const shotPoints = 5000;
        final behavior = RampShotBehavior(
          points: shotPoints,
          scorePosition: Vector2.zero(),
        );
        final parent = AndroidAcres.test();
        final doorSensor = RampSensor.test(
          type: RampSensorType.door,
          bloc: RampSensorCubit(),
        );
        final insideSensor = RampSensor.test(
          type: RampSensorType.inside,
          bloc: RampSensorCubit(),
        );

        await parent.addAll([doorSensor, insideSensor]);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        doorSensor.bloc.onDoor(ball);
        insideSensor.bloc.onInside(ball);

        await tester.pump();

        final scores = game.descendants().whereType<ScoreText>();
        await game.ready();

        verify(() => gameBloc.add(Scored(points: shotPoints))).called(1);
        expect(scores.length, 1);
      },
    );
  });
}
