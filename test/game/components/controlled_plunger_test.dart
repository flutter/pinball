import 'dart:collection';

import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballGameTest.new);

  group('PlungerController', () {
    group('onKeyEvent', () {
      final downKeys = UnmodifiableListView([
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.keyS,
      ]);

      late Plunger plunger;
      late PlungerController controller;

      setUp(() {
        plunger = Plunger(compressionDistance: 10);
        controller = PlungerController(plunger);
        plunger.add(controller);
      });

      testRawKeyDownEvents(downKeys, (event) {
        flameTester.test(
          'moves down '
          'when ${event.logicalKey.keyLabel} is pressed',
          (game) async {
            await game.ready();
            await game.add(plunger);
            controller.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isNegative);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });

      testRawKeyUpEvents(downKeys, (event) {
        flameTester.test(
          'moves up '
          'when ${event.logicalKey.keyLabel} is released',
          (game) async {
            await game.ready();
            await game.add(plunger);
            controller.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isPositive);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });
    });
  });
}
