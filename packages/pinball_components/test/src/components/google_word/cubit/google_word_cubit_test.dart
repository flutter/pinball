import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'GoogleWordCubit',
    () {
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
        'onBonusAwarded emits initial state',
        build: GoogleWordCubit.new,
        act: (bloc) => bloc.onBonusAwarded(),
        expect: () => [GoogleWordState.initial()],
      );
    },
  );
}
