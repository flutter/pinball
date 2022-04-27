import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'GoogleLetterBumperCubit',
    () {
      blocTest<GoogleLetterCubit, GoogleLetterState>(
        'onBallContacted emits active',
        build: GoogleLetterCubit.new,
        act: (bloc) => bloc.onBallContacted(),
        expect: () => [GoogleLetterState.active],
      );

      blocTest<GoogleLetterCubit, GoogleLetterState>(
        'onReset emits inactive',
        build: GoogleLetterCubit.new,
        act: (bloc) => bloc.onReset(),
        expect: () => [GoogleLetterState.inactive],
      );
    },
  );
}