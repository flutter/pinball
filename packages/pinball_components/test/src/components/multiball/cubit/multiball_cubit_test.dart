import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'MultiballCubit',
    () {
      blocTest<MultiballCubit, MultiballState>(
        'animate emits lit',
        build: MultiballCubit.new,
        act: (bloc) => bloc.animate(),
        expect: () => [MultiballState.lit],
      );

      blocTest<MultiballCubit, MultiballState>(
        'onBlinked emits dimmed',
        build: MultiballCubit.new,
        act: (bloc) => bloc.onBlinked(),
        expect: () => [MultiballState.dimmed],
      );
    },
  );
}
