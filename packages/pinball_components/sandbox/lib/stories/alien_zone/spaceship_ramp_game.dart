import 'dart:async';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SpaceshipRampGame extends BallGame with KeyboardEvents {
  SpaceshipRampGame()
      : super(
          color: Colors.blue,
          ballPriority: RenderPriority.ballOnSpaceshipRamp,
          ballLayer: Layer.spaceshipEntranceRamp,
          imagesFileNames: [
            Assets.images.spaceship.ramp.railingBackground.keyName,
            Assets.images.spaceship.ramp.main.keyName,
            Assets.images.spaceship.ramp.boardOpening.keyName,
            Assets.images.spaceship.ramp.railingForeground.keyName,
            Assets.images.spaceship.ramp.arrow.inactive.keyName,
            Assets.images.spaceship.ramp.arrow.active1.keyName,
            Assets.images.spaceship.ramp.arrow.active2.keyName,
            Assets.images.spaceship.ramp.arrow.active3.keyName,
            Assets.images.spaceship.ramp.arrow.active4.keyName,
            Assets.images.spaceship.ramp.arrow.active5.keyName,
          ],
        );

  static const description = '''
    Shows how SpaceshipRamp is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press space to progress arrow sprites.
''';

  late final SpaceshipRamp _spaceshipRamp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2(-12, -50));
    await addFromBlueprint(
      _spaceshipRamp = SpaceshipRamp(),
    );
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      _spaceshipRamp.progress();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
