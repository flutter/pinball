import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template focus_data}
/// Defines a [Camera] focus point.
/// {@endtemplate}
class FocusData {
  /// {@template focus_data}
  FocusData({
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
    with ParentIsA<FlameGame>, BlocComponent<GameBloc, GameState> {
  late final Map<String, FocusData> _foci;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return previousState?.status != newState.status;
  }

  @override
  void onNewState(GameState state) {
    switch (state.status) {
      case GameStatus.waiting:
        break;
      case GameStatus.playing:
        _zoom(_foci['game']!);
        break;
      case GameStatus.gameOver:
        _zoom(_foci['backbox']!);
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _foci = {
      'game': FocusData(
        zoom: parent.size.y / 16,
        position: Vector2(0, -7.8),
      ),
      'waiting': FocusData(
        zoom: parent.size.y / 18,
        position: Vector2(0, -112),
      ),
      'backbox': FocusData(
        zoom: parent.size.y / 10,
        position: Vector2(0, -111),
      ),
    };

    _snap(_foci['waiting']!);
  }

  void _snap(FocusData data) {
    parent.camera
      ..speed = 100
      ..followVector2(data.position)
      ..zoom = data.zoom;
  }

  void _zoom(FocusData data) {
    final zoom = CameraZoom(value: data.zoom);
    zoom.completed.then((_) {
      parent.camera.moveTo(data.position);
    });
    add(zoom);
  }
}
