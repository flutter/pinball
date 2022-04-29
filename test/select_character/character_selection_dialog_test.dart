// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../helpers/helpers.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late CharacterThemeCubit characterThemeCubit;
  late StartGameBloc startGameBloc;

  setUpAll(() async {
    await Future.wait<void>(SelectedCharacter.loadAssets(MockBuildContext()));
    await Future.wait<void>(StarAnimation.loadAssets());
  });

  setUp(() {
    characterThemeCubit = MockCharacterThemeCubit();
    startGameBloc = MockStartGameBloc();

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
  });

  group('CharacterSelectionView', () {
    testWidgets('renders correctly', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpApp(
        CharacterSelectionView(),
        characterThemeCubit: characterThemeCubit,
      );

      expect(find.text(l10n.characterSelectionTitle), findsOneWidget);
      expect(find.text(l10n.characterSelectionSubtitle), findsOneWidget);
      expect(find.byType(SelectedCharacter), findsOneWidget);
      expect(find.byType(PinballButton), findsOneWidget);
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

    testWidgets('adds CharacterSelected event when start is tapped',
        (tester) async {
      whenListen(
        startGameBloc,
        Stream.value(const StartGameState.initial()),
        initialState: const StartGameState.initial(),
      );

      await tester.pumpApp(
        CharacterSelectionView(),
        characterThemeCubit: characterThemeCubit,
        startGameBloc: startGameBloc,
      );
      await tester.ensureVisible(find.byType(PinballButton));
      await tester.tap(find.byType(PinballButton));
      await tester.pumpAndSettle();

      verify(() => startGameBloc.add(CharacterSelected())).called(1);
    });
  });
}
