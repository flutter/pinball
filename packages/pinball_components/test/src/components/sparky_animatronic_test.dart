// ignore_for_file: cascade_invocations

import 'package:flame/extensions.dart';
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
        await game.ensureAdd(SparkyAnimatronic()..playing = true);
        await tester.pump();

        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        final animationDuration =
            game.firstChild<SparkyAnimatronic>()!.animation!.totalDuration();

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

    flameTester.test(
      'loads correctly',
      (game) async {
        final sparkyAnimatronic = SparkyAnimatronic();
        await game.ensureAdd(sparkyAnimatronic);

        expect(game.contains(sparkyAnimatronic), isTrue);
      },
    );

    flameTester.test(
      'stops animating after animation completes',
      (game) async {
        final sparkyAnimatronic = SparkyAnimatronic();
        await game.ensureAdd(sparkyAnimatronic);

        sparkyAnimatronic.playing = true;
        final animationDuration =
            game.firstChild<SparkyAnimatronic>()!.animation!.totalDuration();
        game.update(animationDuration);

        expect(sparkyAnimatronic.playing, isFalse);
      },
    );
  });
}
