import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'SparkyComputerCubit',
    () {
      blocTest<SparkyComputerCubit, SparkyComputerState>(
        'onBallEntered emits dimmed',
        build: SparkyComputerCubit.new,
        act: (bloc) => bloc.onBallEntered(),
        expect: () => [SparkyComputerState.withBall],
      );

      blocTest<SparkyComputerCubit, SparkyComputerState>(
        'onBallTurboCharged emits lit',
        build: SparkyComputerCubit.new,
        act: (bloc) => bloc.onBallTurboCharged(),
        expect: () => [SparkyComputerState.withoutBall],
      );
    },
  );
}
