// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'MultiplierCubit',
    () {
      blocTest<MultiplierCubit, MultiplierState>(
        "emits [lit] when 'next' on x2 dimmed with x2 multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x2),
        act: (bloc) => bloc.next(2),
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
        "emits [lit] when 'next' on x3 dimmed with x3 multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x3),
        act: (bloc) => bloc.next(3),
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
        "emits [lit] when 'next' on x4 dimmed with x4 multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x4),
        act: (bloc) => bloc.next(4),
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
        "emits [lit] when 'next' on x5 dimmed with x5 multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x5),
        act: (bloc) => bloc.next(5),
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
        "emits [lit] when 'next' on x6 dimmed with x6 multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x6),
        act: (bloc) => bloc.next(6),
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
        "emits [dimmed] when 'next' on lit with different multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x2),
        seed: () => MultiplierState(
          value: MultiplierValue.x2,
          spriteState: MultiplierSpriteState.lit,
        ),
        act: (bloc) => bloc.next(3),
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
        "emits nothing when 'next' on lit with same multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x2),
        seed: () => MultiplierState(
          value: MultiplierValue.x2,
          spriteState: MultiplierSpriteState.lit,
        ),
        act: (bloc) => bloc.next(2),
        expect: () => <MultiplierState>[],
      );

      blocTest<MultiplierCubit, MultiplierState>(
        "emits nothing when 'next' on dimmed with different multiplier value",
        build: () => MultiplierCubit(MultiplierValue.x2),
        act: (bloc) => bloc.next(3),
        expect: () => <MultiplierState>[],
      );
    },
  );
}
