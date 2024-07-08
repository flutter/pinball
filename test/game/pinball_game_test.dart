// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/backbox/displays/displays.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_audio/src/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:share_repository/share_repository.dart';

class _TestPinballGame extends PinballGame {
  _TestPinballGame()
      : super(
          characterThemeBloc: CharacterThemeCubit(),
          leaderboardRepository: _MockLeaderboardRepository(),
          shareRepository: _MockShareRepository(),
          gameBloc: GameBloc(),
          l10n: _MockAppLocalizations(),
          audioPlayer: _MockPinballAudioPlayer(),
          platformHelper: _MockPlatformHelper(),
        );

  Future<void> preLoad() async {
    images.prefix = '';
    final futures = preLoadAssets().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futures);
  }
}

class _TestDebugPinballGame extends DebugPinballGame {
  _TestDebugPinballGame()
      : super(
          characterThemeBloc: CharacterThemeCubit(),
          leaderboardRepository: _MockLeaderboardRepository(),
          shareRepository: _MockShareRepository(),
          gameBloc: GameBloc(),
          l10n: _MockAppLocalizations(),
          audioPlayer: _MockPinballAudioPlayer(),
          platformHelper: _MockPlatformHelper(),
        );

  Future<void> preLoad() async {
    images.prefix = '';
    final futures = preLoadAssets().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futures);
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get leaderboardErrorMessage => '';

  @override
  String get rank => 'rank';

  @override
  String get score => 'score';

  @override
  String get name => 'name';
}

class _MockEventPosition extends Mock implements EventPosition {}

class _MockTapDownDetails extends Mock implements TapDownDetails {}

class _MockTapDownInfo extends Mock implements TapDownInfo {}

class _MockTapUpDetails extends Mock implements TapUpDetails {}

class _MockTapUpInfo extends Mock implements TapUpInfo {}

class _MockDragStartInfo extends Mock implements DragStartInfo {}

class _MockDragUpdateInfo extends Mock implements DragUpdateInfo {}

class _MockDragEndInfo extends Mock implements DragEndInfo {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockShareRepository extends Mock implements ShareRepository {}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockPlatformHelper extends Mock implements PlatformHelper {
  @override
  bool get isMobile => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameBloc gameBloc;

  setUp(() {
    gameBloc = _MockGameBloc();
    whenListen(
      gameBloc,
      const Stream<GameState>.empty(),
      initialState: const GameState.initial(),
    );
  });

  group('PinballGame', () {
    final flameTester = FlameTester(_TestPinballGame.new);

    group('components', () {
      flameTester.testGameWidget(
        'has only one BallSpawningBehavior',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<BallSpawningBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has only one CharacterSelectionBehavior',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<CharacterSelectionBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has only one Drain',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<Drain>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has only one BottomGroup',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<BottomGroup>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has only one Launcher',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<Launcher>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has one FlutterForest',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<FlutterForest>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'has only one Multiballs',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<Multiballs>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'one GoogleGallery',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<GoogleGallery>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'one SkillShot',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SkillShot>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'creates initial leaderboard if there are entries.',
        setUp: (game, _) async {
          final top10Scores = [
            2500,
            2200,
            2200,
            2000,
            1800,
            1400,
            1300,
            1000,
            600,
            300,
            100,
          ];
          final top10Leaderboard = top10Scores
              .map(
                (score) => LeaderboardEntryData(
                  playerInitials: 'user$score',
                  score: score,
                  character: CharacterType.dash,
                ),
              )
              .toList();
          when(game.leaderboardRepository.fetchTop10Leaderboard)
              .thenAnswer((_) async => top10Leaderboard);
          await game.preFetchLeaderboard();
          await game.preLoad();
          await game.onLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game
                .descendants()
                .whereType<LeaderboardDisplay>()
                .single
                .descendants()
                .whereType<TextComponent>()
                .length,
            equals(18),
          );
        },
      );

      flameTester.testGameWidget(
        'creates empty leaderboard if there is an error loading.',
        setUp: (game, _) async {
          when(game.leaderboardRepository.fetchTop10Leaderboard)
              .thenThrow(Exception());
          await game.preFetchLeaderboard();
          await game.preLoad();
          await game.onLoad();
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<LeaderboardDisplay>(),
            isEmpty,
          );
        },
      );
    });

    group('flipper control', () {
      flameTester.testGameWidget(
        'tap control only works if game is playing',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          final eventPosition = _MockEventPosition();
          when(() => eventPosition.global).thenReturn(Vector2.zero());
          when(() => eventPosition.widget).thenReturn(Vector2.zero());

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final tapDownEvent = _MockTapDownInfo();
          when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
          when(() => tapDownEvent.raw).thenReturn(raw);

          final flipperBloc = game
              .descendants()
              .whereType<Flipper>()
              .where((flipper) => flipper.side == BoardSide.left)
              .single
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.gameOver));

          game.onTapDown(0, tapDownEvent);
          game.update(0);
          expect(flipperBloc.state, FlipperState.movingDown);

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          game.onTapDown(0, tapDownEvent);
          game.update(0);
          expect(flipperBloc.state, FlipperState.movingUp);
        },
      );

      flameTester.testGameWidget(
        'tap down moves left flipper up',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          final eventPosition = _MockEventPosition();
          when(() => eventPosition.global).thenReturn(Vector2.zero());
          when(() => eventPosition.widget).thenReturn(Vector2.zero());

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final tapDownEvent = _MockTapDownInfo();
          when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
          when(() => tapDownEvent.raw).thenReturn(raw);

          game.onTapDown(0, tapDownEvent);
          game.update(0);

          final flipperBloc = game
              .descendants()
              .whereType<Flipper>()
              .where((flipper) => flipper.side == BoardSide.left)
              .single
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;
          expect(flipperBloc.state, FlipperState.movingUp);
        },
      );

      flameTester.testGameWidget(
        'tap down moves right flipper up',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          final eventPosition = _MockEventPosition();
          when(() => eventPosition.global).thenReturn(Vector2.zero());
          when(() => eventPosition.widget).thenReturn(game.canvasSize);

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final tapDownEvent = _MockTapDownInfo();
          when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
          when(() => tapDownEvent.raw).thenReturn(raw);

          game.onTapDown(0, tapDownEvent);
          final flipperBloc = game
              .descendants()
              .whereType<Flipper>()
              .where((flipper) => flipper.side == BoardSide.right)
              .single
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;

          game.update(0);
          expect(flipperBloc.state, FlipperState.movingUp);
        },
      );

      flameTester.testGameWidget(
        'tap up moves flipper down',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          final eventPosition = _MockEventPosition();
          when(() => eventPosition.global).thenReturn(Vector2.zero());
          when(() => eventPosition.widget).thenReturn(Vector2.zero());

          final tapUpEvent = _MockTapUpInfo();
          when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);

          game.onTapUp(0, tapUpEvent);
          game.update(0);

          final flipperBloc = game
              .descendants()
              .whereType<Flipper>()
              .where((flipper) => flipper.side == BoardSide.left)
              .single
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;
          expect(flipperBloc.state, FlipperState.movingDown);
        },
      );

      flameTester.testGameWidget(
        'tap cancel moves flipper down',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          final eventPosition = _MockEventPosition();
          when(() => eventPosition.global).thenReturn(Vector2.zero());
          when(() => eventPosition.widget).thenReturn(Vector2.zero());

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final tapDownEvent = _MockTapDownInfo();
          when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
          when(() => tapDownEvent.raw).thenReturn(raw);

          final flipperBloc = game
              .descendants()
              .whereType<Flipper>()
              .where((flipper) => flipper.side == BoardSide.left)
              .single
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;

          game.onTapDown(0, tapDownEvent);
          game.onTapCancel(0);
          expect(flipperBloc.state, FlipperState.movingDown);
        },
      );

      flameTester.testGameWidget(
        'multiple touches control both flippers',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final leftEventPosition = _MockEventPosition();
          when(() => leftEventPosition.global).thenReturn(Vector2.zero());
          when(() => leftEventPosition.widget).thenReturn(Vector2.zero());

          final rightEventPosition = _MockEventPosition();
          when(() => rightEventPosition.global).thenReturn(Vector2.zero());
          when(() => rightEventPosition.widget).thenReturn(game.canvasSize);

          final leftTapDownEvent = _MockTapDownInfo();
          when(() => leftTapDownEvent.eventPosition)
              .thenReturn(leftEventPosition);
          when(() => leftTapDownEvent.raw).thenReturn(raw);

          final rightTapDownEvent = _MockTapDownInfo();
          when(() => rightTapDownEvent.eventPosition)
              .thenReturn(rightEventPosition);
          when(() => rightTapDownEvent.raw).thenReturn(raw);

          game.onTapDown(0, leftTapDownEvent);
          game.onTapDown(1, rightTapDownEvent);

          final flippers = game.descendants().whereType<Flipper>();
          final rightFlipper = flippers.elementAt(0);
          final leftFlipper = flippers.elementAt(1);
          final leftFlipperBloc = leftFlipper
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;
          final rightFlipperBloc = rightFlipper
              .descendants()
              .whereType<FlameBlocProvider<FlipperCubit, FlipperState>>()
              .first
              .bloc;

          expect(leftFlipperBloc.state, equals(FlipperState.movingUp));
          expect(rightFlipperBloc.state, equals(FlipperState.movingUp));

          expect(
            game.focusedBoardSide,
            equals({0: BoardSide.left, 1: BoardSide.right}),
          );
        },
      );
    });

    group('plunger control', () {
      flameTester.testGameWidget(
        'plunger control tap down emits plunging',
        setUp: (game, _) async {
          await game.preLoad();
          await game.ready();
        },
        verify: (game, _) async {
          final gameBloc = game
              .descendants()
              .whereType<FlameBlocProvider<GameBloc, GameState>>()
              .first
              .bloc;

          gameBloc.emit(gameBloc.state.copyWith(status: GameStatus.playing));

          final eventPosition = _MockEventPosition();
          when(() => eventPosition.widget).thenReturn(
            game.worldToScreen(Vector2(40, 60)),
          );

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final tapDownEvent = _MockTapDownInfo();
          when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
          when(() => tapDownEvent.raw).thenReturn(raw);

          game.onTapDown(0, tapDownEvent);

          final plungerBloc = game
              .descendants()
              .whereType<FlameBlocProvider<PlungerCubit, PlungerState>>()
              .single
              .bloc;

          expect(plungerBloc.state, PlungerState.autoPulling);
        },
      );
    });
  });

  group('DebugPinballGame', () {
    final flameTester = FlameTester(_TestDebugPinballGame.new);

    flameTester.testGameWidget(
      'adds a ball on tap up',
      setUp: (game, _) async {
        await game.preLoad();
        await game.ready();
      },
      verify: (game, tester) async {
        final previousBalls = game.descendants().whereType<Ball>().toList();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.widget)
            .thenReturn(game.worldToScreen(Vector2.all(10)));

        final raw = _MockTapUpDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.mouse);

        final tapUpEvent = _MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapUpEvent.raw).thenReturn(raw);

        game.onTapUp(0, tapUpEvent);
        game.update(0);

        await tester.pump();

        final currentBalls = game.descendants().whereType<Ball>().toList();

        expect(
          currentBalls.length,
          equals(previousBalls.length + 1),
        );
      },
    );

    flameTester.testGameWidget(
      'set lineStart on pan start',
      setUp: (game, _) async {
        await game.preLoad();
        final eventPosition = _MockEventPosition();
        when(() => eventPosition.widget)
            .thenReturn(game.worldToScreen(Vector2.zero()));

        game.lineEnd = Vector2.all(10);

        final dragStartInfo = _MockDragStartInfo();
        when(() => dragStartInfo.eventPosition).thenReturn(eventPosition);

        game.onPanStart(dragStartInfo);
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.lineStart,
          equals(Vector2.zero()),
        );
      },
    );

    flameTester.testGameWidget(
      'set lineEnd on pan update',
      setUp: (game, _) async {
        await game.preLoad();
        await game.ready();
        final eventPosition = _MockEventPosition();
        when(() => eventPosition.widget)
            .thenReturn(game.worldToScreen(Vector2.all(10)));

        final dragUpdateInfo = _MockDragUpdateInfo();
        when(() => dragUpdateInfo.eventPosition).thenReturn(eventPosition);

        game.lineStart = Vector2.zero();

        game.onPanUpdate(dragUpdateInfo);
        game.update(0);
      },
      verify: (game, _) async {
        expect(
          game.lineEnd?.x,
          greaterThanOrEqualTo(9.999),
        );
        expect(
          game.lineEnd?.x,
          lessThanOrEqualTo(10.001),
        );
        expect(
          game.lineEnd?.y,
          greaterThanOrEqualTo(9.999),
        );
        expect(
          game.lineEnd?.y,
          lessThanOrEqualTo(10.001),
        );
      },
    );

    flameTester.testGameWidget(
      'launch ball on pan end',
      setUp: (game, _) async {
        await game.preLoad();
        final startPosition = Vector2.zero();
        final endPosition = Vector2.all(10);

        game.lineStart = startPosition;
        game.lineEnd = endPosition;

        await game.ready();
      },
      verify: (game, tester) async {
        final previousBalls = game.descendants().whereType<Ball>().toList();

        game.onPanEnd(_MockDragEndInfo());
        game.update(0);

        await tester.pump();

        expect(
          game.descendants().whereType<Ball>().length,
          equals(previousBalls.length + 1),
        );
      },
    );
  });
}
