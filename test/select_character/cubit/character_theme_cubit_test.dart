import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('CharacterThemeCubit', () {
    test('initial state has Dash character theme', () {
      final characterThemeCubit = CharacterThemeCubit();
      expect(
        characterThemeCubit.state.characterTheme,
        equals(const DashTheme()),
      );
    });

    blocTest<CharacterThemeCubit, CharacterThemeState>(
      'characterSelected emits selected character theme',
      build: CharacterThemeCubit.new,
      act: (bloc) => bloc.characterSelected(const SparkyTheme()),
      expect: () => [
        const CharacterThemeState(SparkyTheme()),
      ],
    );
  });
}
