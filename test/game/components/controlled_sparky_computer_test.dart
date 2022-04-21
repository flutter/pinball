// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ControlledSparkyComputer', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(EmptyPinballTestGame.new);

    flameTester.test('loads correctly', (game) async {
      final sparkyComputer = ControlledSparkyComputer();
      await game.ensureAdd(sparkyComputer);
      expect(game.children, contains(sparkyComputer));
    });

    flameTester.testGameWidget(
      'SparkyTurboChargeSensorBallContactCallback turbo charges the ball',
      setUp: (game, tester) async {
        final contackCallback = SparkyComputerSensorBallContactCallback();
        final sparkyTurboChargeSensor = MockSparkyComputerSensor();
        final ball = MockControlledBall();
        final controller = MockBallController();

        when(() => ball.controller).thenReturn(controller);
        when(controller.turboCharge).thenAnswer((_) async {});

        contackCallback.begin(sparkyTurboChargeSensor, ball, MockContact());

        verify(() => ball.controller.turboCharge()).called(1);
      },
    );
  });
}
