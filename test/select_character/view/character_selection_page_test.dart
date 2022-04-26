// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

void main() {
  late CharacterThemeCubit characterThemeCubit;

  setUp(() {
    characterThemeCubit = MockCharacterThemeCubit();
    whenListen(
      characterThemeCubit,
      const Stream<CharacterThemeState>.empty(),
      initialState: const CharacterThemeState.initial(),
    );
  });

  group('CharacterSelectionPage', () {
    testWidgets('renders CharacterSelectionView', (tester) async {
      await tester.pumpApp(
        CharacterSelectionDialog(),
        characterThemeCubit: characterThemeCubit,
      );
      expect(find.byType(CharacterSelectionView), findsOneWidget);
    });

    testWidgets('route returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(CharacterSelectionDialog.route());
                },
                child: Text('Tap me'),
              );
            },
          ),
        ),
        characterThemeCubit: characterThemeCubit,
      );

      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(find.byType(CharacterSelectionDialog), findsOneWidget);
    });
  });

  group('CharacterSelectionView', () {
    testWidgets('renders correctly', (tester) async {
      const titleText = 'Choose your character!';
      await tester.pumpApp(
        CharacterSelectionView(),
        characterThemeCubit: characterThemeCubit,
      );

      expect(find.text(titleText), findsOneWidget);
      expect(find.byType(CharacterImageButton), findsNWidgets(4));
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('calls characterSelected when a character image is tapped',
        (tester) async {
      const sparkyButtonKey = Key('characterSelectionPage_sparkyButton');

      await tester.pumpApp(
        CharacterSelectionView(),
        characterThemeCubit: characterThemeCubit,
      );

      await tester.tap(find.byKey(sparkyButtonKey));

      verify(() => characterThemeCubit.characterSelected(SparkyTheme()))
          .called(1);
    });

    testWidgets('displays how to play dialog when start is tapped',
        (tester) async {
      await tester.pumpApp(
        CharacterSelectionView(),
        characterThemeCubit: characterThemeCubit,
      );
      await tester.ensureVisible(find.byType(TextButton));
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(HowToPlayDialog), findsOneWidget);
    });
  });

  testWidgets('CharacterImageButton renders correctly', (tester) async {
    await tester.pumpApp(
      CharacterImageButton(DashTheme()),
      characterThemeCubit: characterThemeCubit,
    );

    expect(find.byType(Image), findsOneWidget);
  });
}
