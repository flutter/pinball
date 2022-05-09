// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_animatronic/behaviors/behaviors.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final asset = Assets.images.android.spaceship.animatronic.keyName;
  final flameTester = FlameTester(() => TestGame([asset]));

  group('AndroidAnimatronic', () {
    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.load(asset);
        await game.ensureAdd(AndroidAnimatronic());
        game.camera.followVector2(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        final animationDuration = game
            .firstChild<AndroidAnimatronic>()!
            .firstChild<SpriteAnimationComponent>()!
            .animation!
            .totalDuration();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/android_animatronic/start.png'),
        );

        game.update(animationDuration * 0.5);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/android_animatronic/middle.png'),
        );

        game.update(animationDuration * 0.5);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/android_animatronic/end.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final androidAnimatronic = AndroidAnimatronic();
        await game.ensureAdd(androidAnimatronic);
        expect(game.contains(androidAnimatronic), isTrue);
      },
    );

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final androidAnimatronic = AndroidAnimatronic(
          children: [component],
        );
        await game.ensureAdd(androidAnimatronic);
        expect(androidAnimatronic.children, contains(component));
      });

      flameTester.test('a AndroidAnimatronicBallContactBehavior', (game) async {
        final androidAnimatronic = AndroidAnimatronic();
        await game.ensureAdd(androidAnimatronic);
        expect(
          androidAnimatronic.children
              .whereType<AndroidAnimatronicBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });
  });
}
