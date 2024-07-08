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

    flameTester.testGameWidget(
      '0th loads correctly',
      setUp: (game, _) async {
        final googleLetter = GoogleLetter(0);
        await game.pump(googleLetter);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GoogleLetter>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '1st loads correctly',
      setUp: (game, _) async {
        final googleLetter = GoogleLetter(1);
        await game.pump(googleLetter);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GoogleLetter>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '2nd loads correctly',
      setUp: (game, _) async {
        final googleLetter = GoogleLetter(2);
        await game.pump(googleLetter);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GoogleLetter>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '3d loads correctly',
      setUp: (game, _) async {
        final googleLetter = GoogleLetter(3);
        await game.pump(googleLetter);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GoogleLetter>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '4th loads correctly',
      setUp: (game, _) async {
        final googleLetter = GoogleLetter(4);
        await game.pump(googleLetter);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GoogleLetter>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '5th loads correctly',
      setUp: (game, _) async {
        final googleLetter = GoogleLetter(5);
        await game.pump(googleLetter);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GoogleLetter>().length, equals(1));
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

      flameTester.testGameWidget(
        "listens when its index's state changes",
        setUp: (game, _) async {
          final googleLetter = GoogleLetter(0);
          await game.pump(googleLetter);
        },
        verify: (game, _) async {
          final googleLetter =
              game.descendants().whereType<GoogleLetter>().single;
          expect(
            googleLetter.listenWhen(
              GoogleWordState.initial(),
              firstLetterLitState,
            ),
            isTrue,
          );
        },
      );

      flameTester.testGameWidget(
        'changes current sprite onNewState',
        setUp: (game, _) async {
          final googleLetter = GoogleLetter(0);
          await game.pump(googleLetter);
        },
        verify: (game, _) async {
          final googleLetter =
              game.descendants().whereType<GoogleLetter>().single;

          final originalSprite = googleLetter.current;

          googleLetter.onNewState(firstLetterLitState);
          game.update(0);

          final newSprite = googleLetter.current;
          expect(newSprite, isNot(equals(originalSprite)));
        },
      );
    });
  });
}
