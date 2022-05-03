import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group(
    'ChromeDinoCubit',
    () {
      final ball = Ball();

      blocTest<ChromeDinoCubit, ChromeDinoState>(
        'onOpenMouth emits true',
        build: ChromeDinoCubit.new,
        act: (bloc) => bloc.onOpenMouth(),
        expect: () => [
          isA<ChromeDinoState>().having(
            (state) => state.isMouthOpen,
            'isMouthOpen',
            true,
          )
        ],
      );

      blocTest<ChromeDinoCubit, ChromeDinoState>(
        'onCloseMouth emits false',
        build: ChromeDinoCubit.new,
        act: (bloc) => bloc.onCloseMouth(),
        expect: () => [
          isA<ChromeDinoState>().having(
            (state) => state.isMouthOpen,
            'isMouthOpen',
            false,
          )
        ],
      );

      blocTest<ChromeDinoCubit, ChromeDinoState>(
        'onChomp emits ChromeDinoStatus.chomping and chomped ball '
        'when the ball is not in the mouth',
        build: ChromeDinoCubit.new,
        act: (bloc) => bloc.onChomp(ball),
        expect: () => [
          isA<ChromeDinoState>()
            ..having(
              (state) => state.status,
              'status',
              ChromeDinoStatus.chomping,
            )
            ..having(
              (state) => state.ball,
              'ball',
              ball,
            )
        ],
      );

      blocTest<ChromeDinoCubit, ChromeDinoState>(
        'onChomp emits nothing when the ball is already in the mouth',
        build: ChromeDinoCubit.new,
        seed: () => const ChromeDinoState.inital().copyWith(ball: ball),
        act: (bloc) => bloc.onChomp(ball),
        expect: () => <ChromeDinoState>[],
      );

      blocTest<ChromeDinoCubit, ChromeDinoState>(
        'onSpit emits ChromeDinoStatus.idle and removes ball',
        build: ChromeDinoCubit.new,
        act: (bloc) => bloc.onSpit(),
        expect: () => [
          isA<ChromeDinoState>().having(
            (state) => state.status,
            'status',
            ChromeDinoStatus.idle,
          )..having(
              (state) => state.ball,
              'ball',
              null,
            )
        ],
      );
    },
  );
}
