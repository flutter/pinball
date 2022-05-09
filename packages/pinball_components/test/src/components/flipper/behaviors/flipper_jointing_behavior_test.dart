// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FlipperJointingBehavior', () {
    final flameTester = FlameTester(Forge2DGame.new);

    test('can be instantiated', () {
      expect(
        FlipperJointingBehavior(),
        isA<FlipperJointingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final parent = Flipper.test(side: BoardSide.left);
      final behavior = FlipperJointingBehavior();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.contains(behavior), isTrue);
    });

    flameTester.test('creates a joint', (game) async {
      final parent = Flipper.test(side: BoardSide.left);
      final behavior = FlipperJointingBehavior();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.body.joints, isNotEmpty);
    });
  });
}
