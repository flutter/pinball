import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'AndroidSpaceshipCubit',
    () {
      blocTest<AndroidSpaceshipCubit, AndroidSpaceshipState>(
        'onBallEntered emits withBonus',
        build: AndroidSpaceshipCubit.new,
        act: (bloc) => bloc.onBallEntered(),
        expect: () => [AndroidSpaceshipState.withBonus],
      );

      blocTest<AndroidSpaceshipCubit, AndroidSpaceshipState>(
        'onBonusAwarded emits withoutBonus',
        build: AndroidSpaceshipCubit.new,
        act: (bloc) => bloc.onBonusAwarded(),
        expect: () => [AndroidSpaceshipState.withoutBonus],
      );
    },
  );
}
