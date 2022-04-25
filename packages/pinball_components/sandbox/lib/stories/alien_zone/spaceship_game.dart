import 'dart:async';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/common/common.dart';

class SpaceshipGame extends AssetsGame with TapDetector {
  static const description = '''
    Shows how a Spaceship works.
      
    - Tap anywhere on the screen to spawn a Ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await addFromBlueprint(
      Spaceship(position: Vector2.zero()),
    );
    await ready();
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball(baseColor: Colors.blue)
        ..initialPosition = info.eventPosition.game
        ..layer = Layer.spaceshipEntranceRamp,
    );
  }
}
