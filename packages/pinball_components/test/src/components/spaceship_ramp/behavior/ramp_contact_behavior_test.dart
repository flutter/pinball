// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';

import '../../../../helpers/helpers.dart';

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _MockBall extends Mock implements Ball {}

class _MockBody extends Mock implements Body {}

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

      group('beginContact', () {
        late Ball ball;
        late Body body;

        setUp(() {
          ball = _MockBall();
          body = _MockBody();

          when(() => ball.body).thenReturn(body);
        });

        flameTester.test(
          "calls 'onInside' when a ball enters into the ramp",
          (game) async {
            final behavior = RampContactBehavior();
            final bloc = _MockSpaceshipRampCubit();
            whenListen(
              bloc,
              const Stream<SpaceshipRampState>.empty(),
              initialState: SpaceshipRampState.initial(),
            );

            final rampSensor = RampScoringSensor.test();
            final spaceshipRamp = SpaceshipRamp.test(
              bloc: bloc,
            );

            when(() => body.linearVelocity).thenReturn(Vector2(0, 1));

            await spaceshipRamp.add(rampSensor);
            await game.ensureAddAll([spaceshipRamp, ball]);
            await rampSensor.add(behavior);

            behavior.beginContact(ball, _MockContact());

            verify(bloc.onInside).called(1);
          },
        );

        flameTester.test(
          "doesn't call 'onInside' when a ball goes out the ramp",
          (game) async {
            final behavior = RampContactBehavior();
            final bloc = _MockSpaceshipRampCubit();
            whenListen(
              bloc,
              const Stream<SpaceshipRampState>.empty(),
              initialState: SpaceshipRampState.initial(),
            );

            final rampSensor = RampScoringSensor.test();
            final spaceshipRamp = SpaceshipRamp.test(
              bloc: bloc,
            );

            when(() => body.linearVelocity).thenReturn(Vector2(0, -1));

            await spaceshipRamp.add(rampSensor);
            await game.ensureAddAll([spaceshipRamp, ball]);
            await rampSensor.add(behavior);

            behavior.beginContact(ball, _MockContact());

            verifyNever(bloc.onInside);
          },
        );
      });
    },
  );
}
