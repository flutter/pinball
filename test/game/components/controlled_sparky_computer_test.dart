// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('SparkyComputerController', () {
    late ControlledSparkyComputer controlledSparkyComputer;

    setUp(() {
      controlledSparkyComputer = ControlledSparkyComputer();
    });

    test('can be instantiated', () {
      expect(
        SparkyComputerController(controlledSparkyComputer),
        isA<SparkyComputerController>(),
      );
    });
  });
}
