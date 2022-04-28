import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'AlienBumperCubit',
    () {
      blocTest<AlienBumperCubit, AlienBumperState>(
        'onBallContacted emits inactive',
        build: AlienBumperCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [AlienBumperState.inactive],
      );

      blocTest<AlienBumperCubit, AlienBumperState>(
        'onBlinked emits active',
        build: AlienBumperCubit.new,
        act: (bloc) => bloc.onBlinked(),
        expect: () => [AlienBumperState.active],
      );
    },
  );
}
