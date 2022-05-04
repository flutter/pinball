import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds helpers methods to Flame's [Camera].
extension CameraX on Camera {
  /// Instantly apply the point of focus to the [Camera].
  void snapToFocus(FocusData data) {
    followVector2(data.position);
    zoom = data.zoom;
  }

  /// Returns a [CameraZoom] that can be added to a [FlameGame].
  CameraZoom focusToCameraZoom(FocusData data) {
    final zoom = CameraZoom(value: data.zoom);
    zoom.completed.then((_) {
      moveTo(data.position);
    });
    return zoom;
  }
}

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

/// {@template camera_controller}
/// A [Component] that controls its game camera focus.
/// {@endtemplate}
class CameraController extends ComponentController<FlameGame> {
  /// {@macro camera_controller}
  CameraController(FlameGame component) : super(component) {
    final gameZoom = component.size.y / 16;
    final waitingBackboxZoom = component.size.y / 18;
    final gameOverBackboxZoom = component.size.y / 10;

    gameFocus = FocusData(
      zoom: gameZoom,
      position: Vector2(0, -7.8),
    );
    waitingBackboxFocus = FocusData(
      zoom: waitingBackboxZoom,
      position: Vector2(0, -112),
    );
    gameOverBackboxFocus = FocusData(
      zoom: gameOverBackboxZoom,
      position: Vector2(0, -111),
    );

    // Game starts with the camera focused on the [Backbox].
    component.camera
      ..speed = 100
      ..snapToFocus(waitingBackboxFocus);
  }

  /// Holds the data for the game focus point.
  late final FocusData gameFocus;

  /// Holds the data for the waiting backbox focus point.
  late final FocusData waitingBackboxFocus;

  /// Holds the data for the game over backbox focus point.
  late final FocusData gameOverBackboxFocus;

  /// Move the camera focus to the game board.
  void focusOnGame() {
    component.add(component.camera.focusToCameraZoom(gameFocus));
  }

  /// Move the camera focus to the waiting backbox.
  void focusOnWaitingBackbox() {
    component.add(component.camera.focusToCameraZoom(waitingBackboxFocus));
  }

  /// Move the camera focus to the game over backbox.
  void focusOnGameOverBackbox() {
    component.add(component.camera.focusToCameraZoom(gameOverBackboxFocus));
  }
}
