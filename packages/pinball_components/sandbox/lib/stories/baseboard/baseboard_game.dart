import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BaseboardGame extends BallGame {
  BaseboardGame()
      : super(
          imagesFileNames: [
            Assets.images.baseboard.left.keyName,
            Assets.images.baseboard.right.keyName,
          ],
        );

  static const description = '''
    Shows how the Baseboards are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    await addAll([
      Baseboard(side: BoardSide.left)
        ..initialPosition = center - Vector2(25, 0)
        ..priority = 1,
      Baseboard(side: BoardSide.right)
        ..initialPosition = center + Vector2(25, 0)
        ..priority = 1,
    ]);

    await traceAllBodies();
  }
}
