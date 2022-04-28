// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'MultiplierCubit',
    () {
      blocTest<MultiplierCubit, MultiplierState>(
        'emits [lit] when toggle dimmed with same multiplier value',
        build: () => MultiplierCubit(MultiplierValue.x2),
        act: (bloc) => bloc.toggle(2),
        expect: () => [
          isA<MultiplierState>()
            ..having(
              (state) => state.spriteState,
              'spriteState',
              MultiplierSpriteState.lit,
            ),
        ],
      );

      blocTest<MultiplierCubit, MultiplierState>(
        'emits [dimmed] when toggle lit with different multiplier value',
        build: () => MultiplierCubit(MultiplierValue.x2),
        seed: () => MultiplierState(
          value: MultiplierValue.x2,
          spriteState: MultiplierSpriteState.lit,
        ),
        act: (bloc) => bloc.toggle(3),
        expect: () => [
          isA<MultiplierState>()
            ..having(
              (state) => state.spriteState,
              'spriteState',
              MultiplierSpriteState.dimmed,
            ),
        ],
      );

      blocTest<MultiplierCubit, MultiplierState>(
        'emits nothing when toggle lit with same multiplier value',
        build: () => MultiplierCubit(MultiplierValue.x2),
        seed: () => MultiplierState(
          value: MultiplierValue.x2,
          spriteState: MultiplierSpriteState.lit,
        ),
        act: (bloc) => bloc.toggle(2),
        expect: () => <MultiplierState>[],
      );

      blocTest<MultiplierCubit, MultiplierState>(
        'emits nothing when toggle dimmed with different multiplier value',
        build: () => MultiplierCubit(MultiplierValue.x2),
        act: (bloc) => bloc.toggle(3),
        expect: () => <MultiplierState>[],
      );
    },
  );
}
