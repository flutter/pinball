// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.spaceship.ramp.boardOpening.keyName,
    Assets.images.spaceship.ramp.railingForeground.keyName,
    Assets.images.spaceship.ramp.railingBackground.keyName,
    Assets.images.spaceship.ramp.main.keyName,
    Assets.images.spaceship.ramp.arrow.inactive.keyName,
    Assets.images.spaceship.ramp.arrow.active1.keyName,
    Assets.images.spaceship.ramp.arrow.active2.keyName,
    Assets.images.spaceship.ramp.arrow.active3.keyName,
    Assets.images.spaceship.ramp.arrow.active4.keyName,
    Assets.images.spaceship.ramp.arrow.active5.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

  group('ControlledSpaceshipRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final controlledSpaceshipRamp = ControlledSpaceshipRamp();
        await game.ensureAdd(controlledSpaceshipRamp);

        expect(game.contains(controlledSpaceshipRamp), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'a SpaceshipRamp',
        (game) async {
          final controlledSpaceshipRamp = ControlledSpaceshipRamp();
          await game.ensureAdd(controlledSpaceshipRamp);

          expect(
            controlledSpaceshipRamp
                .descendants()
                .whereType<SpaceshipRamp>()
                .length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'two SpaceshipRampSensor',
        (game) async {
          final controlledSpaceshipRamp = ControlledSpaceshipRamp();
          await game.ensureAdd(controlledSpaceshipRamp);

          expect(
            controlledSpaceshipRamp
                .descendants()
                .whereType<SpaceshipRampSensor>()
                .length,
            equals(2),
          );
        },
      );
    });
  });

  group('SpaceshipRampController', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(EmptyPinballTestGame.new);

    late ControlledSpaceshipRamp controlledSpaceshipRamp;

    setUp(() {
      controlledSpaceshipRamp = ControlledSpaceshipRamp();
    });

    test('can be instantiated', () {
      expect(
        SpaceshipRampController(controlledSpaceshipRamp),
        isA<SpaceshipRampController>(),
      );
    });

    group('shot', () {});

    flameTester.testGameWidget(
      'SpaceshipRampSensorBallContactCallback turbo charges the ball',
      setUp: (game, tester) async {
        final controlledSpaceshipRamp = MockControlledSpaceshipRamp();
        final controller = MockSpaceshipRampController();
        final contactCallback = SpaceshipRampSensorBallContactCallback();
        final spaceshipRampSensor = MockSpaceshipRampSensor();
        final ball = MockControlledBall();

        when(() => spaceshipRampSensor.type)
            .thenReturn(SpaceshipRampSensorType.door);
        when(() => spaceshipRampSensor.parent)
            .thenReturn(controlledSpaceshipRamp);
        when(() => controlledSpaceshipRamp.controller).thenReturn(controller);
        when(controller.shot).thenAnswer((_) async {});

        contactCallback.begin(spaceshipRampSensor, ball, MockContact());

        verify(controller.shot).called(1);
      },
    );
  });
}
