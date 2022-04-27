// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/alien_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'AlienBumperBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          AlienBumperBallContactBehavior(),
          isA<AlienBumperBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact emits onBallContacted when contacts with a ball',
        (game) async {
          final behavior = AlienBumperBallContactBehavior();
          final bloc = MockAlienBumperCubit();
          whenListen(
            bloc,
            const Stream<AlienBumperState>.empty(),
            initialState: AlienBumperState.active,
          );

          final alienBumper = AlienBumper.test(bloc: bloc);
          await alienBumper.add(behavior);
          await game.ensureAdd(alienBumper);

          behavior.beginContact(MockBall(), MockContact());

          verify(alienBumper.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
