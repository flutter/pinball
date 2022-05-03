// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/dino_desert/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _MockBall extends Mock implements Ball {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dino.animatronic.head.keyName,
    Assets.images.dino.animatronic.mouth.keyName,
    Assets.images.dino.topWall.keyName,
    Assets.images.dino.bottomWall.keyName,
    Assets.images.slingshot.upper.keyName,
    Assets.images.slingshot.lower.keyName,
  ];

  group('ChromeDinoBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
      assets: assets,
    );

    flameBlocTester.testGameWidget(
      'adds GameBonus.dinoChomp to the game '
      'when ChromeDinoStatus.chomping is emitted',
      setUp: (game, tester) async {
        final behavior = ChromeDinoBonusBehavior();
        final parent = DinoDesert.test();
        final chromeDino = ChromeDino();

        await parent.add(chromeDino);
        await game.ensureAdd(parent);
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
