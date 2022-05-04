import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_theme/pinball_theme.dart';
import 'package:pinball_ui/pinball_ui.dart';

import '../../helpers/helpers.dart';

class _MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

class _MockStartGameBloc extends Mock implements StartGameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CharacterThemeCubit characterThemeCubit;
  late StartGameBloc startGameBloc;

  setUp(() async {
    await mockFlameImages();

    characterThemeCubit = _MockCharacterThemeCubit();
    startGameBloc = _MockStartGameBloc();

    whenListen(
      characterThemeCubit,
      const Stream<CharacterThemeState>.empty(),
      initialState: const CharacterThemeState.initial(),
    );
    when(() => characterThemeCubit.state)
        .thenReturn(const CharacterThemeState.initial());
  });

  group('CharacterSelectionDialog', () {
    testWidgets('selecting a new character calls characterSelected on cubit',
        (tester) async {
      await tester.pumpApp(
        const CharacterSelectionDialog(),
        characterThemeCubit: characterThemeCubit,
      );
      await tester.tap(find.byKey(const Key('sparky_character_selection')));
      await tester.pump();
      verify(
        () => characterThemeCubit.characterSelected(const SparkyTheme()),
      ).called(1);
    });

    testWidgets(
        'tapping the select button dismisses the character '
        'dialog and calls CharacterSelected event to the bloc', (tester) async {
      whenListen(
        startGameBloc,
        const Stream<StartGameState>.empty(),
        initialState: const StartGameState.initial(),
      );

      await tester.pumpApp(
        const CharacterSelectionDialog(),
        characterThemeCubit: characterThemeCubit,
        startGameBloc: startGameBloc,
      );
      await tester.tap(find.byType(PinballButton));
      await tester.pumpAndSettle();
      expect(find.byType(CharacterSelectionDialog), findsNothing);
      verify(() => startGameBloc.add(const CharacterSelected())).called(1);
    });

    testWidgets('updating the selected character updates the preview',
        (tester) async {
      await tester.pumpApp(_TestCharacterPreview());
      expect(find.text('Dash'), findsOneWidget);
      await tester.tap(find.text('test'));
      await tester.pump();
      expect(find.text('Android'), findsOneWidget);
    });
  });
}

class _TestCharacterPreview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestCharacterPreviewState();
}

class _TestCharacterPreviewState extends State<_TestCharacterPreview> {
  late CharacterTheme currentCharacter;

  @override
  void initState() {
    super.initState();
    currentCharacter = const DashTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: SelectedCharacter(currentCharacter: currentCharacter)),
        TextButton(
          onPressed: () {
            setState(() {
              currentCharacter = const AndroidTheme();
            });
          },
          child: const Text('test'),
        )
      ],
    );
  }
}
