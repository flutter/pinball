import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'KickerCubit',
    () {
      blocTest<KickerCubit, KickerState>(
        'onBallContacted emits dimmed',
        build: KickerCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [KickerState.dimmed],
      );

      blocTest<KickerCubit, KickerState>(
        'onBlinked emits lit',
        build: KickerCubit.new,
        act: (bloc) => bloc.onBlinked(),
        expect: () => [KickerState.lit],
      );
    },
  );
}
