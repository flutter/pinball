// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.ramp.boardOpening.keyName,
    Assets.images.android.ramp.railingForeground.keyName,
    Assets.images.android.ramp.railingBackground.keyName,
    Assets.images.android.ramp.main.keyName,
    Assets.images.android.ramp.arrow.inactive.keyName,
    Assets.images.android.ramp.arrow.active1.keyName,
    Assets.images.android.ramp.arrow.active2.keyName,
    Assets.images.android.ramp.arrow.active3.keyName,
    Assets.images.android.ramp.arrow.active4.keyName,
    Assets.images.android.ramp.arrow.active5.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SpaceshipRamp', () {
    flameTester.test('loads correctly', (game) async {
      final component = SpaceshipRamp();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    group('renders correctly', () {
      const goldenFilePath = 'golden/spaceship_ramp/';
      final centerForSpaceshipRamp = Vector2(-13, -55);

      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final component = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [component]);
          await game.ensureAdd(canvas);

          await tester.pump();

          expect(
            component.children.whereType<SpriteGroupComponent>().first.current,
            SpaceshipRampArrowSpriteState.inactive,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final component = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [component]);
          await game.ensureAdd(canvas);

          component.progress();
          await tester.pump();

          expect(
            component.children.whereType<SpriteGroupComponent>().first.current,
            SpaceshipRampArrowSpriteState.active1,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final component = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [component]);
          await game.ensureAdd(canvas);

          component
            ..progress()
            ..progress();
          await tester.pump();

          expect(
            component.children.whereType<SpriteGroupComponent>().first.current,
            SpaceshipRampArrowSpriteState.active2,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final component = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [component]);
          await game.ensureAdd(canvas);

          component
            ..progress()
            ..progress()
            ..progress();
          await tester.pump();

          expect(
            component.children.whereType<SpriteGroupComponent>().first.current,
            SpaceshipRampArrowSpriteState.active3,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active3.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active4 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final component = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [component]);
          await game.ensureAdd(canvas);

          component
            ..progress()
            ..progress()
            ..progress()
            ..progress();
          await tester.pump();

          expect(
            component.children.whereType<SpriteGroupComponent>().first.current,
            SpaceshipRampArrowSpriteState.active4,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active4.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active5 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final component = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [component]);
          await game.ensureAdd(canvas);

          component
            ..progress()
            ..progress()
            ..progress()
            ..progress()
            ..progress();
          await tester.pump();

          expect(
            component.children.whereType<SpriteGroupComponent>().first.current,
            SpaceshipRampArrowSpriteState.active5,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active5.png'),
          );
        },
      );
    });
  });
}
