import 'package:bloc_test/bloc_test.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../../helpers/helpers.dart';

class _MockPinballGame extends Mock implements PinballGame {}

class _MockGameFlowController extends Mock implements GameFlowController {}

class _MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

void main() {
  group('PlayButtonOverlay', () {
    late PinballGame game;
    late GameFlowController gameFlowController;
    late CharacterThemeCubit characterThemeCubit;

    setUp(() async {
      Flame.images.prefix = '';
      await Flame.images.load(const DashTheme().animation.keyName);
      await Flame.images.load(const AndroidTheme().animation.keyName);
      await Flame.images.load(const DinoTheme().animation.keyName);
      await Flame.images.load(const SparkyTheme().animation.keyName);
      game = _MockPinballGame();
      gameFlowController = _MockGameFlowController();
      characterThemeCubit = _MockCharacterThemeCubit();
      whenListen(
        characterThemeCubit,
        const Stream<CharacterThemeState>.empty(),
        initialState: const CharacterThemeState.initial(),
      );
      when(() => characterThemeCubit.state)
          .thenReturn(const CharacterThemeState.initial());
      when(() => game.gameFlowController).thenReturn(gameFlowController);
      when(gameFlowController.start).thenAnswer((_) {});
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(PlayButtonOverlay(game: game));
      expect(find.text('Play'), findsOneWidget);
    });

    testWidgets('calls gameFlowController.start when tapped', (tester) async {
      await tester.pumpApp(
        PlayButtonOverlay(game: game),
        characterThemeCubit: characterThemeCubit,
      );
      await tester.tap(find.text('Play'));
      await tester.pump();
      verify(gameFlowController.start).called(1);
    });

    testWidgets('displays CharacterSelectionDialog when tapped',
        (tester) async {
      await tester.pumpApp(
        PlayButtonOverlay(game: game),
        characterThemeCubit: characterThemeCubit,
      );
      await tester.tap(find.text('Play'));
      await tester.pump();
      expect(find.byType(CharacterSelectionDialog), findsOneWidget);
    });
  });
}
