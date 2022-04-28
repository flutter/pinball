import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class MultipliersGame extends BallGame with KeyboardEvents {
  MultipliersGame()
      : super(
          imagesFileNames: [
            Assets.images.multiplier.x2.active.keyName,
            Assets.images.multiplier.x2.inactive.keyName,
            Assets.images.multiplier.x3.active.keyName,
            Assets.images.multiplier.x3.inactive.keyName,
            Assets.images.multiplier.x4.active.keyName,
            Assets.images.multiplier.x4.inactive.keyName,
            Assets.images.multiplier.x5.active.keyName,
            Assets.images.multiplier.x5.inactive.keyName,
            Assets.images.multiplier.x6.active.keyName,
            Assets.images.multiplier.x6.inactive.keyName,
          ],
        );

  static const description = '''
    Shows how the Multipliers are rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press digits 2 to 6 for toggle state multipliers 2 to 6.
''';

  late final Multiplier x2;
  late final Multiplier x3;
  late final Multiplier x4;
  late final Multiplier x5;
  late final Multiplier x6;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());

    x2 = Multiplier(
      value: 2,
      position: Vector2(-20, 0),
    );
    x3 = Multiplier(
      value: 3,
      position: Vector2(20, -5),
    );
    x4 = Multiplier(
      value: 4,
      position: Vector2(0, -15),
    );
    x5 = Multiplier(
      value: 5,
      position: Vector2(-10, -25),
    );
    x6 = Multiplier(
      value: 6,
      position: Vector2(10, -35),
    );

    await addAll([x2, x3, x4, x5, x6]);
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      var currentMultiplier = 1;

      if (event.logicalKey == LogicalKeyboardKey.digit2) {
        currentMultiplier = 2;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit3) {
        currentMultiplier = 3;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit4) {
        currentMultiplier = 4;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit5) {
        currentMultiplier = 5;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit6) {
        currentMultiplier = 6;
      }

      x2.toggle(currentMultiplier);
      x3.toggle(currentMultiplier);
      x4.toggle(currentMultiplier);
      x5.toggle(currentMultiplier);
      x6.toggle(currentMultiplier);

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
