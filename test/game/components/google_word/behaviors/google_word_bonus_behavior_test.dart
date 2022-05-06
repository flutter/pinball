// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/google_word/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
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
    ]);
  }

  Future<void> pump(GoogleWord child, {required GameBloc gameBloc}) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [
          FlameProvider<PinballPlayer>.value(
            _MockPinballPlayer(),
            children: [child],
          )
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockPinballPlayer extends Mock implements PinballPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleWordBonusBehaviors', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'adds GameBonus.googleWord to the game when all letters are activated',
      setUp: (game, tester) async {
        await game.onLoad();
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
        await game.pump(parent, gameBloc: gameBloc);
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
