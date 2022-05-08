// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/dash_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockDashBumperCubit extends Mock implements DashBumperCubit {}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'DashBumperBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          DashBumperBallContactBehavior(),
          isA<DashBumperBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact emits onBallContacted when contacts with a ball',
        (game) async {
          final behavior = DashBumperBallContactBehavior();
          final bloc = _MockDashBumperCubit();
          whenListen(
            bloc,
            const Stream<DashBumperState>.empty(),
            initialState: DashBumperState.active,
          );

          final bumper = DashBumper.test(bloc: bloc);
          await bumper.add(behavior);
          await game.ensureAdd(bumper);

          behavior.beginContact(_MockBall(), _MockContact());

          verify(bumper.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
