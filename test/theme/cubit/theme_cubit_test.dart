import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('ThemeCubit', () {
    test('initial state has Dash character theme', () {
      final themeCubit = ThemeCubit();
      expect(themeCubit.state.theme.characterTheme, equals(const DashTheme()));
    });

    blocTest<ThemeCubit, ThemeState>(
      'charcterSelected emits selected character theme',
      build: ThemeCubit.new,
      act: (bloc) => bloc.characterSelected(const SparkyTheme()),
      expect: () => [
        const ThemeState(PinballTheme(characterTheme: SparkyTheme())),
      ],
    );
  });
}
