// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'SkillShotCubit',
    () {
      blocTest<SkillShotCubit, SkillShotState>(
        'onBallContacted emits lit and true',
        build: SkillShotCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [
          SkillShotState(
            spriteState: SkillShotSpriteState.lit,
            isBlinking: true,
          ),
        ],
      );

      blocTest<SkillShotCubit, SkillShotState>(
        'onBlinkedOff emits lit',
        build: SkillShotCubit.new,
        act: (bloc) => bloc.onBlinkedOff(),
        expect: () => [
          isA<SkillShotState>().having(
            (state) => state.spriteState,
            'spriteState',
            SkillShotSpriteState.lit,
          )
        ],
      );

      blocTest<SkillShotCubit, SkillShotState>(
        'onBlinkedOn emits dimmed',
        build: SkillShotCubit.new,
        act: (bloc) => bloc.onBlinkedOn(),
        expect: () => [
          isA<SkillShotState>().having(
            (state) => state.spriteState,
            'spriteState',
            SkillShotSpriteState.dimmed,
          )
        ],
      );

      blocTest<SkillShotCubit, SkillShotState>(
        'onBlinkingFinished emits dimmed and false',
        build: SkillShotCubit.new,
        act: (bloc) => bloc.onBlinkingFinished(),
        expect: () => [
          SkillShotState(
            spriteState: SkillShotSpriteState.dimmed,
            isBlinking: false,
          ),
        ],
      );
    },
  );
}
