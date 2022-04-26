import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('SelectCharacterCubit', () {
    test('initial state has Dash character theme', () {
      final selectCharacterCubit = SelectCharacterCubit();
      expect(
        selectCharacterCubit.state.selectedCharacter,
        equals(const DashTheme()),
      );
    });

    blocTest<SelectCharacterCubit, SelectCharacterState>(
      'charcterSelected emits selected character theme',
      build: SelectCharacterCubit.new,
      act: (bloc) => bloc.characterSelected(const SparkyTheme()),
      expect: () => [
        const SelectCharacterState(SparkyTheme()),
      ],
    );
  });
}
