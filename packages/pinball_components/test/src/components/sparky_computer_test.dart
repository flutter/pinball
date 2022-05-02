// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SparkyComputer', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.sparky.computer.base.keyName,
      Assets.images.sparky.computer.top.keyName,
      Assets.images.sparky.computer.glow.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.test('loads correctly', (game) async {
      final component = SparkyComputer();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(SparkyComputer());
        await tester.pump();

        game.camera
          ..followVector2(Vector2(0, -20))
          ..zoom = 7;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky-computer.png'),
        );
      },
    );
  });
}
