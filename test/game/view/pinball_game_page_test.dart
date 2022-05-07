// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/assets_manager/assets_manager.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/gen.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/more_information/more_information.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';

import '../../helpers/helpers.dart';

class _TestPinballGame extends PinballGame {
  _TestPinballGame()
      : super(
          characterThemeBloc: CharacterThemeCubit(),
          leaderboardRepository: _MockLeaderboardRepository(),
          gameBloc: GameBloc(),
          l10n: _MockAppLocalizations(),
          audioPlayer: _MockPinballAudioPlayer(),
        );

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    final futures = [
      ...preLoadAssets(),
      preFetchLeaderboard(),
    ];
    await Future.wait<void>(futures);

    return super.onLoad();
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

class _MockAssetsManagerCubit extends Mock implements AssetsManagerCubit {}

class _MockStartGameBloc extends Mock implements StartGameBloc {}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get leaderboardErrorMessage => '';
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

void main() {
  final game = _TestPinballGame();

  group('PinballGamePage', () {
    late CharacterThemeCubit characterThemeCubit;
    late GameBloc gameBloc;

    setUp(() async {
      await Future.wait<void>(game.preLoadAssets());
      characterThemeCubit = _MockCharacterThemeCubit();
      gameBloc = _MockGameBloc();

      whenListen(
        characterThemeCubit,
        const Stream<CharacterThemeState>.empty(),
        initialState: const CharacterThemeState.initial(),
      );

      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );
    });

    group('renders PinballGameView', () {
      testWidgets('with debug mode turned on', (tester) async {
        await tester.pumpApp(
          PinballGamePage(),
          characterThemeCubit: characterThemeCubit,
          gameBloc: gameBloc,
        );

        expect(find.byType(PinballGameView), findsOneWidget);
      });

      testWidgets('with debug mode turned off', (tester) async {
        await tester.pumpApp(
          PinballGamePage(isDebugMode: false),
          characterThemeCubit: characterThemeCubit,
          gameBloc: gameBloc,
        );

        expect(find.byType(PinballGameView), findsOneWidget);
      });
    });

    testWidgets(
      'renders the loading indicator while the assets load',
      (tester) async {
        final assetsManagerCubit = _MockAssetsManagerCubit();
        final initialAssetsState = AssetsManagerState(
          loadables: [Future<void>.value()],
          loaded: const [],
        );
        whenListen(
          assetsManagerCubit,
          Stream.value(initialAssetsState),
          initialState: initialAssetsState,
        );
        await tester.pumpApp(
          PinballGameView(game),
          assetsManagerCubit: assetsManagerCubit,
          characterThemeCubit: characterThemeCubit,
        );
        expect(find.byType(AssetsLoadingPage), findsOneWidget);
      },
    );

    testWidgets(
        'renders PinballGameLoadedView after resources have been loaded',
        (tester) async {
      final assetsManagerCubit = _MockAssetsManagerCubit();
      final startGameBloc = _MockStartGameBloc();

      final loadedAssetsState = AssetsManagerState(
        loadables: [Future<void>.value()],
        loaded: [Future<void>.value()],
      );
      whenListen(
        assetsManagerCubit,
        Stream.value(loadedAssetsState),
        initialState: loadedAssetsState,
      );
      whenListen(
        startGameBloc,
        Stream.value(StartGameState.initial()),
        initialState: StartGameState.initial(),
      );

      await tester.pumpApp(
        PinballGameView(game),
        assetsManagerCubit: assetsManagerCubit,
        characterThemeCubit: characterThemeCubit,
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      await tester.pump();

      expect(find.byType(PinballGameLoadedView), findsOneWidget);
    });
  });

  group('PinballGameView', () {
    final gameBloc = _MockGameBloc();
    final startGameBloc = _MockStartGameBloc();

    setUp(() async {
      await Future.wait<void>(game.preLoadAssets());

      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );

      whenListen(
        startGameBloc,
        Stream.value(StartGameState.initial()),
        initialState: StartGameState.initial(),
      );
    });

    testWidgets('renders game', (tester) async {
      await tester.pumpApp(
        PinballGameView(game),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      expect(
        find.byWidgetPredicate((w) => w is GameWidget<PinballGame>),
        findsOneWidget,
      );

      expect(
        find.byType(GameHud),
        findsNothing,
      );
    });

    testWidgets('renders a hud on play state', (tester) async {
      final startGameState = StartGameState.initial().copyWith(
        status: StartGameStatus.play,
      );

      whenListen(
        startGameBloc,
        Stream.value(startGameState),
        initialState: startGameState,
      );

      await tester.pumpApp(
        PinballGameView(game),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      expect(
        find.byType(GameHud),
        findsOneWidget,
      );
    });

    testWidgets('hide a hud on game over', (tester) async {
      final startGameState = StartGameState.initial().copyWith(
        status: StartGameStatus.play,
      );
      final gameState = GameState.initial().copyWith(
        status: GameStatus.gameOver,
      );
      whenListen(
        startGameBloc,
        Stream.value(startGameState),
        initialState: startGameState,
      );
      whenListen(
        gameBloc,
        Stream.value(gameState),
        initialState: gameState,
      );
      await tester.pumpApp(
        Material(child: PinballGameView(game)),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );
      expect(find.byType(GameHud), findsNothing);
    });

    testWidgets('keep focus on game when mouse hovers over it', (tester) async {
      final startGameState = StartGameState.initial().copyWith(
        status: StartGameStatus.play,
      );
      final gameState = GameState.initial().copyWith(
        status: GameStatus.gameOver,
      );
      whenListen(
        startGameBloc,
        Stream.value(startGameState),
        initialState: startGameState,
      );
      whenListen(
        gameBloc,
        Stream.value(gameState),
        initialState: gameState,
      );
      await tester.pumpApp(
        Material(child: PinballGameView(game)),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );
      game.focusNode.unfocus();
      await tester.pump();
      expect(game.focusNode.hasFocus, isFalse);
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo((game.size / 2).toOffset());
      await tester.pump();
      expect(game.focusNode.hasFocus, isTrue);
    });

    testWidgets('mobile controls when the overlay is added', (tester) async {
      await tester.pumpApp(
        PinballGameView(game),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      game.overlays.add(PinballGame.mobileControlsOverlay);

      await tester.pump();

      expect(find.byType(MobileControls), findsOneWidget);
    });

    group('info icon', () {
      testWidgets('renders on game over', (tester) async {
        final gameState = GameState.initial().copyWith(
          status: GameStatus.gameOver,
        );
        whenListen(
          gameBloc,
          Stream.value(gameState),
          initialState: gameState,
        );
        await tester.pumpApp(
          Material(child: PinballGameView(game)),
          gameBloc: gameBloc,
          startGameBloc: startGameBloc,
        );
        expect(find.image(Assets.images.linkBox.infoIcon), findsOneWidget);
      });

      testWidgets('opens MoreInformationDialog when tapped', (tester) async {
        final gameState = GameState.initial().copyWith(
          status: GameStatus.gameOver,
        );
        whenListen(
          gameBloc,
          Stream.value(gameState),
          initialState: gameState,
        );
        await tester.pumpApp(
          Material(child: PinballGameView(game)),
          gameBloc: gameBloc,
          startGameBloc: startGameBloc,
        );
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        expect(find.byType(MoreInformationDialog), findsOneWidget);
      });
    });
  });
}
