// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SparkyAnimatronic', () {
    final asset = Assets.images.sparky.animatronic.keyName;
    final flameTester = FlameTester(() => TestGame([asset]));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.load(asset);
        await game.world.ensureAdd(SparkyAnimatronic()..playing = true);
        await tester.pump();

        game.camera.moveTo(Vector2.zero());
        await game.ready();
      },
      verify: (game, tester) async {
        final animationDuration = game
            .descendants()
            .whereType<SparkyAnimatronic>()
            .single
            .animationTicker!
            .totalDuration();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky_animatronic/start.png'),
        );

        game.update(animationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky_animatronic/middle.png'),
        );

        game.update(animationDuration * 0.75);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky_animatronic/end.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.images.load(asset);
        final sparkyAnimatronic = SparkyAnimatronic();
        await game.ensureAdd(sparkyAnimatronic);
      },
      verify: (game, _) async {
        final sparkyAnimatronic =
            game.descendants().whereType<SparkyAnimatronic>().single;
        expect(game.contains(sparkyAnimatronic), isTrue);
      },
    );

    flameTester.testGameWidget(
      'adds new children',
      setUp: (game, _) async {
        await game.onLoad();
        final component = Component();
        final sparkyAnimatronic = SparkyAnimatronic(
          children: [component],
        );
        await game.ensureAdd(sparkyAnimatronic);
        await game.ready();
      },
      verify: (game, _) async {
        final sparkyAnimatronic =
            game.descendants().whereType<SparkyAnimatronic>().single;
        expect(sparkyAnimatronic.children.whereType<Component>(), isNotEmpty);
      },
    );
  });
}
