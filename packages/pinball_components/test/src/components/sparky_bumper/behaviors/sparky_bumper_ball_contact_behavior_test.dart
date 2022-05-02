// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'SparkyBumperBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          SparkyBumperBallContactBehavior(),
          isA<SparkyBumperBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact emits onBallContacted when contacts with a ball',
        (game) async {
          final behavior = SparkyBumperBallContactBehavior();
          final bloc = MockSparkyBumperCubit();
          whenListen(
            bloc,
            const Stream<SparkyBumperState>.empty(),
            initialState: SparkyBumperState.lit,
          );

          final sparkyBumper = SparkyBumper.test(bloc: bloc);
          await sparkyBumper.add(behavior);
          await game.ensureAdd(sparkyBumper);

          behavior.beginContact(MockBall(), MockContact());

          verify(sparkyBumper.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
