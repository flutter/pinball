import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'SparkyBumperCubit',
    () {
      blocTest<SparkyBumperCubit, SparkyBumperState>(
        'onBallContacted emits dimmed',
        build: SparkyBumperCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [SparkyBumperState.dimmed],
      );

      blocTest<SparkyBumperCubit, SparkyBumperState>(
        'onBlinked emits lit',
        build: SparkyBumperCubit.new,
        act: (bloc) => bloc.onBlinked(),
        expect: () => [SparkyBumperState.lit],
      );
    },
  );
}
