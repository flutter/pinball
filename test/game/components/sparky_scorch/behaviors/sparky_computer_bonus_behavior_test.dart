// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  Future<void> pump(
    SparkyScorch child, {
    required GameBloc gameBloc,
  }) async {
    // Not needed once https://github.com/flame-engine/flame/issues/1607
    // is fixed
    await onLoad();
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SparkyComputerBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'adds GameBonus.sparkyTurboCharge to the game and plays animatronic '
      'when SparkyComputerState.withBall is emitted',
      setUp: (game, tester) async {
        final behavior = SparkyComputerBonusBehavior();
        final parent = SparkyScorch.test();
        final sparkyComputer = SparkyComputer();
        final animatronic = SparkyAnimatronic();

        await parent.addAll([
          sparkyComputer,
          animatronic,
        ]);
        await game.pump(parent, gameBloc: gameBloc);
        await parent.ensureAdd(behavior);

        sparkyComputer.bloc.onBallEntered();
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.sparkyTurboCharge)),
        ).called(1);
        expect(animatronic.playing, isTrue);
      },
    );
  });
}
