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
        flameTester.testGameWidget(
          'stops a ball',
          setUp: (game, _) async {
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
            await game.ready();
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<SparkyComputerSensorBallContactBehavior>()
                .single;
            final ball = _MockBall();
            await behavior.beginContact(ball, _MockContact());

            verify(ball.stop).called(1);
          },
        );

        flameTester.testGameWidget(
          'emits onBallEntered when contacts with a ball',
          setUp: (game, _) async {
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
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<SparkyComputerSensorBallContactBehavior>()
                .single;
            final sparkyComputer =
                game.descendants().whereType<SparkyComputer>().single;
            await behavior.beginContact(_MockBall(), _MockContact());

            verify(sparkyComputer.bloc.onBallEntered).called(1);
          },
        );

        flameTester.testGameWidget(
          'adds TimerComponent when contacts with a ball',
          setUp: (game, _) async {
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
          },
          verify: (game, _) async {
            final sparkyComputer =
                game.descendants().whereType<SparkyComputer>().single;
            expect(
              sparkyComputer.firstChild<TimerComponent>(),
              isA<TimerComponent>(),
            );
          },
        );

        flameTester.testGameWidget(
          'TimerComponent resumes ball and calls onBallTurboCharged onTick',
          setUp: (game, _) async {
            await game.onLoad();
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
            await game.ready();
          },
          verify: (game, tester) async {
            final ball = _MockBall();
            final behavior = game
                .descendants()
                .whereType<SparkyComputerSensorBallContactBehavior>()
                .single;
            final sparkyComputer =
                game.descendants().whereType<SparkyComputer>().single;
            await behavior.beginContact(ball, _MockContact());
            game.update(0);

            game.update(
              sparkyComputer.firstChild<TimerComponent>()!.timer.limit,
            );
            game.update(1);

            verify(ball.resume).called(1);
            await tester.pump();
            verify(sparkyComputer.bloc.onBallTurboCharged).called(1);
          },
        );
      });
    },
  );
}
