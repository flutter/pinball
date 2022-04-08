import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball_components/pinball_components.dart';

/// Adds helpers methods to Flame's [Camera]
extension CameraX on Camera {
  /// Instantly apply the point of focus to the [Camera]
  void snapToFocus(FocusData data) {
    followVector2(data.position);
    zoom = data.zoom;
  }

  /// Returns a [CameraZoom] that can be added to a [FlameGame]
  CameraZoom focusToCameraZoom(FocusData data) {
    final zoom = CameraZoom(value: data.zoom);
    zoom.completed.then((_) {
      moveTo(data.position);
    });
    return zoom;
  }
}

/// {@template focus_data}
/// Model class that defines a focus point of the camera
/// {@endtemplate}
class FocusData {
  /// {@template focus_data}
  FocusData({
    required this.zoom,
    required this.position,
  });

  /// The amount of zoom
  final double zoom;

  /// The position of the camera
  final Vector2 position;
}

/// {@template camera_controller}
/// A [Component] that controls its game camera focus
/// {@endtemplate}
class CameraController extends ComponentController<FlameGame> {
  /// {@macro camera_controller}
  CameraController(FlameGame component) : super(component) {
    final gameZoom = component.size.y / 16;
    final backboardZoom = component.size.y / 18;

    gameFocus = FocusData(
      zoom: gameZoom,
      position: Vector2(0, -7.8),
    );
    backboardFocus = FocusData(
      zoom: backboardZoom,
      position: Vector2(0, -100.8),
    );

    // Game starts with the camera focused on the panel
    component.camera
      ..speed = 100
      ..snapToFocus(backboardFocus);
  }

  /// Holds the data for the game focus point
  late final FocusData gameFocus;

  /// Holds the data for the backboard focus point
  late final FocusData backboardFocus;

  /// Move the camera focus to the game board
  void focusOnGame() {
    component.add(component.camera.focusToCameraZoom(gameFocus));
  }

  /// Move the camera focus to the backboard
  void focusOnBackboard() {
    component.add(component.camera.focusToCameraZoom(backboardFocus));
  }
}
