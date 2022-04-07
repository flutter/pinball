import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SparkyBumperController', () {
    late SparkyBumper sparkyBumper;

    setUp(() {
      sparkyBumper = MockSparkyBumper();
    });

    test('toggle activated state when bumper is hit', () {
      final controller = SparkyBumperController(sparkyBumper);

      when(() => sparkyBumper.activate()).thenReturn(null);
      when(() => sparkyBumper.deactivate()).thenReturn(null);

      controller
        ..hit()
        ..hit();

      verifyInOrder([
        () => sparkyBumper.activate(),
        () => sparkyBumper.deactivate(),
      ]);
    });
  });
}
