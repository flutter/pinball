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

    flameTester.test(
      'loads correctly',
      (game) async {
        final bottomGroup = BottomGroup();
        await game.ensureAdd(
          FlameBlocProvider<GameBloc, GameState>.value(
            value: GameBloc(),
            children: [bottomGroup],
          ),
        );

        expect(game.descendants(), contains(bottomGroup));
      },
    );

    group('loads', () {
      flameTester.test(
        'one left flipper',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );

          final leftFlippers =
              bottomGroup.descendants().whereType<Flipper>().where(
                    (flipper) => flipper.side.isLeft,
                  );
          expect(leftFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'one right flipper',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );

          final rightFlippers =
              bottomGroup.descendants().whereType<Flipper>().where(
                    (flipper) => flipper.side.isRight,
                  );
          expect(rightFlippers.length, equals(1));
        },
      );

      flameTester.test(
        'two Baseboards',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );

          final basebottomGroups =
              bottomGroup.descendants().whereType<Baseboard>();
          expect(basebottomGroups.length, equals(2));
        },
      );

      flameTester.test(
        'two Kickers',
        (game) async {
          final bottomGroup = BottomGroup();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [bottomGroup],
            ),
          );

          final kickers = bottomGroup.descendants().whereType<Kicker>();
          expect(kickers.length, equals(2));
        },
      );
    });
  });
}
