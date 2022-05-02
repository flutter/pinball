import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'AndroidSpaceshipCubit',
    () {
      blocTest<AndroidSpaceshipCubit, AndroidSpaceshipState>(
        'onEntered emits activated',
        build: AndroidSpaceshipCubit.new,
        act: (bloc) => bloc.onEntered(),
        expect: () => [AndroidSpaceshipState.activated],
      );

      blocTest<AndroidSpaceshipCubit, AndroidSpaceshipState>(
        'onBonusAwarded emits idle',
        build: AndroidSpaceshipCubit.new,
        act: (bloc) => bloc.onBonusAwarded(),
        expect: () => [AndroidSpaceshipState.idle],
      );
    },
  );
}
