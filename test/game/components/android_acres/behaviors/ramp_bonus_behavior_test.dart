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

  group('RampBonusBehavior', () {
    const bonusPoints = 1000000;

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
      "hit on door sensor doesn't add any score",
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        final behavior = RampBonusBehavior(
          points: bonusPoints,
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

        verifyNever(() => gameBloc.add(Scored(points: bonusPoints)));
        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'hit on inside sensor without previous hit on door sensor '
      "doesn't add any score",
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);

        final behavior = RampBonusBehavior(
          points: bonusPoints,
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

        verifyNever(() => gameBloc.add(Scored(points: bonusPoints)));
        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'hit on inside sensor after hit on door sensor '
      "less than 10 times doesn't add any score neither shows score points",
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        const bonusPoints = 1000000;
        final behavior = RampBonusBehavior(
          points: bonusPoints,
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

        verifyNever(() => gameBloc.add(Scored(points: bonusPoints)));
        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'hit on inside sensor after hit on door sensor '
      '10 times add score and show score point',
      setUp: (game, tester) async {
        final ball = Ball(baseColor: Colors.red);
        const bonusPoints = 1000000;
        final behavior = RampBonusBehavior(
          points: bonusPoints,
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

        for (var i = 0; i < 10; i++) {
          doorSensor.bloc.onDoor(ball);
          insideSensor.bloc.onInside(ball);
        }

        await tester.pump();

        final scores = game.descendants().whereType<ScoreText>();
        await game.ready();

        verify(() => gameBloc.add(Scored(points: bonusPoints))).called(1);
        expect(scores.length, 1);
      },
    );
  });
}
