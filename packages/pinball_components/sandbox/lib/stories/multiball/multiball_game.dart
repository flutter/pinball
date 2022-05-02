import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class MultiballGame extends BallGame with KeyboardEvents {
  MultiballGame()
      : super(
          imagesFileNames: [
            Assets.images.multiball.lit.keyName,
            Assets.images.multiball.dimmed.keyName,
          ],
        );

  static const description = '''
    Shows how the Multiball are rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press space bar to animate multiballs.
''';

  final List<Multiball> multiballs = [
    Multiball.a(),
    Multiball.b(),
    Multiball.c(),
    Multiball.d(),
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());

    await addAll(multiballs);
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      for (final multiball in multiballs) {
        multiball.bloc.onBlink();
      }

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
