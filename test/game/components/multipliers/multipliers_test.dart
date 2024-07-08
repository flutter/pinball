// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
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

  Future<void> pump(Multipliers child) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('Multipliers', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = Multipliers();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Multipliers>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'loads five Multiplier',
      setUp: (game, _) async {
        final multipliersGroup = Multipliers();
        await game.pump(multipliersGroup);
      },
      verify: (game, _) async {
        final multipliersGroup =
            game.descendants().whereType<Multipliers>().single;
        expect(
          multipliersGroup.descendants().whereType<Multiplier>().length,
          equals(5),
        );
      },
    );
  });
}
