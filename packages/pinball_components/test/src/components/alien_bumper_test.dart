// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.alienBumper.a.on.keyName,
    Assets.images.alienBumper.a.off.keyName,
    Assets.images.alienBumper.b.on.keyName,
    Assets.images.alienBumper.b.off.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('AlienBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final bumper = AlienBumper.a();
      await game.ensureAdd(bumper);

      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final bumper = AlienBumper.b();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('animate switches between on and off sprites',
        (game) async {
      final bumper = AlienBumper.a();
      await game.ensureAdd(bumper);

      final spriteGroupComponent = bumper.firstChild<SpriteGroupComponent>()!;

      expect(
        spriteGroupComponent.current,
        equals(AlienBumperSpriteState.on),
      );

      final future = bumper.animate();

      expect(
        spriteGroupComponent.current,
        equals(AlienBumperSpriteState.off),
      );

      await future;

      expect(
        spriteGroupComponent.current,
        equals(AlienBumperSpriteState.on),
      );
    });
  });
}
