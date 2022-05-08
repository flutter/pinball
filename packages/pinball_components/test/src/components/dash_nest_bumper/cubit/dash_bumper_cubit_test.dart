import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'DashBumperCubit',
    () {
      blocTest<DashBumperCubit, DashBumperState>(
        'onBallContacted emits active',
        build: DashBumperCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [DashBumperState.active],
      );

      blocTest<DashBumperCubit, DashBumperState>(
        'onReset emits inactive',
        build: DashBumperCubit.new,
        act: (bloc) => bloc.onReset(),
        expect: () => [DashBumperState.inactive],
      );
    },
  );
}
