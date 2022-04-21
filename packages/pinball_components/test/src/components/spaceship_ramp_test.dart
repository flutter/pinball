// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.spaceship.ramp.main.keyName,
    Assets.images.spaceship.ramp.boardOpening.keyName,
    Assets.images.spaceship.ramp.railingBackground.keyName,
    Assets.images.spaceship.ramp.railingForeground.keyName,
    Assets.images.spaceship.ramp.arrow.inactive.keyName,
    Assets.images.spaceship.ramp.arrow.oneActive.keyName,
    Assets.images.spaceship.ramp.arrow.twoActive.keyName,
    Assets.images.spaceship.ramp.arrow.threeActive.keyName,
    Assets.images.spaceship.ramp.arrow.fourActive.keyName,
    Assets.images.spaceship.ramp.arrow.fiveActive.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SpaceshipRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final spaceshipRamp = SpaceshipRamp();
        await game.ensureAdd(spaceshipRamp);

        expect(game.contains(spaceshipRamp), isTrue);
      },
    );

    group('renders correctly', () {
      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();
          await tester.pump();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()!.current,
            SpaceshipRampArrowSpriteState.inactive,
          );

          game.camera.followVector2(Vector2(-13, -55));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();
          await tester.pump();

          spaceshipRamp.progress();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()!.current,
            SpaceshipRampArrowSpriteState.active1,
          );

          game.camera.followVector2(Vector2(-13, -55));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();
          await tester.pump();

          spaceshipRamp
            ..progress()
            ..progress();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()!.current,
            SpaceshipRampArrowSpriteState.active2,
          );

          game.camera.followVector2(Vector2(-13, -55));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();
          await tester.pump();

          spaceshipRamp
            ..progress()
            ..progress()
            ..progress();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()!.current,
            SpaceshipRampArrowSpriteState.active3,
          );

          game.camera.followVector2(Vector2(-13, -55));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/active3.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active4 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();
          await tester.pump();

          spaceshipRamp
            ..progress()
            ..progress()
            ..progress()
            ..progress();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()!.current,
            SpaceshipRampArrowSpriteState.active4,
          );

          game.camera.followVector2(Vector2(-13, -55));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/active4.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active5 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final spaceshipRamp = SpaceshipRamp();
          await game.addFromBlueprint(spaceshipRamp);
          await game.ready();
          await tester.pump();

          spaceshipRamp
            ..progress()
            ..progress()
            ..progress()
            ..progress()
            ..progress();

          expect(
            spaceshipRamp.firstChild<SpriteGroupComponent>()!.current,
            SpaceshipRampArrowSpriteState.active5,
          );

          game.camera.followVector2(Vector2(-13, -55));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship_ramp/active5.png'),
          );
        },
      );
    });
  });
}
