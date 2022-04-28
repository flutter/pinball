import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'AndroidBumperCubit',
    () {
      blocTest<AndroidBumperCubit, AndroidBumperState>(
        'onBallContacted emits dimmed',
        build: AndroidBumperCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [AndroidBumperState.dimmed],
      );

      blocTest<AndroidBumperCubit, AndroidBumperState>(
        'onBlinked emits lit',
        build: AndroidBumperCubit.new,
        act: (bloc) => bloc.onBlinked(),
        expect: () => [AndroidBumperState.lit],
      );
    },
  );
}
