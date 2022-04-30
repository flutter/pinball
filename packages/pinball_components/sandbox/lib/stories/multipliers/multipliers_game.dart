import 'dart:math' as math;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class MultipliersGame extends BallGame with KeyboardEvents {
  MultipliersGame()
      : super(
          imagesFileNames: [
            Assets.images.multiplier.x2.lit.keyName,
            Assets.images.multiplier.x2.dimmed.keyName,
            Assets.images.multiplier.x3.lit.keyName,
            Assets.images.multiplier.x3.dimmed.keyName,
            Assets.images.multiplier.x4.lit.keyName,
            Assets.images.multiplier.x4.dimmed.keyName,
            Assets.images.multiplier.x5.lit.keyName,
            Assets.images.multiplier.x5.dimmed.keyName,
            Assets.images.multiplier.x6.lit.keyName,
            Assets.images.multiplier.x6.dimmed.keyName,
          ],
        );

  static const description = '''
    Shows how the Multipliers are rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press digits 2 to 6 for toggle state multipliers 2 to 6.
''';

  final List<Multiplier> multipliers = [
    Multiplier.x2(
      position: Vector2(-20, 0),
      angle: -15 * math.pi / 180,
    ),
    Multiplier.x3(
      position: Vector2(20, -5),
      angle: 15 * math.pi / 180,
    ),
    Multiplier.x4(
      position: Vector2(0, -15),
      angle: 0,
    ),
    Multiplier.x5(
      position: Vector2(-10, -25),
      angle: -3 * math.pi / 180,
    ),
    Multiplier.x6(
      position: Vector2(10, -35),
      angle: 8 * math.pi / 180,
    ),
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());

    await addAll(multipliers);
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

      for (final multiplier in multipliers) {
        multiplier.bloc.next(currentMultiplier);
      }

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
