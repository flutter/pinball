import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'DashNestBumperCubit',
    () {
      blocTest<DashNestBumperCubit, DashNestBumperState>(
        'onBallContacted emits active',
        build: DashNestBumperCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [DashNestBumperState.active],
      );

      blocTest<DashNestBumperCubit, DashNestBumperState>(
        'onReset emits inactive',
        build: DashNestBumperCubit.new,
        act: (bloc) => bloc.onReset(),
        expect: () => [DashNestBumperState.inactive],
      );
    },
  );
}
