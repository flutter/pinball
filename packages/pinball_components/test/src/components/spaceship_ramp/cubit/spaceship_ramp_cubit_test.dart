// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('SpaceshipRampCubit', () {
    final ball = Ball(baseColor: Colors.red);

    group('onDoor', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits nothing if contains ball',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState.initial().copyWith(
          balls: {ball},
        ),
        act: (bloc) => bloc.onDoor(ball),
        expect: () => <SpaceshipRampState>[],
      );

      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits [{ball}, withoutBonus] if not contains ball',
        build: SpaceshipRampCubit.new,
        act: (bloc) => bloc.onDoor(ball),
        expect: () => [
          isA<SpaceshipRampState>()
            ..having(
              (state) => state.balls,
              'balls',
              contains(ball),
            )
            ..having(
              (state) => state.status,
              'status',
              SpaceshipRampStatus.withoutBonus,
            ),
        ],
      );
    });

    group('onInside', () {
      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits nothing if not contains ball',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState.initial().copyWith(
          balls: {},
        ),
        act: (bloc) => bloc.onInside(ball),
        expect: () => <SpaceshipRampState>[],
      );

      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits withoutBonus if contains ball '
        'and hits less than 10 times',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState.initial().copyWith(
          hits: 5,
          balls: {ball},
        ),
        act: (bloc) => bloc.onInside(ball),
        expect: () => [
          isA<SpaceshipRampState>()
            ..having((state) => state.hits, 'hits', 6)
            ..having((state) => state.balls, 'balls', isNot(contains(ball)))
            ..having((state) => state.shot, 'shot', true)
            ..having(
              (state) => state.status,
              'status',
              SpaceshipRampStatus.withoutBonus,
            ),
        ],
      );

      blocTest<SpaceshipRampCubit, SpaceshipRampState>(
        'emits withBonus if contains ball and hits 10 times',
        build: SpaceshipRampCubit.new,
        seed: () => SpaceshipRampState.initial().copyWith(
          hits: 9,
          balls: {ball},
        ),
        act: (bloc) => bloc.onInside(ball),
        expect: () => [
          isA<SpaceshipRampState>()
            ..having((state) => state.hits, 'hits', 10)
            ..having((state) => state.balls, 'balls', contains(ball))
            ..having((state) => state.shot, 'shot', false)
            ..having(
              (state) => state.status,
              'status',
              SpaceshipRampStatus.withBonus,
            ),
        ],
      );
    });
  });
}
