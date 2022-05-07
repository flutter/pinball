// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_computer/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockSparkyComputerCubit extends Mock implements SparkyComputerCubit {}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'SparkyComputerSensorBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          SparkyComputerSensorBallContactBehavior(),
          isA<SparkyComputerSensorBallContactBehavior>(),
        );
      });

      group('beginContact', () {
        flameTester.test(
          'stops a ball',
          (game) async {
            final behavior = SparkyComputerSensorBallContactBehavior();
            final bloc = _MockSparkyComputerCubit();
            whenListen(
              bloc,
              const Stream<SparkyComputerState>.empty(),
              initialState: SparkyComputerState.withoutBall,
            );

            final sparkyComputer = SparkyComputer.test(
              bloc: bloc,
            );
            await sparkyComputer.add(behavior);
            await game.ensureAdd(sparkyComputer);

            final ball = _MockBall();
            await behavior.beginContact(ball, _MockContact());

            verify(ball.stop).called(1);
          },
        );

        flameTester.test(
          'emits onBallEntered when contacts with a ball',
          (game) async {
            final behavior = SparkyComputerSensorBallContactBehavior();
            final bloc = _MockSparkyComputerCubit();
            whenListen(
              bloc,
              const Stream<SparkyComputerState>.empty(),
              initialState: SparkyComputerState.withoutBall,
            );

            final sparkyComputer = SparkyComputer.test(
              bloc: bloc,
            );
            await sparkyComputer.add(behavior);
            await game.ensureAdd(sparkyComputer);

            await behavior.beginContact(_MockBall(), _MockContact());

            verify(sparkyComputer.bloc.onBallEntered).called(1);
          },
        );

        flameTester.test(
          'adds TimerComponent when contacts with a ball',
          (game) async {
            final behavior = SparkyComputerSensorBallContactBehavior();
            final bloc = _MockSparkyComputerCubit();
            whenListen(
              bloc,
              const Stream<SparkyComputerState>.empty(),
              initialState: SparkyComputerState.withoutBall,
            );

            final sparkyComputer = SparkyComputer.test(
              bloc: bloc,
            );
            await sparkyComputer.add(behavior);
            await game.ensureAdd(sparkyComputer);

            await behavior.beginContact(_MockBall(), _MockContact());
            await game.ready();

            expect(
              sparkyComputer.firstChild<TimerComponent>(),
              isA<TimerComponent>(),
            );
          },
        );

        flameTester.test(
          'TimerComponent resumes ball and calls onBallTurboCharged onTick',
          (game) async {
            final behavior = SparkyComputerSensorBallContactBehavior();
            final bloc = _MockSparkyComputerCubit();
            whenListen(
              bloc,
              const Stream<SparkyComputerState>.empty(),
              initialState: SparkyComputerState.withoutBall,
            );

            final sparkyComputer = SparkyComputer.test(
              bloc: bloc,
            );
            await sparkyComputer.add(behavior);
            await game.ensureAdd(sparkyComputer);

            final ball = _MockBall();
            await behavior.beginContact(ball, _MockContact());
            await game.ready();
            game.update(
              sparkyComputer.firstChild<TimerComponent>()!.timer.limit,
            );
            await game.ready();

            verify(ball.resume).called(1);
            verify(sparkyComputer.bloc.onBallTurboCharged).called(1);
          },
        );
      });
    },
  );
}
