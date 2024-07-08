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

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final parent = Plunger.test();
        final behavior = PlungerJointingBehavior(compressionDistance: 0);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final plunger = game.descendants().whereType<Plunger>().single;
        expect(
          plunger.children.whereType<PlungerJointingBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'creates a joint',
      setUp: (game, _) async {
        final parent = Plunger.test();
        final behavior = PlungerJointingBehavior(compressionDistance: 0);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final plunger = game.descendants().whereType<Plunger>().single;
        expect(plunger.body.joints, isNotEmpty);
      },
    );
  });
}
