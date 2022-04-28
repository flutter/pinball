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
      Assets.images.multiplier.x2.lit.keyName,
      Assets.images.multiplier.x2.dimmed.keyName,
      Assets.images.multiplier.x3.lit.keyName,
      Assets.images.multiplier.x3.dimmed.keyName,
      Assets.images.multiplier.x4.lit.keyName,
      Assets.images.multiplier.x4.dimmed.keyName,
      Assets.images.multiplier.x5.lit.keyName,
      Assets.images.multiplier.x5.dimmed.keyName,
      Assets.images.multiplier.x6.lit.keyName,
      Assets.images.multiplier.x6.dimmed.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    group('renders correctly', () {
      flameTester.testGameWidget(
        'x2 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final multiplier = Multiplier(
            value: MultiplierValue.x2,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);

          multiplier.toggle(2);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

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

          final multiplier = Multiplier(
            value: MultiplierValue.x2,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x2-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x2 deactivated when different multiply value',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x2,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          multiplier.toggle(1);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );
        },
      );

      flameTester.testGameWidget(
        'x3 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x3,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);

          multiplier.toggle(3);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

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

          final multiplier = Multiplier(
            value: MultiplierValue.x3,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x3-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x3 deactivated when different multiply value',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x3,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          multiplier.toggle(1);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );
        },
      );

      flameTester.testGameWidget(
        'x4 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x4,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);

          multiplier.toggle(4);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

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

          final multiplier = Multiplier(
            value: MultiplierValue.x4,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x4-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x4 deactivated when different multiply value',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x4,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          multiplier.toggle(1);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );
        },
      );

      flameTester.testGameWidget(
        'x5 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x5,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);

          multiplier.toggle(5);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

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

          final multiplier = Multiplier(
            value: MultiplierValue.x5,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x5-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x5 deactivated when different multiply value',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x5,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          multiplier.toggle(1);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );
        },
      );

      flameTester.testGameWidget(
        'x6 active',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x6,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);

          multiplier.toggle(6);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.active,
          );

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

          final multiplier = Multiplier(
            value: MultiplierValue.x6,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );

          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/multipliers/x6-inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'x6 deactivated when different multiply value',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);

          final multiplier = Multiplier(
            value: MultiplierValue.x6,
            position: Vector2.zero(),
          );
          await game.ensureAdd(multiplier);
          multiplier.toggle(1);
          await tester.pump();

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          expect(
            game
                .descendants()
                .whereType<MultiplierSpriteGroupComponent>()
                .first
                .current,
            MultiplierSpriteState.inactive,
          );
        },
      );
    });
  });
}
