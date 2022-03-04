import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('ThemeCubit', () {
    test('initial state has Dash theme', () {
      final themeCubit = ThemeCubit();
      expect(themeCubit.state.theme, equals(const DashTheme()));
    });

    blocTest<ThemeCubit, ThemeState>(
      'themeSelected emits selected theme',
      build: ThemeCubit.new,
      act: (bloc) => bloc.themeSelected(const SparkyTheme()),
      expect: () => [
        const ThemeState(SparkyTheme()),
      ],
    );
  });
}
