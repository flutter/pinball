// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'AndroidBumperBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          AndroidBumperBallContactBehavior(),
          isA<AndroidBumperBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact emits onBallContacted when contacts with a ball',
        (game) async {
          final behavior = AndroidBumperBallContactBehavior();
          final bloc = MockAndroidBumperCubit();
          whenListen(
            bloc,
            const Stream<AndroidBumperState>.empty(),
            initialState: AndroidBumperState.lit,
          );

          final androidBumper = AndroidBumper.test(bloc: bloc);
          await androidBumper.add(behavior);
          await game.ensureAdd(androidBumper);

          behavior.beginContact(MockBall(), MockContact());

          verify(androidBumper.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
