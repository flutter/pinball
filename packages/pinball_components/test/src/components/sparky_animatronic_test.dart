// ignore_for_file: cascade_invocations

import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('SparkyAnimatronic', () {
    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.ensureAdd(SparkyAnimatronic()..playing = true);
        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky_animatronic/start.png'),
        );

        game.update(1);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/sparky_animatronic/middle.png'),
        );

        game.update(1);
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
        sparkyAnimatronic.animation?.setToLast();
        game.update(1);

        expect(sparkyAnimatronic.playing, isFalse);
      },
    );
  });
}
