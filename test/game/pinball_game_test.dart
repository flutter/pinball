// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/src/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
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

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    final futures = preLoadAssets().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futures);
    await super.onLoad();
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

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    final futures = preLoadAssets().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futures);
    await super.onLoad();
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get leaderboardErrorMessage => '';
}

class _MockEventPosition extends Mock implements EventPosition {}

class _MockTapDownDetails extends Mock implements TapDownDetails {}

class _MockTapDownInfo extends Mock implements TapDownInfo {}

class _MockTapUpDetails extends Mock implements TapUpDetails {}

class _MockTapUpInfo extends Mock implements TapUpInfo {}

class _MockDragStartInfo extends Mock implements DragStartInfo {}

class _MockDragUpdateInfo extends Mock implements DragUpdateInfo {}

class _MockDragEndInfo extends Mock implements DragEndInfo {}

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

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
      flameTester.test(
        'has only one BallSpawningBehavior',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<BallSpawningBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one CharacterSelectionBehavior',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<CharacterSelectionBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one Drain',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<Drain>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one BottomGroup',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<BottomGroup>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one Launcher',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<Launcher>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has one FlutterForest',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<FlutterForest>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'has only one Multiballs',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<Multiballs>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'one GoogleGallery',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<GoogleGallery>().length,
            equals(1),
          );
        },
      );

      flameTester.test('one SkillShot', (game) async {
        await game.ready();
        expect(
          game.descendants().whereType<SkillShot>().length,
          equals(1),
        );
      });

      flameTester.testGameWidget(
        'paints sprites with FilterQuality.medium',
        setUp: (game, tester) async {
          game.images.prefix = '';
          final futures =
              game.preLoadAssets().map((loadableBuilder) => loadableBuilder());
          await Future.wait<void>(futures);

          await game.ready();

          final descendants = game.descendants();
          final components = [
            ...descendants.whereType<SpriteComponent>(),
            ...descendants.whereType<SpriteGroupComponent>(),
          ];
          expect(components, isNotEmpty);
          expect(
            components.whereType<HasPaint>().length,
            equals(components.length),
          );

          await tester.pump();

          for (final component in components) {
            if (component is! HasPaint) return;
            expect(
              component.paint.filterQuality,
              equals(FilterQuality.medium),
            );
          }
        },
      );
    });

    group('flipper control', () {
      flameTester.test('tap down moves left flipper up', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
        when(() => eventPosition.widget).thenReturn(Vector2.zero());

        final raw = _MockTapDownDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

        final tapDownEvent = _MockTapDownInfo();
        when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapDownEvent.raw).thenReturn(raw);

        game.onTapDown(0, tapDownEvent);
        await Future<void>.delayed(Duration.zero);

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
      });

      flameTester.test('tap down moves right flipper up', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
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

        await Future<void>.delayed(Duration.zero);
        expect(flipperBloc.state, FlipperState.movingUp);
      });

      flameTester.test('tap up moves flipper down', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
        when(() => eventPosition.widget).thenReturn(Vector2.zero());

        final tapUpEvent = _MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);

        game.onTapUp(0, tapUpEvent);
        await game.ready();

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
      });

      flameTester.test('tap cancel moves flipper down', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
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
      });

      flameTester.test(
        'multiple touches control both flippers',
        (game) async {
          await game.ready();

          final raw = _MockTapDownDetails();
          when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

          final leftEventPosition = _MockEventPosition();
          when(() => leftEventPosition.game).thenReturn(Vector2.zero());
          when(() => leftEventPosition.widget).thenReturn(Vector2.zero());

          final rightEventPosition = _MockEventPosition();
          when(() => rightEventPosition.game).thenReturn(Vector2.zero());
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
      flameTester.test('plunger control tap down emits plunging', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2(40, 60));

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

        expect(plungerBloc.state, PlungerState.pulling);
      });
    });
  });

  group('DebugPinballGame', () {
    final flameTester = FlameTester(_TestDebugPinballGame.new);

    flameTester.test(
      'adds a ball on tap up',
      (game) async {
        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.all(10));

        final raw = _MockTapUpDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.mouse);

        final tapUpEvent = _MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapUpEvent.raw).thenReturn(raw);

        await game.ready();
        final previousBalls = game.descendants().whereType<Ball>().toList();

        game.onTapUp(0, tapUpEvent);
        await game.ready();

        final currentBalls = game.descendants().whereType<Ball>().toList();

        expect(
          currentBalls.length,
          equals(previousBalls.length + 1),
        );
      },
    );

    flameTester.test(
      'set lineStart on pan start',
      (game) async {
        final startPosition = Vector2.all(10);
        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(startPosition);

        final dragStartInfo = _MockDragStartInfo();
        when(() => dragStartInfo.eventPosition).thenReturn(eventPosition);

        game.onPanStart(dragStartInfo);
        await game.ready();

        expect(
          game.lineStart,
          equals(startPosition),
        );
      },
    );

    flameTester.test(
      'set lineEnd on pan update',
      (game) async {
        final endPosition = Vector2.all(10);
        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(endPosition);

        final dragUpdateInfo = _MockDragUpdateInfo();
        when(() => dragUpdateInfo.eventPosition).thenReturn(eventPosition);

        game.onPanUpdate(dragUpdateInfo);
        await game.ready();

        expect(
          game.lineEnd,
          equals(endPosition),
        );
      },
    );

    flameTester.test(
      'launch ball on pan end',
      (game) async {
        final startPosition = Vector2.zero();
        final endPosition = Vector2.all(10);

        game.lineStart = startPosition;
        game.lineEnd = endPosition;

        await game.ready();
        final previousBalls = game.descendants().whereType<Ball>().toList();

        game.onPanEnd(_MockDragEndInfo());
        await game.ready();

        expect(
          game.descendants().whereType<Ball>().length,
          equals(previousBalls.length + 1),
        );
      },
    );
  });
}
