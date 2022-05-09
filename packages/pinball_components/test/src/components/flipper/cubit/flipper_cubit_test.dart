import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('FlipperCubit', () {
    test('can be instantiated', () {
      expect(FlipperCubit(), isA<FlipperCubit>());
    });

    blocTest<FlipperCubit, FlipperState>(
      'moves',
      build: FlipperCubit.new,
      act: (cubit) => cubit
        ..moveUp()
        ..moveDown(),
      expect: () => [
        FlipperState.movingUp,
        FlipperState.movingDown,
      ],
    );
  });
}
