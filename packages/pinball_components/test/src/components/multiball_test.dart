// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.a.active.keyName,
    Assets.images.multiball.a.inactive.keyName,
    Assets.images.multiball.b.active.keyName,
    Assets.images.multiball.b.inactive.keyName,
    Assets.images.multiball.c.active.keyName,
    Assets.images.multiball.c.inactive.keyName,
    Assets.images.multiball.d.active.keyName,
    Assets.images.multiball.d.inactive.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('Multiball', () {
    group('loads correctly', () {
      flameTester.test('"a"', (game) async {
        final multiball = Multiball.a();
        await game.ensureAdd(multiball);

        expect(game.contains(multiball), isTrue);
      });

      flameTester.test('"b"', (game) async {
        final multiball = Multiball.b();
        await game.ensureAdd(multiball);
        expect(game.contains(multiball), isTrue);
      });

      flameTester.test('"c"', (game) async {
        final multiball = Multiball.c();
        await game.ensureAdd(multiball);

        expect(game.contains(multiball), isTrue);
      });

      flameTester.test('"d"', (game) async {
        final multiball = Multiball.d();
        await game.ensureAdd(multiball);
        expect(game.contains(multiball), isTrue);
      });
    });

    // TODO(ruimiguel): needs to add golden tests for multiball states.

    flameTester.test('animate switches between on and off sprites',
        (game) async {
      final multiball = Multiball.a();
      await game.ensureAdd(multiball);

      final spriteGroupComponent =
          multiball.firstChild<SpriteGroupComponent>()!;

      expect(
        spriteGroupComponent.current,
        equals(MultiballSpriteState.inactive),
      );

      final future = multiball.animate();

      expect(
        spriteGroupComponent.current,
        equals(MultiballSpriteState.active),
      );

      await future;

      expect(
        spriteGroupComponent.current,
        equals(MultiballSpriteState.inactive),
      );
    });
  });
}
