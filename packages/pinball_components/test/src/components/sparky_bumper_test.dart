// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

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

    flameTester.test('activate returns normally', (game) async {
      final bumper = SparkyBumper.a();
      await game.ensureAdd(bumper);

      expect(bumper.activate, returnsNormally);
    });

    flameTester.test('deactivate returns normally', (game) async {
      final bumper = SparkyBumper.a();
      await game.ensureAdd(bumper);

      expect(bumper.deactivate, returnsNormally);
    });

    flameTester.test('changes sprite', (game) async {
      final bumper = SparkyBumper.a();
      await game.ensureAdd(bumper);

      final spriteComponent = bumper.firstChild<SpriteComponent>()!;

      final deactivatedSprite = spriteComponent.sprite;
      bumper.activate();
      expect(
        spriteComponent.sprite,
        isNot(equals(deactivatedSprite)),
      );

      final activatedSprite = spriteComponent.sprite;
      bumper.deactivate();
      expect(
        spriteComponent.sprite,
        isNot(equals(activatedSprite)),
      );

      expect(
        activatedSprite,
        isNot(equals(deactivatedSprite)),
      );
    });
  });
}
