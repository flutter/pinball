// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/src/components/components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FlipperJointingBehavior', () {
    final flameTester = FlameTester(TestGame.new);

    test('can be instantiated', () {
      expect(
        FlipperJointingBehavior(),
        isA<FlipperJointingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final behavior = FlipperJointingBehavior();
      final parent = Flipper.test(side: BoardSide.left);
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.contains(behavior), isTrue);
    });

    flameTester.test('creates a joint', (game) async {
      final behavior = FlipperJointingBehavior();
      final parent = Flipper.test(side: BoardSide.left);
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);

      expect(parent.body.joints, isNotEmpty);
    });
  });
}
