import 'dart:async';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ZoomCameraGame extends BasicGame with TapDetector {
  static const info = 'Shows how the zoom works, tap to zoom in/out';

  bool zoomed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    unawaited(add(Panel(position: Vector2(0, -5))));
  }

  @override
  void onTap() {
    if (firstChild<CameraZoom>() == null) {
      unawaited(add(CameraZoom(value: zoomed ? 10 : 20)));
      zoomed = !zoomed;
    }
  }
}
