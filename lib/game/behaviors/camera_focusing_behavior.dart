import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template focus_data}
/// Defines a [Camera] focus point.
/// {@endtemplate}
class _FocusData {
  /// {@macro focus_data}
  const _FocusData({
    required this.zoom,
    required this.position,
  });

  /// The amount of zoom.
  final double zoom;

  /// The position of the camera.
  final Vector2 position;
}

/// Changes the game focus when the [GameBloc] status changes.
class CameraFocusingBehavior extends Component
    with FlameBlocListenable<GameBloc, GameState>, HasGameRef {
  final Map<GameStatus, _FocusData> _foci = {};

  GameStatus? _activeFocus;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.status != newState.status;
  }

  @override
  void onNewState(GameState state) => _zoomTo(state.status);

  @override
  void onGameResize(Vector2 size) {
    _foci.addAll(
      {
        GameStatus.waiting: _FocusData(
          zoom: size.y / 175,
          position: _foci[GameStatus.waiting]?.position ?? Vector2(0, -112),
        ),
        GameStatus.playing: _FocusData(
          zoom: size.y / 165,
          position: _foci[GameStatus.playing]?.position ?? Vector2(0, -7.8),
        ),
        GameStatus.gameOver: _FocusData(
          zoom: size.y / 100,
          position: _foci[GameStatus.gameOver]?.position ?? Vector2(0, -111),
        ),
      },
    );

    if (_activeFocus != null) {
      _zoomTo(_activeFocus!);
    }

    super.onGameResize(size);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _snap(GameStatus.waiting);
  }

  void _snap(GameStatus focusKey) {
    _activeFocus = focusKey;
    final focusData = _foci[_activeFocus]!;

    gameRef.camera
      ..speed = 100
      ..followVector2(focusData.position)
      ..zoom = focusData.zoom;
  }

  void _zoomTo(GameStatus focusKey) {
    _activeFocus = focusKey;
    final focusData = _foci[_activeFocus]!;

    final zoom = CameraZoom(value: focusData.zoom);
    zoom.completed.then((_) {
      gameRef.camera.moveTo(focusData.position);
    });
    add(zoom);
  }
}
