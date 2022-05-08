// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/google_gallery/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

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

  Future<void> pump(
    GoogleGallery child, {
    required GameBloc gameBloc,
    required GoogleWordCubit googleWordBloc,
  }) async {
    // Not needed once https://github.com/flame-engine/flame/issues/1607
    // is fixed
    await onLoad();
    await ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: gameBloc,
          ),
          FlameBlocProvider<GoogleWordCubit, GoogleWordState>.value(
            value: googleWordBloc,
          ),
        ],
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockGoogleWordCubit extends Mock implements GoogleWordCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleWordBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'adds GameBonus.googleWord to the game when all letters '
      'in google word are activated and calls onBonusAwarded',
      setUp: (game, tester) async {
        final behavior = GoogleWordBonusBehavior();
        final parent = GoogleGallery.test();
        final googleWord = GoogleWord(position: Vector2.zero());
        final googleWordBloc = _MockGoogleWordCubit();
        final streamController = StreamController<GoogleWordState>();

        whenListen(
          googleWordBloc,
          streamController.stream,
          initialState: GoogleWordState.initial(),
        );

        await parent.add(googleWord);
        await game.pump(
          parent,
          gameBloc: gameBloc,
          googleWordBloc: googleWordBloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(
          const GoogleWordState(
            letterSpriteStates: {
              0: GoogleLetterSpriteState.lit,
              1: GoogleLetterSpriteState.lit,
              2: GoogleLetterSpriteState.lit,
              3: GoogleLetterSpriteState.lit,
              4: GoogleLetterSpriteState.lit,
              5: GoogleLetterSpriteState.lit,
            },
          ),
        );
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.googleWord)),
        ).called(1);
        verify(googleWordBloc.onBonusAwarded).called(1);
      },
    );
  });
}
