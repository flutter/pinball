import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'GoogleWordCubit',
    () {
      final litEvens = {
        for (int i = 0; i < 6; i++)
          if (i.isEven)
            i: GoogleLetterSpriteState.lit
          else
            i: GoogleLetterSpriteState.dimmed
      };
      final litOdds = {
        for (int i = 0; i < 6; i++)
          if (i.isOdd)
            i: GoogleLetterSpriteState.lit
          else
            i: GoogleLetterSpriteState.dimmed
      };

      blocTest<GoogleWordCubit, GoogleWordState>(
        'onRolloverContacted emits first letter lit',
        build: GoogleWordCubit.new,
        act: (bloc) => bloc.onRolloverContacted(),
        expect: () => [
          const GoogleWordState(
            letterSpriteStates: {
              0: GoogleLetterSpriteState.lit,
              1: GoogleLetterSpriteState.dimmed,
              2: GoogleLetterSpriteState.dimmed,
              3: GoogleLetterSpriteState.dimmed,
              4: GoogleLetterSpriteState.dimmed,
              5: GoogleLetterSpriteState.dimmed,
            },
          ),
        ],
      );

      blocTest<GoogleWordCubit, GoogleWordState>(
        'switched emits all even letters lit when first letter is dimmed',
        build: GoogleWordCubit.new,
        act: (bloc) => bloc.switched(),
        expect: () => [GoogleWordState(letterSpriteStates: litEvens)],
      );

      blocTest<GoogleWordCubit, GoogleWordState>(
        'switched emits all odd letters lit when first letter is lit',
        build: GoogleWordCubit.new,
        seed: () => GoogleWordState(letterSpriteStates: litEvens),
        act: (bloc) => bloc.switched(),
        expect: () => [GoogleWordState(letterSpriteStates: litOdds)],
      );

      blocTest<GoogleWordCubit, GoogleWordState>(
        'onBonusAwarded emits all even letters lit',
        build: GoogleWordCubit.new,
        act: (bloc) => bloc.onBonusAwarded(),
        expect: () => [GoogleWordState(letterSpriteStates: litEvens)],
      );

      blocTest<GoogleWordCubit, GoogleWordState>(
        'onReset emits initial state',
        build: GoogleWordCubit.new,
        act: (bloc) => bloc.onReset(),
        expect: () => [GoogleWordState.initial()],
      );
    },
  );
}
