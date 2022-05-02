import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('SignpostCubit', () {
    blocTest<SignpostCubit, SignpostState>(
      'onProgressed progresses',
      build: SignpostCubit.new,
      act: (bloc) {
        bloc
          ..onProgressed()
          ..onProgressed()
          ..onProgressed()
          ..onProgressed();
      },
      expect: () => [
        SignpostState.active1,
        SignpostState.active2,
        SignpostState.active3,
        SignpostState.inactive,
      ],
    );

    test('isFullyProgressed when on active3', () {
      final bloc = SignpostCubit();
      expect(bloc.isFullyProgressed(), isFalse);

      bloc.onProgressed();
      expect(bloc.isFullyProgressed(), isFalse);

      bloc.onProgressed();
      expect(bloc.isFullyProgressed(), isFalse);

      bloc.onProgressed();
      expect(bloc.isFullyProgressed(), isTrue);
    });
  });
}
