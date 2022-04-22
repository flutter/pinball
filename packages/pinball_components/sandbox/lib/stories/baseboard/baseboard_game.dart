import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BaseboardGame extends BasicBallGame with Traceable {
  static const info = '''
    Shows how the Baseboards are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.baseboard.left.keyName,
      Assets.images.baseboard.right.keyName,
    ]);

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final leftBaseboard = Baseboard(side: BoardSide.left)
      ..initialPosition = center - Vector2(25, 0)
      ..priority = 1;
    final rightBaseboard = Baseboard(side: BoardSide.right)
      ..initialPosition = center + Vector2(25, 0)
      ..priority = 1;

    await addAll([
      leftBaseboard,
      rightBaseboard,
    ]);

    await traceAllBodies();
  }
}
