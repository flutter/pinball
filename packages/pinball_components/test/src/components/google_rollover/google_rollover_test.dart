// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_rollover/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.googleRollover.left.decal.keyName,
    Assets.images.googleRollover.left.pin.keyName,
    Assets.images.googleRollover.right.decal.keyName,
    Assets.images.googleRollover.right.pin.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('GoogleRollover', () {
    test('can be instantiated', () {
      expect(
        GoogleRollover(side: BoardSide.left),
        isA<GoogleRollover>(),
      );
    });

    flameTester.testGameWidget(
      'left loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final googleRollover = GoogleRollover(side: BoardSide.left);
        await game.ensureAdd(googleRollover);
        await game.ready();
      },
      verify: (game, _) async {
        final googleRollover =
            game.descendants().whereType<GoogleRollover>().single;
        expect(game.contains(googleRollover), isTrue);
      },
    );

    flameTester.testGameWidget(
      'right loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final googleRollover = GoogleRollover(side: BoardSide.right);
        await game.ensureAdd(googleRollover);
        await game.ready();
      },
      verify: (game, _) async {
        final googleRollover =
            game.descendants().whereType<GoogleRollover>().single;
        expect(game.contains(googleRollover), isTrue);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final googleRollover = GoogleRollover(
            side: BoardSide.left,
            children: [component],
          );
          await game.ensureAdd(googleRollover);
          await game.ready();
        },
        verify: (game, _) async {
          final googleRollover =
              game.descendants().whereType<GoogleRollover>().single;
          expect(googleRollover.children.whereType<Component>(), isNotNull);
        },
      );

      flameTester.testGameWidget(
        'a GoogleRolloverBallContactBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final googleRollover = GoogleRollover(side: BoardSide.left);
          await game.ensureAdd(googleRollover);
          await game.ready();
        },
        verify: (game, _) async {
          final googleRollover =
              game.descendants().whereType<GoogleRollover>().single;
          expect(
            googleRollover.children
                .whereType<GoogleRolloverBallContactBehavior>()
                .single,
            isNotNull,
          );
        },
      );
    });

    flameTester.testGameWidget(
      'pin stops animating after animation completes',
      setUp: (game, _) async {
        await game.onLoad();
        final googleRollover = GoogleRollover(side: BoardSide.left);
        await game.ensureAdd(googleRollover);
        await game.ready();
      },
      verify: (game, _) async {
        final googleRollover =
            game.descendants().whereType<GoogleRollover>().single;
        final pinSpriteAnimationComponent =
            googleRollover.firstChild<SpriteAnimationComponent>()!;

        pinSpriteAnimationComponent.playing = true;
        game.update(
          pinSpriteAnimationComponent.animationTicker!.totalDuration() + 0.1,
        );

        expect(pinSpriteAnimationComponent.playing, isFalse);
      },
    );
  });
}
