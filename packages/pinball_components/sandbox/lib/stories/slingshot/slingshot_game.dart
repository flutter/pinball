import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SlingshotGame extends BasicBallGame {
  SlingshotGame({
    required this.trace,
  }) : super(color: const Color(0xFFFF0000));

  static const info = '''
    Shows how Slingshots are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  final bool trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);

    final leftUpperSlingshot = Slingshot(
      length: 5.66,
      angle: -1.5 * (math.pi / 180),
      spritePath: Assets.images.slingshot.leftUpper.keyName,
    )..initialPosition = center + Vector2(-29, 1.5);

    final leftLowerSlingshot = Slingshot(
      length: 3.54,
      angle: -29.1 * (math.pi / 180),
      spritePath: Assets.images.slingshot.leftLower.keyName,
    )..initialPosition = center + Vector2(-31, -6.2);

    final rightUpperSlingshot = Slingshot(
      length: 5.64,
      angle: 1 * (math.pi / 180),
      spritePath: Assets.images.slingshot.rightUpper.keyName,
    )..initialPosition = center + Vector2(22.3, 1.58);

    final rightLowerSlingshot = Slingshot(
      length: 3.46,
      angle: 26.8 * (math.pi / 180),
      spritePath: Assets.images.slingshot.rightLower.keyName,
    )..initialPosition = center + Vector2(24.7, -6.2);

    await addAll([
      leftUpperSlingshot,
      leftLowerSlingshot,
      rightUpperSlingshot,
      rightLowerSlingshot,
    ]);

    if (trace) {
      leftUpperSlingshot.trace();
      leftLowerSlingshot.trace();
      rightUpperSlingshot.trace();
      rightLowerSlingshot.trace();
    }
  }
}
