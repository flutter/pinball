// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.kicker.left.lit.keyName,
      Assets.images.kicker.left.dimmed.keyName,
      Assets.images.kicker.right.lit.keyName,
      Assets.images.kicker.right.dimmed.keyName,
      Assets.images.baseboard.left.keyName,
      Assets.images.baseboard.right.keyName,
      Assets.images.flipper.left.keyName,
      Assets.images.flipper.right.keyName,
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BottomGroup', () {
    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final bottomGroup = BottomGroup();
        await game.ensureAdd(
          FlameBlocProvider<GameBloc, GameState>.value(
            value: GameBloc(),
            children: [bottomGroup],
          ),
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<BottomGroup>().length, equals(1));
      },
    );

    group('loads', () {
      flameTester.testGameWidget(
        'one left flipper',
        setUp: (game, _) async {
          await game.onLoad();
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );
          await game.ready();
        },
        verify: (game, _) async {
          final leftFlippers = game
              .descendants()
              .whereType<BottomGroup>()
              .single
              .descendants()
              .whereType<Flipper>()
              .where(
                (flipper) => flipper.side.isLeft,
              );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.testGameWidget(
        'one right flipper',
        setUp: (game, _) async {
          await game.onLoad();
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );
          await game.ready();
        },
        verify: (game, _) async {
          final rightFlippers = game
              .descendants()
              .whereType<BottomGroup>()
              .single
              .descendants()
              .whereType<Flipper>()
              .where(
                (flipper) => flipper.side.isRight,
              );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.testGameWidget(
        'two Baseboards',
        setUp: (game, _) async {
          await game.onLoad();
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );
          await game.ready();
        },
        verify: (game, _) async {
          final bottomGroup =
              game.descendants().whereType<BottomGroup>().single;
          final baseBottomGroups =
              bottomGroup.descendants().whereType<Baseboard>();
          expect(baseBottomGroups.length, equals(2));
        },
      );

      flameTester.testGameWidget(
        'two Kickers',
        setUp: (game, _) async {
          await game.onLoad();
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );
          await game.ready();
        },
        verify: (game, _) async {
          final bottomGroup =
              game.descendants().whereType<BottomGroup>().single;
          final kickers = bottomGroup.descendants().whereType<Kicker>();
          expect(kickers.length, equals(2));
        },
      );
    });
  });
}
