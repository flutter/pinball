// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final asset = Assets.images.dash.animatronic.keyName;
  final flameTester = FlameTester(() => TestGame([asset]));

  group('DashAnimatronic', () {
    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.load(asset);
        await game.world.ensureAdd(DashAnimatronic()..playing = true);
        game.camera.moveTo(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        final animationDuration = game
            .descendants()
            .whereType<DashAnimatronic>()
            .single
            .animationTicker!
            .totalDuration();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/dash_animatronic/start.png'),
        );

        game.update(animationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/dash_animatronic/middle.png'),
        );

        game.update(animationDuration * 0.75);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/dash_animatronic/end.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final dashAnimatronic = DashAnimatronic();
        await game.ensureAdd(dashAnimatronic);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<DashAnimatronic>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds new children',
      setUp: (game, _) async {
        await game.onLoad();
        final component = Component();
        final dashAnimatronic = DashAnimatronic(
          children: [component],
        );
        await game.ensureAdd(dashAnimatronic);
        await game.ready();
      },
      verify: (game, _) async {
        final dashAnimatronic =
            game.descendants().whereType<DashAnimatronic>().single;
        expect(dashAnimatronic.children.whereType<Component>(), isNotNull);
      },
    );
  });
}
