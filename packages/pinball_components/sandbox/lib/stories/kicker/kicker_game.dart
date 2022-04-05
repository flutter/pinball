import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class KickerGame extends BasicBallGame {
  KickerGame({
    required this.trace,
  }) : super(color: const Color(0xFFFF0000));

  static const info = '''
    Shows how Kickers are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  final bool trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);

    final leftKicker = Kicker(side: BoardSide.left)
      ..initialPosition = Vector2(center.x - (Kicker.size.x * 2), center.y);
    await add(leftKicker);

    final rightKicker = Kicker(side: BoardSide.right)
      ..initialPosition = Vector2(center.x + (Kicker.size.x * 2), center.y);
    await add(rightKicker);

    if (trace) {
      leftKicker.trace();
      rightKicker.trace();
    }
  }
}
