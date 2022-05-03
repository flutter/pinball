// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_spaceship/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockAndroidSpaceshipCubit extends Mock implements AndroidSpaceshipCubit {
}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'AndroidSpaceshipEntranceBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          AndroidSpaceshipEntranceBallContactBehavior(),
          isA<AndroidSpaceshipEntranceBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact calls onBallEntered when entrance contacts with a ball',
        (game) async {
          final behavior = AndroidSpaceshipEntranceBallContactBehavior();
          final bloc = _MockAndroidSpaceshipCubit();
          whenListen(
            bloc,
            const Stream<AndroidSpaceshipState>.empty(),
            initialState: AndroidSpaceshipState.withoutBonus,
          );

          final entrance = AndroidSpaceshipEntrance();
          final androidSpaceship = AndroidSpaceship.test(
            bloc: bloc,
            children: [entrance],
          );
          await entrance.add(behavior);
          await game.ensureAdd(androidSpaceship);

          behavior.beginContact(_MockBall(), _MockContact());

          verify(androidSpaceship.bloc.onBallEntered).called(1);
        },
      );
    },
  );
}
