import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:share_repository/share_repository.dart';

class PinballGame extends PinballForge2DGame
    with HasKeyboardHandlerComponents, MultiTouchTapDetector, HasTappables {
  PinballGame({
    required CharacterThemeCubit characterThemeBloc,
    required this.leaderboardRepository,
    required this.shareRepository,
    required GameBloc gameBloc,
    required AppLocalizations l10n,
    required PinballAudioPlayer audioPlayer,
    required this.platformHelper,
  })  : focusNode = FocusNode(),
        _gameBloc = gameBloc,
        _audioPlayer = audioPlayer,
        _characterThemeBloc = characterThemeBloc,
        _l10n = l10n,
        super(
          gravity: Vector2(0, 30),
        ) {
    images.prefix = '';
  }

  /// Identifier of the play button overlay
  static const playButtonOverlay = 'play_button';

  /// Identifier of the mobile controls overlay
  static const mobileControlsOverlay = 'mobile_controls';

  @override
  Color backgroundColor() => Colors.transparent;

  final FocusNode focusNode;

  final CharacterThemeCubit _characterThemeBloc;

  final PinballAudioPlayer _audioPlayer;

  final LeaderboardRepository leaderboardRepository;

  final ShareRepository shareRepository;

  final AppLocalizations _l10n;

  final PlatformHelper platformHelper;

  final GameBloc _gameBloc;

  List<LeaderboardEntryData>? _entries;

  Future<void> preFetchLeaderboard() async {
    try {
      _entries = await leaderboardRepository.fetchTop10Leaderboard();
    } catch (_) {
      // An initial null leaderboard means that we couldn't fetch
      // the entries for the [Backbox] and it will show the relevant display.
      _entries = null;
    }
  }

  @override
  Future<void> onLoad() async {
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: _gameBloc,
          ),
          FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
            value: _characterThemeBloc,
          ),
        ],
        children: [
          MultiFlameProvider(
            providers: [
              FlameProvider<PinballAudioPlayer>.value(_audioPlayer),
              FlameProvider<LeaderboardRepository>.value(leaderboardRepository),
              FlameProvider<ShareRepository>.value(shareRepository),
              FlameProvider<AppLocalizations>.value(_l10n),
              FlameProvider<PlatformHelper>.value(platformHelper),
            ],
            children: [
              BonusNoiseBehavior(),
              GameBlocStatusListener(),
              BallSpawningBehavior(),
              CharacterSelectionBehavior(),
              CameraFocusingBehavior(),
              CanvasComponent(
                onSpritePainted: (paint) {
                  if (paint.filterQuality != FilterQuality.medium) {
                    paint.filterQuality = FilterQuality.medium;
                  }
                },
                children: [
                  ZCanvasComponent(
                    children: [
                      if (!platformHelper.isMobile) ArcadeBackground(),
                      BoardBackgroundSpriteComponent(),
                      Boundaries(),
                      Backbox(
                        leaderboardRepository: leaderboardRepository,
                        shareRepository: shareRepository,
                        entries: _entries,
                      ),
                      GoogleGallery(),
                      Multipliers(),
                      Multiballs(),
                      SkillShot(
                        children: [
                          ScoringContactBehavior(points: Points.oneMillion),
                          RolloverNoiseBehavior(),
                        ],
                      ),
                      AndroidAcres(),
                      DinoDesert(),
                      FlutterForest(),
                      SparkyScorch(),
                      Drain(),
                      BottomGroup(),
                      Launcher(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    await super.onLoad();
  }

  final focusedBoardSide = <int, BoardSide>{};

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    if (info.raw.kind == PointerDeviceKind.touch) {
      final rocket = descendants().whereType<RocketSpriteComponent>().first;
      final bounds = rocket.topLeftPosition & rocket.size;

      // NOTE: As long as Flame does not have https://github.com/flame-engine/flame/issues/1586
      // we need to check it at the highest level manually.
      final tappedRocket = bounds.contains(info.eventPosition.game.toOffset());
      if (tappedRocket) {
        descendants()
            .whereType<FlameBlocProvider<PlungerCubit, PlungerState>>()
            .first
            .bloc
            .pulled();
      } else {
        final leftSide = info.eventPosition.widget.x < canvasSize.x / 2;
        focusedBoardSide[pointerId] =
            leftSide ? BoardSide.left : BoardSide.right;
        final flippers = descendants().whereType<Flipper>().where((flipper) {
          return flipper.side == focusedBoardSide[pointerId];
        });
        flippers.first.moveUp();
      }
    }

    super.onTapDown(pointerId, info);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    _moveFlippersDown(pointerId);
    super.onTapUp(pointerId, info);
  }

  @override
  void onTapCancel(int pointerId) {
    _moveFlippersDown(pointerId);
    super.onTapCancel(pointerId);
  }

  void _moveFlippersDown(int pointerId) {
    if (focusedBoardSide[pointerId] != null) {
      final flippers = descendants().whereType<Flipper>().where((flipper) {
        return flipper.side == focusedBoardSide[pointerId];
      });
      flippers.first.moveDown();
      focusedBoardSide.remove(pointerId);
    }
  }
}

class DebugPinballGame extends PinballGame with FPSCounter, PanDetector {
  DebugPinballGame({
    required CharacterThemeCubit characterThemeBloc,
    required LeaderboardRepository leaderboardRepository,
    required ShareRepository shareRepository,
    required AppLocalizations l10n,
    required PinballAudioPlayer audioPlayer,
    required PlatformHelper platformHelper,
    required GameBloc gameBloc,
  }) : super(
          characterThemeBloc: characterThemeBloc,
          audioPlayer: audioPlayer,
          leaderboardRepository: leaderboardRepository,
          shareRepository: shareRepository,
          l10n: l10n,
          platformHelper: platformHelper,
          gameBloc: gameBloc,
        );

  Vector2? lineStart;
  Vector2? lineEnd;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(PreviewLine());

    await add(_DebugInformation());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (info.raw.kind == PointerDeviceKind.mouse) {
      final canvas = descendants().whereType<ZCanvasComponent>().single;
      final ball = Ball()..initialPosition = info.eventPosition.game;
      canvas.add(ball);
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    lineStart = info.eventPosition.game;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    lineEnd = info.eventPosition.game;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (lineEnd != null) {
      final line = lineEnd! - lineStart!;
      _turboChargeBall(line);
      lineEnd = null;
      lineStart = null;
    }
  }

  void _turboChargeBall(Vector2 line) {
    final canvas = descendants().whereType<ZCanvasComponent>().single;
    final ball = Ball()..initialPosition = lineStart!;
    final impulse = line * -1 * 10;
    ball.add(BallTurboChargingBehavior(impulse: impulse));
    canvas.add(ball);
  }
}

// coverage:ignore-start
class PreviewLine extends PositionComponent with HasGameRef<DebugPinballGame> {
  static final _previewLinePaint = Paint()
    ..color = Colors.pink
    ..strokeWidth = 0.4
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (gameRef.lineEnd != null) {
      canvas.drawLine(
        gameRef.lineStart!.toOffset(),
        gameRef.lineEnd!.toOffset(),
        _previewLinePaint,
      );
    }
  }
}

class _DebugInformation extends Component with HasGameRef<DebugPinballGame> {
  @override
  PositionType get positionType => PositionType.widget;

  final _debugTextPaint = TextPaint(
    style: const TextStyle(
      color: Colors.green,
      fontSize: 10,
    ),
  );

  final _debugBackgroundPaint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    final debugText = [
      'FPS: ${gameRef.fps().toStringAsFixed(1)}',
      'BALLS: ${gameRef.descendants().whereType<Ball>().length}',
    ].join(' | ');

    final height = _debugTextPaint.measureTextHeight(debugText);
    final position = Vector2(0, gameRef.camera.canvasSize.y - height);
    canvas.drawRect(
      position & Vector2(gameRef.camera.canvasSize.x, height),
      _debugBackgroundPaint,
    );
    _debugTextPaint.render(canvas, debugText, position);
  }
}
// coverage:ignore-end
