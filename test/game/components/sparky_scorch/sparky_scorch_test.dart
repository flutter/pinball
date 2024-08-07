// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/sparky_scorch/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.sparky.computer.top.keyName,
      Assets.images.sparky.computer.base.keyName,
      Assets.images.sparky.computer.glow.keyName,
      Assets.images.sparky.animatronic.keyName,
      Assets.images.sparky.bumper.a.lit.keyName,
      Assets.images.sparky.bumper.a.dimmed.keyName,
      Assets.images.sparky.bumper.b.lit.keyName,
      Assets.images.sparky.bumper.b.dimmed.keyName,
      Assets.images.sparky.bumper.c.lit.keyName,
      Assets.images.sparky.bumper.c.dimmed.keyName,
    ]);
  }

  Future<void> pump(SparkyScorch child) async {
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

  group('SparkyScorch', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = SparkyScorch();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<SparkyScorch>().length,
          equals(1),
        );
      },
    );

    group('loads', () {
      flameTester.testGameWidget(
        'a SparkyComputer',
        setUp: (game, _) async {
          await game.pump(SparkyScorch());
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SparkyComputer>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'a SparkyAnimatronic',
        setUp: (game, _) async {
          await game.pump(SparkyScorch());
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SparkyAnimatronic>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'three SparkyBumper',
        setUp: (game, _) async {
          await game.pump(SparkyScorch());
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SparkyBumper>().length,
            equals(3),
          );
        },
      );

      flameTester.testGameWidget(
        'three SparkyBumpers with BumperNoiseBehavior',
        setUp: (game, _) async {
          await game.pump(SparkyScorch());
        },
        verify: (game, _) async {
          final bumpers = game.descendants().whereType<SparkyBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isNotNull,
            );
          }
        },
      );
    });

    group('adds', () {
      flameTester.testGameWidget(
        'ScoringContactBehavior to SparkyComputer',
        setUp: (game, _) async {
          await game.pump(SparkyScorch());
        },
        verify: (game, _) async {
          final sparkyComputer =
              game.descendants().whereType<SparkyComputer>().single;
          expect(
            sparkyComputer.firstChild<ScoringContactBehavior>(),
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a SparkyComputerBonusBehavior',
        setUp: (game, _) async {
          final sparkyScorch = SparkyScorch();
          await game.pump(sparkyScorch);
        },
        verify: (game, _) async {
          final sparkyScorch =
              game.descendants().whereType<SparkyScorch>().single;
          expect(
            sparkyScorch.children
                .whereType<SparkyComputerBonusBehavior>()
                .single,
            isNotNull,
          );
        },
      );
    });
  });
}
