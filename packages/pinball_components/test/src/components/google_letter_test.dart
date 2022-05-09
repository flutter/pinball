// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
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

  Future<void> pump(GoogleLetter child) async {
    await ensureAdd(
      FlameBlocProvider<GoogleWordCubit, GoogleWordState>.value(
        value: GoogleWordCubit(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('Google Letter', () {
    test('can be instantiated', () {
      expect(GoogleLetter(0), isA<GoogleLetter>());
    });

    flameTester.test(
      '0th loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(0);
        await game.pump(googleLetter);

        expect(game.descendants().contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '1st loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(1);
        await game.pump(googleLetter);

        expect(game.descendants().contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '2nd loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(2);
        await game.pump(googleLetter);

        expect(game.descendants().contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '3d loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(3);
        await game.pump(googleLetter);

        expect(game.descendants().contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '4th loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(4);
        await game.pump(googleLetter);

        expect(game.descendants().contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '5th loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(5);
        await game.pump(googleLetter);

        expect(game.descendants().contains(googleLetter), isTrue);
      },
    );

    test('throws error when index out of range', () {
      expect(() => GoogleLetter(-1), throwsA(isA<RangeError>()));
      expect(() => GoogleLetter(6), throwsA(isA<RangeError>()));
    });

    group('sprite', () {
      const firstLetterLitState = GoogleWordState(
        letterSpriteStates: {
          0: GoogleLetterSpriteState.lit,
          1: GoogleLetterSpriteState.dimmed,
          2: GoogleLetterSpriteState.dimmed,
          3: GoogleLetterSpriteState.dimmed,
          4: GoogleLetterSpriteState.dimmed,
          5: GoogleLetterSpriteState.dimmed,
        },
      );

      flameTester.test(
        "listens when its index's state changes",
        (game) async {
          final googleLetter = GoogleLetter(0);
          await game.pump(googleLetter);

          expect(
            googleLetter.listenWhen(
              GoogleWordState.initial(),
              firstLetterLitState,
            ),
            isTrue,
          );
        },
      );

      flameTester.test(
        'changes current sprite onNewState',
        (game) async {
          final googleLetter = GoogleLetter(0);
          await game.pump(googleLetter);

          final originalSprite = googleLetter.current;

          googleLetter.onNewState(firstLetterLitState);
          await game.ready();

          final newSprite = googleLetter.current;
          expect(newSprite != originalSprite, isTrue);
        },
      );
    });
  });
}
