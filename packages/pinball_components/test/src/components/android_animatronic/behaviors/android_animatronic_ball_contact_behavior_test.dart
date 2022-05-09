// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_animatronic/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockAndroidSpaceshipCubit extends Mock implements AndroidSpaceshipCubit {
}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'AndroidAnimatronicBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          AndroidAnimatronicBallContactBehavior(),
          isA<AndroidAnimatronicBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact calls onBallContacted when in contact with a ball',
        (game) async {
          final behavior = AndroidAnimatronicBallContactBehavior();
          final bloc = _MockAndroidSpaceshipCubit();
          whenListen(
            bloc,
            const Stream<AndroidSpaceshipState>.empty(),
            initialState: AndroidSpaceshipState.withoutBonus,
          );

          final animatronic = AndroidAnimatronic.test();
          final androidSpaceship = FlameBlocProvider<AndroidSpaceshipCubit,
              AndroidSpaceshipState>.value(
            value: bloc,
            children: [
              AndroidSpaceship.test(children: [animatronic])
            ],
          );
          await animatronic.add(behavior);
          await game.ensureAdd(androidSpaceship);

          behavior.beginContact(_MockBall(), _MockContact());

          verify(bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
