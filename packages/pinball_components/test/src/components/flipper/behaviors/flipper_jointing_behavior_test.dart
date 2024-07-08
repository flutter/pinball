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

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final parent = Flipper.test(side: BoardSide.left);
        final behavior = FlipperJointingBehavior();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final parent = game.descendants().whereType<Flipper>().single;
        final behavior =
            game.descendants().whereType<FlipperJointingBehavior>().single;
        expect(parent.contains(behavior), isTrue);
      },
    );

    flameTester.testGameWidget(
      'creates a joint',
      setUp: (game, _) async {
        final parent = Flipper.test(side: BoardSide.left);
        final behavior = FlipperJointingBehavior();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final parent = game.descendants().whereType<Flipper>().single;
        expect(parent.body.joints, isNotEmpty);
      },
    );
  });
}
