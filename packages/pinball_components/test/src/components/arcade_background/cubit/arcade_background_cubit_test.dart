import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group(
    'ArcadeBackgroundCubit',
    () {
      blocTest<ArcadeBackgroundCubit, ArcadeBackgroundState>(
        'onCharacterSelected emits new theme',
        build: ArcadeBackgroundCubit.new,
        act: (bloc) => bloc.onCharacterSelected(const DinoTheme()),
        expect: () => [
          const ArcadeBackgroundState(
            characterTheme: DinoTheme(),
          ),
        ],
      );
    },
  );
}
