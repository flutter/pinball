// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

void main() {
  late CharacterThemeCubit characterThemeCubit;

  group('CharacterIcon', () {
    setUp(() {
      characterThemeCubit = MockCharacterThemeCubit();

      whenListen(
        characterThemeCubit,
        const Stream<CharacterThemeState>.empty(),
        initialState: const CharacterThemeState.initial(),
      );
    });

    testWidgets('renders character icon', (tester) async {
      const characterTheme = DashTheme();

      await tester.pumpApp(
        const CharacterIcon(characterTheme),
        characterThemeCubit: characterThemeCubit,
      );

      expect(find.image(characterTheme.icon), findsOneWidget);
    });

    testWidgets('tap on icon calls characterSelected on cubit', (tester) async {
      const characterTheme = DashTheme();

      await tester.pumpApp(
        CharacterIcon(characterTheme),
        characterThemeCubit: characterThemeCubit,
      );

      await tester.tap(find.byType(CharacterIcon));

      verify(
        () => characterThemeCubit.characterSelected(characterTheme),
      ).called(1);
    });
  });
}
