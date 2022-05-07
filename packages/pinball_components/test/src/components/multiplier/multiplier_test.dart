// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
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
    ]);
  }
}

class _MockMultiplierCubit extends Mock implements MultiplierCubit {}

void main() {
  group('Multiplier', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(_TestGame.new);
    late MultiplierCubit bloc;

    setUp(() {
      bloc = _MockMultiplierCubit();
    });

    flameTester.test('"x2" loads correctly', (game) async {
      final multiplier = Multiplier.x2(
        position: Vector2.zero(),
        angle: 0,
      );
      await game.ensureAdd(multiplier);
      expect(game.contains(multiplier), isTrue);
    });

    flameTester.test('"x3" loads correctly', (game) async {
      final multiplier = Multiplier.x3(
        position: Vector2.zero(),
        angle: 0,
      );
      await game.ensureAdd(multiplier);
      expect(game.contains(multiplier), isTrue);
    });

    flameTester.test('"x4" loads correctly', (game) async {
      final multiplier = Multiplier.x4(
        position: Vector2.zero(),
        angle: 0,
      );
      await game.ensureAdd(multiplier);
      expect(game.contains(multiplier), isTrue);
    });

    flameTester.test('"x5" loads correctly', (game) async {
      final multiplier = Multiplier.x5(
        position: Vector2.zero(),
        angle: 0,
      );
      await game.ensureAdd(multiplier);
      expect(game.contains(multiplier), isTrue);
    });

    flameTester.test('"x6" loads correctly', (game) async {
      final multiplier = Multiplier.x6(
        position: Vector2.zero(),
        angle: 0,
      );
      await game.ensureAdd(multiplier);
      expect(game.contains(multiplier), isTrue);
    });

    group('renders correctly', () {
      group('x2', () {
        const multiplierValue = MultiplierValue.x2;

        flameTester.testGameWidget(
          'lit when bloc state is lit',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.lit,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.lit,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x2_lit.png'),
            );
          },
        );

        flameTester.testGameWidget(
          'dimmed when bloc state is dimmed',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.dimmed,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.dimmed,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x2_dimmed.png'),
            );
          },
        );
      });

      group('x3', () {
        const multiplierValue = MultiplierValue.x3;

        flameTester.testGameWidget(
          'lit when bloc state is lit',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.lit,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.lit,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x3_lit.png'),
            );
          },
        );

        flameTester.testGameWidget(
          'dimmed when bloc state is dimmed',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.dimmed,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.dimmed,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x3_dimmed.png'),
            );
          },
        );
      });

      group('x4', () {
        const multiplierValue = MultiplierValue.x4;

        flameTester.testGameWidget(
          'lit when bloc state is lit',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.lit,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.lit,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x4_lit.png'),
            );
          },
        );

        flameTester.testGameWidget(
          'dimmed when bloc state is dimmed',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.dimmed,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.dimmed,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x4_dimmed.png'),
            );
          },
        );
      });

      group('x5', () {
        const multiplierValue = MultiplierValue.x5;

        flameTester.testGameWidget(
          'lit when bloc state is lit',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.lit,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.lit,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x5_lit.png'),
            );
          },
        );

        flameTester.testGameWidget(
          'dimmed when bloc state is dimmed',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.dimmed,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.dimmed,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x5_dimmed.png'),
            );
          },
        );
      });

      group('x6', () {
        const multiplierValue = MultiplierValue.x6;

        flameTester.testGameWidget(
          'lit when bloc state is lit',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.lit,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.lit,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x6_lit.png'),
            );
          },
        );

        flameTester.testGameWidget(
          'dimmed when bloc state is dimmed',
          setUp: (game, tester) async {
            await game.onLoad();

            whenListen(
              bloc,
              const Stream<MultiplierState>.empty(),
              initialState: MultiplierState(
                value: multiplierValue,
                spriteState: MultiplierSpriteState.dimmed,
              ),
            );

            final multiplier = Multiplier.test(
              value: multiplierValue,
              bloc: bloc,
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
              MultiplierSpriteState.dimmed,
            );

            await expectLater(
              find.byGame<_TestGame>(),
              matchesGoldenFile('../golden/multipliers/x6_dimmed.png'),
            );
          },
        );
      });
    });

    flameTester.test('closes bloc when removed', (game) async {
      whenListen(
        bloc,
        const Stream<MultiplierState>.empty(),
        initialState: MultiplierState(
          value: MultiplierValue.x2,
          spriteState: MultiplierSpriteState.dimmed,
        ),
      );
      when(bloc.close).thenAnswer((_) async {});
      final multiplier = Multiplier.test(value: MultiplierValue.x2, bloc: bloc);

      await game.ensureAdd(multiplier);
      game.remove(multiplier);
      await game.ready();

      verify(bloc.close).called(1);
    });
  });
}
