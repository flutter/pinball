// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/dino_desert/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll(
      [
        Assets.images.dino.animatronic.head.keyName,
        Assets.images.dino.animatronic.mouth.keyName,
        Assets.images.dino.topWall.keyName,
        Assets.images.dino.bottomWall.keyName,
        Assets.images.slingshot.upper.keyName,
        Assets.images.slingshot.lower.keyName,
      ],
    );
  }

  Future<void> pump(
    DinoDesert child, {
    required GameBloc gameBloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockBall extends Mock implements Ball {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChromeDinoBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'adds GameBonus.dinoChomp to the game '
      'when ChromeDinoStatus.chomping is emitted',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = ChromeDinoBonusBehavior();
        final parent = DinoDesert.test();
        final chromeDino = ChromeDino();

        await parent.add(chromeDino);
        await game.pump(
          parent,
          gameBloc: gameBloc,
        );
        await parent.ensureAdd(behavior);

        chromeDino.bloc.onChomp(_MockBall());
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.dinoChomp)),
        ).called(1);
      },
    );
  });
}
