import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/character_themes/character_themes.dart';

void main() {
  group('ThemeCubit', () {
    test('initial state has Dash theme', () {
      final themeCubit = ThemeCubit();
      expect(themeCubit.state.theme, equals(const DashTheme()));
    });

    group('themeSelected', () {
      blocTest<ThemeCubit, ThemeState>(
        'emits selected theme',
        build: ThemeCubit.new,
        act: (bloc) => bloc.themeSelected(const SparkyTheme()),
        expect: () => [
          const ThemeState(SparkyTheme()),
        ],
      );
    });
  });
}
