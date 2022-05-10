import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('PlungerCubit', () {
    test('can be instantiated', () {
      expect(PlungerCubit(), isA<PlungerCubit>());
    });

    blocTest<PlungerCubit, PlungerState>(
      'overrides previous pulling state',
      build: PlungerCubit.new,
      act: (cubit) => cubit
        ..pulled()
        ..autoPulled()
        ..pulled(),
      expect: () => [
        PlungerState.pulling,
        PlungerState.autoPulling,
        PlungerState.pulling,
      ],
    );
  });
}
