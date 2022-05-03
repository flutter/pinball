// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';

import '../../../../helpers/helpers.dart';

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _MockContact extends Mock implements Contact {}

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
  ];

  final flameTester = FlameTester(() => TestGame(assets));

  group(
    'RampContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          RampContactBehavior(),
          isA<RampContactBehavior>(),
        );
      });

      flameTester.test(
        "beginContact with door sensor calls bloc 'onDoor'",
        (game) async {
          final ball = Ball(baseColor: Colors.red);
          final behavior = RampContactBehavior();
          final bloc = _MockSpaceshipRampCubit();
          whenListen(
            bloc,
            const Stream<SpaceshipRampState>.empty(),
            initialState: SpaceshipRampState.initial(),
          );

          final rampSensor = RampSensor.test(
            type: RampSensorType.door,
          );
          final spaceshipRamp = SpaceshipRamp.test(
            bloc: bloc,
          );

          await spaceshipRamp.add(rampSensor);
          await game.ensureAddAll([spaceshipRamp, ball]);
          await rampSensor.add(behavior);

          behavior.beginContact(ball, _MockContact());

          verify(() => bloc.onDoor(ball)).called(1);
        },
      );

      flameTester.test(
        "beginContact with inside sensor calls bloc 'onInside'",
        (game) async {
          final ball = Ball(baseColor: Colors.red);
          final behavior = RampContactBehavior();
          final bloc = _MockSpaceshipRampCubit();
          whenListen(
            bloc,
            const Stream<SpaceshipRampState>.empty(),
            initialState: SpaceshipRampState.initial(),
          );

          final rampSensor = RampSensor.test(
            type: RampSensorType.inside,
          );
          final spaceshipRamp = SpaceshipRamp.test(
            bloc: bloc,
          );

          await spaceshipRamp.add(rampSensor);
          await game.ensureAddAll([spaceshipRamp, ball]);
          await rampSensor.add(behavior);

          behavior.beginContact(ball, _MockContact());

          verify(() => bloc.onInside(ball)).called(1);
        },
      );
    },
  );
}
