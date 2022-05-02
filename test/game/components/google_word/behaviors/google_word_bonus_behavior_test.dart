// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/components/google_word/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.googleWord.letter1.lit.keyName,
    Assets.images.googleWord.letter1.dimmed.keyName,
    Assets.images.googleWord.letter2.lit.keyName,
    Assets.images.googleWord.letter2.dimmed.keyName,
    Assets.images.googleWord.letter3.lit.keyName,
    Assets.images.googleWord.letter3.dimmed.keyName,
    Assets.images.googleWord.letter4.lit.keyName,
    Assets.images.googleWord.letter4.dimmed.keyName,
    Assets.images.googleWord.letter5.lit.keyName,
    Assets.images.googleWord.letter5.dimmed.keyName,
    Assets.images.googleWord.letter6.lit.keyName,
    Assets.images.googleWord.letter6.dimmed.keyName,
  ];

  group('GoogleWordBonusBehaviors', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = MockGameBloc();
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
      'adds GameBonus.googleWord to the game when all letters are activated',
      setUp: (game, tester) async {
        final behavior = GoogleWordBonusBehavior();
        final parent = GoogleWord.test();
        final letters = [
          GoogleLetter(0),
          GoogleLetter(1),
          GoogleLetter(2),
          GoogleLetter(3),
          GoogleLetter(4),
          GoogleLetter(5),
        ];
        await parent.addAll(letters);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        for (final letter in letters) {
          letter.bloc.onBallContacted();
        }
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.googleWord)),
        ).called(1);
      },
    );
  });
}
