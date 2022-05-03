// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockSparkyBumperCubit extends Mock implements SparkyBumperCubit {}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

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
          final bloc = _MockSparkyBumperCubit();
          whenListen(
            bloc,
            const Stream<SparkyBumperState>.empty(),
            initialState: SparkyBumperState.lit,
          );

          final sparkyBumper = SparkyBumper.test(bloc: bloc);
          await sparkyBumper.add(behavior);
          await game.ensureAdd(sparkyBumper);

          behavior.beginContact(_MockBall(), _MockContact());

          verify(sparkyBumper.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
