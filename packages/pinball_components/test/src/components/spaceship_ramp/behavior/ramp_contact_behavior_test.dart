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

class MockContact extends Mock implements Contact {}

class MockRampSensorCubit extends Mock implements RampSensorCubit {}

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
          final bloc = MockRampSensorCubit();
          whenListen(
            bloc,
            const Stream<RampSensorState>.empty(),
            initialState: RampSensorState(
              type: RampSensorType.door,
              ball: ball,
            ),
          );

          final rampSensor = RampSensor.test(
            type: RampSensorType.door,
            bloc: bloc,
          );
          final spaceshipRamp = SpaceshipRamp();

          await spaceshipRamp.add(rampSensor);
          await game.ensureAddAll([spaceshipRamp, ball]);
          await rampSensor.add(behavior);

          behavior.beginContact(ball, MockContact());

          verify(() => bloc.onDoor(ball)).called(1);
        },
      );

      flameTester.test(
        "beginContact with inside sensor calls bloc 'onInside'",
        (game) async {
          final ball = Ball(baseColor: Colors.red);
          final behavior = RampContactBehavior();
          final bloc = MockRampSensorCubit();
          whenListen(
            bloc,
            const Stream<RampSensorState>.empty(),
            initialState: RampSensorState(
              type: RampSensorType.inside,
              ball: ball,
            ),
          );

          final rampSensor = RampSensor.test(
            type: RampSensorType.inside,
            bloc: bloc,
          );
          final spaceshipRamp = SpaceshipRamp();

          await spaceshipRamp.add(rampSensor);
          await game.ensureAddAll([spaceshipRamp, ball]);
          await rampSensor.add(behavior);

          behavior.beginContact(ball, MockContact());

          verify(() => bloc.onInside(ball)).called(1);
        },
      );
    },
  );
}
