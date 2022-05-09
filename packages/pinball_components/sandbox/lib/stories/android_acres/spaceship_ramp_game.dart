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
          ballPriority: ZIndexes.ballOnSpaceshipRamp,
          ballLayer: Layer.spaceshipEntranceRamp,
          imagesFileNames: [
            Assets.images.android.ramp.railingBackground.keyName,
            Assets.images.android.ramp.main.keyName,
            Assets.images.android.ramp.boardOpening.keyName,
            Assets.images.android.ramp.railingForeground.keyName,
            Assets.images.android.ramp.arrow.inactive.keyName,
            Assets.images.android.ramp.arrow.active1.keyName,
            Assets.images.android.ramp.arrow.active2.keyName,
            Assets.images.android.ramp.arrow.active3.keyName,
            Assets.images.android.ramp.arrow.active4.keyName,
            Assets.images.android.ramp.arrow.active5.keyName,
          ],
        );

  static const description = '''
    Shows how SpaceshipRamp is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press space to progress arrow sprites.
''';

  @override
  Color backgroundColor() => Colors.white;

  late final SpaceshipRamp _spaceshipRamp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2(-12, -50));

    _spaceshipRamp = SpaceshipRamp();
    await add(_spaceshipRamp);
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      _spaceshipRamp
          .readBloc<SpaceshipRampCubit, SpaceshipRampState>()
          .onProgressed();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
