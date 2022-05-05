import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template focus_data}
/// Model class that defines a focus point of the camera.
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

///
class CameraFocusingBehavior extends Component
    with ParentIsA<FlameGame>, BlocComponent<GameBloc, GameState> {
  final Map<String, FocusData> _focuses = {};

  // @override
  // bool listenWhen(GameState? previousState, GameState newState) {
  //   print('listen');
  //   return true;
  //   return previousState?.isGameOver != newState.isGameOver;
  // }

  @override
  void onNewState(GameState state) {
    print(state);
    if (state.isGameOver) {
      _zoom(_focuses['backbox']!);
    } else {
      _zoom(_focuses['game']!);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _focuses['game'] = FocusData(
      zoom: parent.size.y / 16,
      position: Vector2(0, -7.8),
    );
    _focuses['waiting'] = FocusData(
      zoom: parent.size.y / 18,
      position: Vector2(0, -112),
    );
    _focuses['backbox'] = FocusData(
      zoom: parent.size.y / 10,
      position: Vector2(0, -111),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _snap(_focuses['waiting']!);
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
    parent.add(zoom);
  }
}
