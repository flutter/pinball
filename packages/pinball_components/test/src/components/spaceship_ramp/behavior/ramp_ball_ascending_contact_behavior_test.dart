// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';
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
    ]);
  }

  Future<void> pump(
    SpaceshipRamp children, {
    required SpaceshipRampCubit bloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
        value: bloc,
        children: [
          ZCanvasComponent(children: [children]),
        ],
      ),
    );
  }
}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _MockBall extends Mock implements Ball {}

class _MockBody extends Mock implements Body {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group(
    'RampBallAscendingContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          RampBallAscendingContactBehavior(),
          isA<RampBallAscendingContactBehavior>(),
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
          "calls 'onAscendingBallEntered' when a ball enters into the ramp",
          (game) async {
            final behavior = RampBallAscendingContactBehavior();
            final bloc = _MockSpaceshipRampCubit();
            whenListen(
              bloc,
              const Stream<SpaceshipRampState>.empty(),
              initialState: const SpaceshipRampState.initial(),
            );

            final opening = SpaceshipRampBoardOpening.test();
            final spaceshipRamp = SpaceshipRamp.test(
              children: [opening],
            );

            when(() => body.linearVelocity).thenReturn(Vector2(0, -1));

            await game.pump(
              spaceshipRamp,
              bloc: bloc,
            );
            await opening.ensureAdd(behavior);

            behavior.beginContact(ball, _MockContact());

            verify(bloc.onAscendingBallEntered).called(1);
          },
        );

        flameTester.test(
          "doesn't call 'onAscendingBallEntered' when a ball goes out the ramp",
          (game) async {
            final behavior = RampBallAscendingContactBehavior();
            final bloc = _MockSpaceshipRampCubit();
            whenListen(
              bloc,
              const Stream<SpaceshipRampState>.empty(),
              initialState: const SpaceshipRampState.initial(),
            );

            final opening = SpaceshipRampBoardOpening.test();
            final spaceshipRamp = SpaceshipRamp.test(
              children: [opening],
            );

            when(() => body.linearVelocity).thenReturn(Vector2(0, 1));

            await game.pump(
              spaceshipRamp,
              bloc: bloc,
            );
            await opening.ensureAdd(behavior);

            behavior.beginContact(ball, _MockContact());

            verifyNever(bloc.onAscendingBallEntered);
          },
        );
      });
    },
  );
}
