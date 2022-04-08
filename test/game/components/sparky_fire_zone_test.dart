// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballGameTest.new);

  group('SparkyFireZone', () {
    group('bumpers', () {
      late ControlledSparkyBumper controlledSparkyBumper;

      flameTester.testGameWidget(
        'activate when deactivated bumper is hit',
        setUp: (game, tester) async {
          controlledSparkyBumper = ControlledSparkyBumper();
          await game.ensureAdd(controlledSparkyBumper);

          controlledSparkyBumper.controller.hit();
        },
        verify: (game, tester) async {
          expect(controlledSparkyBumper.controller.isActivated, isTrue);
        },
      );

      flameTester.testGameWidget(
        'deactivate when activated bumper is hit',
        setUp: (game, tester) async {
          controlledSparkyBumper = ControlledSparkyBumper();
          await game.ensureAdd(controlledSparkyBumper);

          controlledSparkyBumper.controller.hit();
          controlledSparkyBumper.controller.hit();
        },
        verify: (game, tester) async {
          expect(controlledSparkyBumper.controller.isActivated, isFalse);
        },
      );
    });
  });
}
