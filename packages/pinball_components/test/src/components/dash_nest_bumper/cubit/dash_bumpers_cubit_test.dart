import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'DashBumperCubit',
    () {
      blocTest<DashBumpersCubit, DashBumpersState>(
        'onBallContacted emits active for contacted bumper',
        build: DashBumpersCubit.new,
        act: (bloc) => bloc.onBallContacted(DashBumperId.main),
        expect: () => [
          const DashBumpersState(
            bumperSpriteStates: {
              DashBumperId.main: DashBumperSpriteState.active,
              DashBumperId.a: DashBumperSpriteState.inactive,
              DashBumperId.b: DashBumperSpriteState.inactive,
            },
          ),
        ],
      );

      blocTest<DashBumpersCubit, DashBumpersState>(
        'onReset emits initial state',
        build: DashBumpersCubit.new,
        seed: () => DashBumpersState(
          bumperSpriteStates: {
            for (final id in DashBumperId.values)
              id: DashBumperSpriteState.active,
          },
        ),
        act: (bloc) => bloc.onReset(),
        expect: () => [DashBumpersState.initial()],
      );
    },
  );
}
