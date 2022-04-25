// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('MultiplierSpriteGroupComponent', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.multiplier.x2.active.keyName,
      Assets.images.multiplier.x2.inactive.keyName,
      Assets.images.multiplier.x3.active.keyName,
      Assets.images.multiplier.x3.inactive.keyName,
      Assets.images.multiplier.x4.active.keyName,
      Assets.images.multiplier.x4.inactive.keyName,
      Assets.images.multiplier.x5.active.keyName,
      Assets.images.multiplier.x5.inactive.keyName,
      Assets.images.multiplier.x6.active.keyName,
      Assets.images.multiplier.x6.inactive.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    group('renders correctly', () {
      flameTester.testGameWidget(
        'x2 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final multiplier = MultiplierSpriteGroupComponent(
            position: Vector2.zero(),
            onAssetPath: Assets.images.multiplier.x2.active.keyName,
            offAssetPath: Assets.images.multiplier.x2.inactive.keyName,
          );
          await game.ensureAdd(multiplier);

          multiplier.current = MultiplierSpriteState.active;
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x2-active.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x2 inactive',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            MultiplierSpriteGroupComponent(
              position: Vector2.zero(),
              onAssetPath: Assets.images.multiplier.x2.active.keyName,
              offAssetPath: Assets.images.multiplier.x2.inactive.keyName,
            ),
          );
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x2-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x3 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final multiplier = MultiplierSpriteGroupComponent(
            position: Vector2.zero(),
            onAssetPath: Assets.images.multiplier.x3.active.keyName,
            offAssetPath: Assets.images.multiplier.x3.inactive.keyName,
          );
          await game.ensureAdd(multiplier);

          multiplier.current = MultiplierSpriteState.active;
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x3-active.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x3 inactive',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            MultiplierSpriteGroupComponent(
              position: Vector2.zero(),
              onAssetPath: Assets.images.multiplier.x3.active.keyName,
              offAssetPath: Assets.images.multiplier.x3.inactive.keyName,
            ),
          );
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x3-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x4 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final multiplier = MultiplierSpriteGroupComponent(
            position: Vector2.zero(),
            onAssetPath: Assets.images.multiplier.x4.active.keyName,
            offAssetPath: Assets.images.multiplier.x4.inactive.keyName,
          );
          await game.ensureAdd(multiplier);

          multiplier.current = MultiplierSpriteState.active;
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x4-active.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x4 inactive',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            MultiplierSpriteGroupComponent(
              position: Vector2.zero(),
              onAssetPath: Assets.images.multiplier.x4.active.keyName,
              offAssetPath: Assets.images.multiplier.x4.inactive.keyName,
            ),
          );
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x4-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x5 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final multiplier = MultiplierSpriteGroupComponent(
            position: Vector2.zero(),
            onAssetPath: Assets.images.multiplier.x5.active.keyName,
            offAssetPath: Assets.images.multiplier.x5.inactive.keyName,
          );
          await game.ensureAdd(multiplier);

          multiplier.current = MultiplierSpriteState.active;
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x5-active.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x5 inactive',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            MultiplierSpriteGroupComponent(
              position: Vector2.zero(),
              onAssetPath: Assets.images.multiplier.x5.active.keyName,
              offAssetPath: Assets.images.multiplier.x5.inactive.keyName,
            ),
          );
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x5-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x6 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final multiplier = MultiplierSpriteGroupComponent(
            position: Vector2.zero(),
            onAssetPath: Assets.images.multiplier.x6.active.keyName,
            offAssetPath: Assets.images.multiplier.x6.inactive.keyName,
          );
          await game.ensureAdd(multiplier);

          multiplier.current = MultiplierSpriteState.active;
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x6-active.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x6 inactive',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            MultiplierSpriteGroupComponent(
              position: Vector2.zero(),
              onAssetPath: Assets.images.multiplier.x6.active.keyName,
              offAssetPath: Assets.images.multiplier.x6.inactive.keyName,
            ),
          );
          await tester.pump();

          expect(
            game.children
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x6-inactive.png'),
          );
        },
      );
    });
  });
}
