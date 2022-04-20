import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BasicCameraZoomGame extends BasicGame with TapDetector {
  static const info = '''
    Shows how CameraZoom can be used.
      
    - Tap to zoom in/out.
  ''';

  bool zoomApplied = false;

  @override
  Future<void> onLoad() async {
    final sprite = await loadSprite(Assets.images.signpost.inactive.keyName);

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(4, 8),
        anchor: Anchor.center,
      ),
    );

    camera.followVector2(Vector2.zero());
  }

  @override
  void onTap() {
    if (firstChild<CameraZoom>() == null) {
      final zoom = CameraZoom(value: zoomApplied ? 30 : 10);
      add(zoom);
      zoomApplied = !zoomApplied;
    }
  }
}
