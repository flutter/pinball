// ignore_for_file: cascade_invocations

import 'package:flame/extensions.dart';
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
        await game.ensureAdd(DashAnimatronic()..playing = true);
        game.camera.followVector2(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        const animationDuration = 3.25;
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
    flameTester.test(
      'loads correctly',
      (game) async {
        final dashAnimatronic = DashAnimatronic();
        await game.ensureAdd(dashAnimatronic);

        expect(game.contains(dashAnimatronic), isTrue);
      },
    );

    flameTester.test(
      'stops animating after animation completes',
      (game) async {
        final dashAnimatronic = DashAnimatronic();
        await game.ensureAdd(dashAnimatronic);

        dashAnimatronic.playing = true;
        dashAnimatronic.animation?.setToLast();
        game.update(1);

        expect(dashAnimatronic.playing, isFalse);
      },
    );
  });
}
