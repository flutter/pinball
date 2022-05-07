import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group(
    'BallCubit',
    () {
      blocTest<BallCubit, BallState>(
        'onThemeChanged emits new theme',
        build: BallCubit.new,
        act: (bloc) => bloc.onThemeChanged(const DinoTheme()),
        expect: () => [const BallState(characterTheme: DinoTheme())],
      );
    },
  );
}
