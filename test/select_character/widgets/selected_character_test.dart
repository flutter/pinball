// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CharacterThemeCubit characterThemeCubit;

  setUpAll(() async {
    Flame.images.prefix = '';
    await Flame.images.load(const DashTheme().animation.keyName);
  });

  setUp(() async {
    characterThemeCubit = MockCharacterThemeCubit();

    whenListen(
      characterThemeCubit,
      Stream.value(const CharacterThemeState.initial()),
      initialState: const CharacterThemeState.initial(),
    );
  });

  group('SelectedCharacter', () {
    testWidgets('loadAssets returns list of futures', (tester) async {
      expect(SelectedCharacter.loadAssets(), isList);
    });

    testWidgets('renders selected character', (tester) async {
      await tester.pumpApp(
        SelectedCharacter(),
        characterThemeCubit: characterThemeCubit,
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });
}
