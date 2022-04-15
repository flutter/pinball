// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleWord', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameTester = FlameTester(EmptyPinballTestGame.new);
    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
    );

    flameTester.test(
      'loads the letters correctly',
      (game) async {
        const word = 'Google';
        final googleWord = GoogleWord(position: Vector2.zero());
        await game.ensureAdd(googleWord);

        final letters = googleWord.children.whereType<GoogleLetter>();
        expect(letters.length, equals(word.length));
      },
    );

    flameBlocTester.testGameWidget(
      'adds GameBonus.googleWord to the game when all letters are activated',
      setUp: (game, _) async {
        final ball = Ball(baseColor: const Color(0xFFFF0000));
        final googleWord = GoogleWord(position: Vector2.zero());
        await game.ensureAddAll([googleWord, ball]);

        final letters = googleWord.children.whereType<GoogleLetter>();
        expect(letters, isNotEmpty);
        for (final letter in letters) {
          beginContact(game, letter, ball);
          await game.ready();

          if (letter == letters.last) {
            verify(
              () => gameBloc.add(const BonusActivated(GameBonus.googleWord)),
            ).called(1);
          } else {
            verifyNever(
              () => gameBloc.add(const BonusActivated(GameBonus.googleWord)),
            );
          }
        }
      },
    );
  });
}
