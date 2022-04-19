// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.on.keyName,
    Assets.images.sparky.bumper.a.off.keyName,
    Assets.images.sparky.bumper.b.on.keyName,
    Assets.images.sparky.bumper.b.off.keyName,
    Assets.images.sparky.bumper.c.on.keyName,
    Assets.images.sparky.bumper.c.off.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SparkyBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final bumper = SparkyBumper.a();
      await game.ensureAdd(bumper);

      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final bumper = SparkyBumper.b();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"c" loads correctly', (game) async {
      final bumper = SparkyBumper.c();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('animate switches between on and off sprites',
        (game) async {
      final bumper = SparkyBumper.a();
      await game.ensureAdd(bumper);

      final spriteGroupComponent = bumper.firstChild<SpriteGroupComponent>()!;

      expect(
        spriteGroupComponent.current,
        equals(SparkyBumperSpriteState.on),
      );

      final future = bumper.animate();

      expect(
        spriteGroupComponent.current,
        equals(SparkyBumperSpriteState.off),
      );

      await future;

      expect(
        spriteGroupComponent.current,
        equals(SparkyBumperSpriteState.on),
      );
    });
  });
}
