// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('PlungerJointingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerJointingBehavior(compressionDistance: 0),
        isA<PlungerJointingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final parent = Plunger.test();
      final behavior = PlungerJointingBehavior(compressionDistance: 0);
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    flameTester.test('creates a joint', (game) async {
      final behavior = PlungerJointingBehavior(compressionDistance: 0);
      final parent = Plunger.test();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.body.joints, isNotEmpty);
    });
  });
}
