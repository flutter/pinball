import 'dart:async';

import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BasicPanelGame extends BasicGame {
  static const info = 'Simple example which renders the Panel';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    unawaited(add(Panel(position: Vector2(0, -5))));
  }
}
