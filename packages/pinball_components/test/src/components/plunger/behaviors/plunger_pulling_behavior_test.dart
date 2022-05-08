import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('PlungerPullingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerPullingBehavior(strength: 0),
        isA<PlungerPullingBehavior>(),
      );
    });
  });

  group('PlungerAutoPullingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerAutoPullingBehavior(strength: 0),
        isA<PlungerAutoPullingBehavior>(),
      );
    });
  });
}
