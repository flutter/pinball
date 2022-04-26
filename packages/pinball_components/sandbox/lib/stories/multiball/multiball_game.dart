import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class MultiballGame extends BallGame with KeyboardEvents {
  MultiballGame()
      : super(
          imagesFileNames: [
            Assets.images.multiball.a.active.keyName,
            Assets.images.multiball.a.inactive.keyName,
            Assets.images.multiball.b.active.keyName,
            Assets.images.multiball.b.inactive.keyName,
            Assets.images.multiball.c.active.keyName,
            Assets.images.multiball.c.inactive.keyName,
            Assets.images.multiball.d.active.keyName,
            Assets.images.multiball.d.inactive.keyName,
          ],
        );

  static const description = '''
    Shows how the Multiball are rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press space bar for animate state multiballs.
''';

  late final Multiball _multiballA;
  late final Multiball _multiballB;
  late final Multiball _multiballC;
  late final Multiball _multiballD;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());

    await addAll([
      _multiballA = Multiball.a(),
      _multiballB = Multiball.b(),
      _multiballC = Multiball.c(),
      _multiballD = Multiball.d(),
    ]);
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      _multiballA.animate();
      _multiballB.animate();
      _multiballC.animate();
      _multiballD.animate();

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
