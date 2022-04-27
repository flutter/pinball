// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/dash_nest_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'DashNestBumperBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          DashNestBumperBallContactBehavior(),
          isA<DashNestBumperBallContactBehavior>(),
        );
      });

      group(
        'beginContact',
        () {
          flameTester.test('emits onBallContacted when contacts with a ball',
              (game) async {
            final behavior = DashNestBumperBallContactBehavior();
            final bloc = MockDashNestBumperCubit();
            whenListen(
              bloc,
              const Stream<DashNestBumperState>.empty(),
              initialState: DashNestBumperState.active,
            );

            final alienBumper = DashNestBumper.test(bloc: bloc);
            await alienBumper.add(behavior);
            await game.ensureAdd(alienBumper);

            behavior.beginContact(MockBall(), MockContact());

            verify(alienBumper.bloc.onBallContacted).called(1);
          });
        },
      );
    },
  );
}
