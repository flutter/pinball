import 'package:bloc_test/bloc_test.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/how_to_play/how_to_play.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart';
import 'package:pinball_ui/pinball_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CharacterThemeCubit characterThemeCubit;

  setUp(() async {
    Flame.images.prefix = '';
    await Flame.images.load(const DashTheme().animation.keyName);
    await Flame.images.load(const AndroidTheme().animation.keyName);
    await Flame.images.load(const DinoTheme().animation.keyName);
    await Flame.images.load(const SparkyTheme().animation.keyName);
    characterThemeCubit = MockCharacterThemeCubit();
    whenListen(
      characterThemeCubit,
      const Stream<CharacterThemeState>.empty(),
      initialState: const CharacterThemeState.initial(),
    );
    when(() => characterThemeCubit.state)
        .thenReturn(const CharacterThemeState.initial());
  });

  group('CharacterSelectionDialog', () {
    group('showCharacterSelectionDialog', () {
      testWidgets('inflates the dialog', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => showCharacterSelectionDialog(context),
                child: const Text('test'),
              );
            },
          ),
          characterThemeCubit: characterThemeCubit,
        );
        await tester.tap(find.text('test'));
        await tester.pump();
        expect(find.byType(CharacterSelectionDialog), findsOneWidget);
      });
    });

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
        'dialog and shows the how to play dialog', (tester) async {
      await tester.pumpApp(
        const CharacterSelectionDialog(),
        characterThemeCubit: characterThemeCubit,
      );
      await tester.tap(find.byType(PinballButton));
      await tester.pumpAndSettle();
      expect(find.byType(CharacterSelectionDialog), findsNothing);
      expect(find.byType(HowToPlayDialog), findsOneWidget);
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
